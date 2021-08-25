#!/bin/bash

# Downloads the all artifacts ('build/robot') of
# Jenkins 'lastSuccesfullBuild'. Assumes a writeable
# /tmp directory and the destination must exist.

usage() {
    echo "$(basename "$0") <optional: /path/to/extract/to>"
    echo ""
    echo "Downloads the all artifacts ('build/robot') of Jenkins 'lastSuccesfullBuild'"
    echo "to the given destination. Default: fixtures/"
    echo ""
}

destination="${1:-fixtures}"
branch=nightly
job=RIOT-HIL
now="$(date +"%m-%d-%Y-%H-%M")"

if [ ! -d "$destination" ] || [ ! -w "$destination" ]; then
    echo "ERROR: Directory doesn't exist or is not writeable: '$destination'"
    exit 1
fi

jenkins_url_branch="https://hil.riot-os.org/jenkins/job/${job}/job/${branch}"
jenkins_lsb_nr="$(curl -s -X GET ${jenkins_url_branch}/lastSuccessfulBuild/buildNumber)"
jenkins_url_lsb_archive="${jenkins_url_branch}/${jenkins_lsb_nr}/artifact/*zip*/archive.zip"

set -e

mkdir -p "/tmp/artifacts-${now}/"
wget -P "/tmp/artifacts-${now}" "${jenkins_url_lsb_archive}"

mkdir -p "${destination}/${branch}/builds/${jenkins_lsb_nr}/archive/"
cd "${destination}/${branch}/builds/${jenkins_lsb_nr}/archive/"
bsdtar -xf "/tmp/artifacts-${now}/archive.zip" -s'|[^/]*/||'
