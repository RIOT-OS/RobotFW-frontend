#!/bin/bash

# A xsltproc wrapper script to create HTML files
# from a RobotFramework results directory.

usage() {
    echo "$(basename "$0") -s </.../main.xsl> -c </.../config.xml> -p <overview|log|report>"
    echo "                 -u <path/prefix> -v </.../build/robot>"
    echo ""
    echo "  -s   Full path to main XSL stylesheet."
    echo "  -c   Full path to config XML file."
    echo "  -u   Path prefix to append between base_url and relative paths."
    echo "  -p   (Optional) One of overview|log|report. Can be passed multiple times."
    echo "  -v   Verbose output with timing."
    echo "  -h   Show this help."
    echo ""
}

validate_file_param() {
    if [ -n "${1}" ] && [ -r "${1}" ]; then return; fi
    if [ -z "${1}" ]; then
        echo "Missing mandatory option: ${2}"
    elif [ ! -r "${1}" ]; then
        echo "ERROR: File doesn't exist or is not readable: '${1}'"
    fi
    false
}

transform() {
    input_filepath="$1"
    output_filepath="$2"
    page="$3"

    xsltproc --output "${output_filepath}" ${verbose:+ "$verbose"} \
             --stringparam project-basedir "${base_dir}" \
             --stringparam xml-basedir "${destination_path}" \
             --stringparam config "${config_file}" \
             --stringparam page "${page}" \
             --stringparam path-prefix "${path_prefix}" \
             "${xsl_stylesheet}" "${input_filepath}"
}

base_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" &> /dev/null && pwd )"
xsl_stylesheet="${base_dir}/xsl/main.xsl"
config_file="${base_dir}/config.xml"
path_prefix=""
verbose=""
pages=()

while getopts "s:c:u:p:vh" opt; do
  case ${opt} in
    s) xsl_stylesheet="$OPTARG";;
    c) config_file="$OPTARG";;
    u) path_prefix="$OPTARG";;
    p) pages+=("$OPTARG");;
    v) verbose+="--timing";;
    h) usage; exit 0;;
    \?) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    :) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
  esac
done

shift $((OPTIND - 1))

destination_path="${1%/}"  # Remove trailing slash if it exists
param_validation_failed=false

# Relative paths are resolved from the location of $xsl_stylesheet
# so lets get there before the parameters are checked.
cd "${xsl_stylesheet%/*}"

validate_file_param "$xsl_stylesheet" "-s" 
if [ "$?" = 1 ]; then param_validation_failed=true; fi

validate_file_param "$config_file" "-c"
if [ "$?" = 1 ]; then param_validation_failed=true; fi

if [ -z "${destination_path}" ]; then
    echo "Missing argument: destination"
    param_validation_failed=true
elif [ ! -d "$destination_path" ] && [ ! -w "$destination_path" ]; then
    echo "ERROR: destination doesn't exist or isn't writeable: '${destination_path}'"
    param_validation_failed=true
fi

if [ "${param_validation_failed}" = true ]; then
    echo "Exiting"
    exit 1
fi

cd "${base_dir}"

# Transform all pages if -p is not set
if [ -z "${pages[*]}" ]; then pages=(overview report log); fi

# Finally generate the pages
if [[ "${pages[*]}" =~ "overview" ]]; then
    transform "${destination_path}/robot.xml" "${destination_path}/overview.html" "overview"
fi

for current_dir in "$destination_path"/**/*; do
    if [ -d "$current_dir" ]; then
        if [[ "${pages[*]}" =~ "report" ]]; then
            transform "${current_dir}/output.xml" "${current_dir}/report.html" "report"
        fi
        if [[ "${pages[*]}" =~ "log" ]]; then
            transform "${current_dir}/output.xml" "${current_dir}/log.html" "log"
        fi
    fi
done
