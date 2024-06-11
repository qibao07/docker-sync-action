#!/bin/bash

skopeo --version

while IFS= read -r line
do
  [[ -z "$line" ]] && continue
  echo "$line"
  image=$(echo "$line" | awk '{print $NF}')
  image_name_tag=$(echo "$image" | awk -F'/' '{print $NF}')
  skopeo copy --all --dest-creds ${ALIYUN_REGISTRY_USER}:${ALIYUN_REGISTRY_PASSWORD} \
    docker://${image} \
    docker://${ALIYUN_REGISTRY}/${ALIYUN_NAME_SPACE}/${image_name_tag}
done < "images.txt"
