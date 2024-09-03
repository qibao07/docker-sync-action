#!/bin/bash

force_image=$1

skopeo --version

mkdir -p finish.images

while IFS= read -r line
do
  [[ -z "$line" ]] && continue
  [[ $line =~ ^# ]] && continue
  force=$(echo "$line" | awk '{print $2}')
  image=$(echo "$line" | awk '{print $1}')
  image_name_tag=$(echo "$image" | awk -F'/' '{print $NF}')
  image_file_name="finish.images/$(echo "$image" | sed 's/[\/:]/./g')"
  if [[ -n $force ]] || [ "$image" == "$force_image" ] || [ ! -e "$image_file_name" ]; then
    echo "同步镜像：$image"
    skopeo copy --all --dest-creds ${ALIYUN_REGISTRY_USER}:${ALIYUN_REGISTRY_PASSWORD} \
      docker://${image} \
      docker://${ALIYUN_REGISTRY}/${ALIYUN_NAME_SPACE}/${image_name_tag}
    touch ${image_file_name}
  else
    echo "跳过镜像：$image"
  fi
done < "images.txt"
