#!/bin/bash

# A xsltproc wrapper script to create HTML files
# from a RobotFramework results directory.

# Check dependencies
command -v xsltproc >/dev/null 2>&1 || { echo >&2 "ERROR: xsltproc is not installed. Exiting"; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "ERROR: git is not installed. Exiting"; exit 1; }

usage() {
    echo "$(basename "$0") -s </.../main.xsl> -c </.../config.xml> -b <branch> -n <number>"
    echo "                 [-p <overview|log|report>] [-u <path/prefix>] [-f] [-d] [-v] </.../build/robot>"
    echo ""
    echo "  -s   Full path to main XSL stylesheet"
    echo "  -c   Full path to config XML file"
    echo "  -b   Jenkins branch"
    echo "  -n   Jenkins job number"
    echo "  -l   (Optional) Apply on last n jenkins build directories"
    echo "  -u   (Optional) Path prefix to append between base_url and relative paths"
    echo "  -p   (Optional) One of overview|log|report. Can be passed multiple times"
    echo "  -f   (Optional) Force rebuild"
    echo "  -d   (Optional) Do a dry run"
    echo "  -v   (Optional) Verbose output"
    echo "  -h   Show this help"
    echo ""
}

validate_file_param() {
    if [ -n "${1}" ] && [ -r "${1}" ]; then return; fi
    if [ -z "${1}" ]; then
        echo "ERROR: Missing mandatory option: ${2}"
    elif [ ! -r "${1}" ]; then
        echo "ERROR: File doesn't exist or is not readable: '${1}'"
    fi
    false
}

transform() {
    input_filepath="$1"
    output_filepath="$2"
    page="$3"

    if [ "${dry_run}" = true ]; then
        if ! [ -z "${verbose}" ]; then
            echo "${output_filepath}"
        fi
    else
        xsltproc --output "${output_filepath}" ${verbose:+ "$verbose"} \
                 --stringparam project-basedir "${base_dir}" \
                 --stringparam xml-basedir "${artifacts_path}" \
                 --stringparam config "${config_file}" \
                 --stringparam page "${page}" \
                 --stringparam path-prefix "${path_prefix}" \
                 "${xsl_stylesheet}" "${input_filepath}"
    fi
}

base_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" &> /dev/null && pwd )"
xsl_stylesheet="${base_dir}/xsl/main.xsl"
config_file="${base_dir}/config.xml"
branch=""
build_nr=""
last_n_builds=1
path_prefix=""
recreate_latest=true
force_rebuild=false
dry_run=false
verbose=""
pages=()

while getopts "s:c:b:n:l:u:p:fdvh" opt; do
  case ${opt} in
    s) xsl_stylesheet="$OPTARG";;
    c) config_file="$OPTARG";;
    b) branch="$OPTARG";;
    n) build_nr="$OPTARG";;
    l) last_n_builds="$OPTARG";;
    u) path_prefix="$OPTARG";;
    p) pages+=("$OPTARG");;
    f) force_rebuild=true;;
    d) dry_run=true;;
    v) verbose+="--timing";;
    h) usage; exit 0;;
    \?) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    :) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
  esac
done

shift $((OPTIND - 1))

content_path="${1%/}"  # Remove trailing slash if it exists
param_validation_failed=false

if [ -z "${path_prefix}" ]; then
    path_prefix="${branch}/${build_nr}"
fi

# Relative paths are resolved from the location of $xsl_stylesheet
# so lets get there before the parameters are checked.
cd "${xsl_stylesheet%/*}"

validate_file_param "${xsl_stylesheet}" "-s"
if [ "$?" = 1 ]; then param_validation_failed=true; fi

validate_file_param "${config_file}" "-c"
if [ "$?" = 1 ]; then param_validation_failed=true; fi

if [ -z "${content_path}" ]; then
    echo "ERROR: missing argument: destination"
    param_validation_failed=true
elif [ ! -d "${content_path}" ] && [ ! -w "${content_path}" ]; then
    echo "ERROR: destination doesn't exist or isn't writeable: '${content_path}'"
    param_validation_failed=true
fi

if [[ "${last_n_builds}" != ?(-)+([0-9]) ]]; then
    echo "ERROR: option -l must be a integer."
    param_validation_failed=true
fi

if [ "${param_validation_failed}" = true ]; then
    echo "Exiting"
    exit 1
fi

cd "${base_dir}"

# Transform all pages if -p is not set
# if [ -z "${pages[*]}" ]; then pages=(overview report log); fi
if [ -z "${pages[*]}" ]; then pages=(overview report log); fi

# Finally generate the pages
start=`date +%s`

while [[ ${last_n_builds}>0 ]]; do
    artifacts_path="${content_path}/${branch}/builds/${build_nr}/archive/build/robot"

    if [ -d "${artifacts_path}" ]; then
        current_commit_id="$(git rev-parse HEAD)"
        version_file="${artifacts_path}/frontend_version"
        frontend_version="$(head -n 1 "${version_file}")"

        if [ "${current_commit_id}" != "${frontend_version}" ] || [ "${force_rebuild}" = true ]; then
            if [ "${dry_run}" = true ]; then echo "------- DRY RUN -------"; fi
            echo "Process ${artifacts_path}"

            if [[ "${pages[*]}" =~ "overview" ]]; then
                transform "${artifacts_path}/robot.xml" "${artifacts_path}/overview.html" "overview"
            fi

            count=1
            for current_dir in "${artifacts_path}"/**/*; do
                if [ -d "${current_dir}" ]; then
                    if [[ "${pages[*]}" =~ "report" ]]; then
                        transform "${current_dir}/output.xml" "${current_dir}/report.html" "report"
                        ((count++))
                    fi
                    if [[ "${pages[*]}" =~ "log" ]]; then
                        transform "${current_dir}/output.xml" "${current_dir}/log.html" "log"
                        ((count++))
                    fi
                fi
            done

            end=`date +%s`
            echo "Transforming ${count} files took $((end-start))s"
            echo "${current_commit_id}" > "${version_file}"

            # Copy results directory to '/latest' and recursively find and replace
            # '<build_nr>' with 'latest' in all html files.
            if [ "${recreate_latest}" = true ] && [ -d "${artifacts_path}" ]; then
                start=`date +%s`
                latest_path="${content_path}/${branch}/builds/latest/archive/build"

                if [ "${dry_run}" = false ]; then
                    if [ -d "${latest_path}" ]; then
                        rm -rf "${latest_path}"
                    fi

                    mkdir -p "${latest_path}"
                    cp -rp "${artifacts_path}" "${latest_path}"
                    cd "${latest_path}"
                    find . -type f -name "*.html" -exec sed -i "s#${branch}/${build_nr}#${branch}/latest#g" {} +
                fi

                end=`date +%s`
                echo "Recreating 'latest' directory took $((end-start))s"
            fi
        else
            echo "Skipped ${artifacts_path} (ALREADY_UP_TO_DATE)"
        fi
    else
        echo "Skipped ${artifacts_path} (NOT_FOUND)"
    fi

    recreate_latest=false
    ((build_nr--))
    ((last_n_builds--))
done
