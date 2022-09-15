#!/bin/bash

# based on: https://gist.github.com/jaytaylor/86d5efaddda926a25fa68c263830dac1
# changes: 
# - iterate over tag list instead of using only first one
# - added basic auth
# - fixed http header to 'docker-content-digest'


# exit when any command fails
set -e

registry='localhost:5000'

# concants all images listed in json file into single line string seperated with blank
images="image image2..."

echo "Registry User:"
read user
echo "Registry Password:"
read -s password

for image in $images; do
    echo "DELETING: " $image

    # get tag list of image, with fallback to empty array when value is null
    tags=$(curl --user $user:$password "https://${registry}/v2/${image}/tags/list" | jq -r '.tags // [] | .[]' | tr '\n' ' ')

    # check for empty tag list, e.g. when already cleaned up
    if [[ -n $tags ]]
    then
        for tag in $tags; do
            curl --user $user:$password -X DELETE "https://${registry}/v2/${image}/manifests/$(
                curl --user $user:$password -I \
                    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
                    "https://${registry}/v2/${image}/manifests/${tag}" \
                | awk '$1 == "Docker-Content-Digest:" { print $2 }' \
                | tr -d $'\r' \
            )"
        done

        echo "DONE:" $image
    else
        echo "SKIP:" $image
    fi
done
