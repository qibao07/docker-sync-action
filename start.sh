#!/bin/bash

force_image=$1

skopeo --version

mkdir -p finish.images

function syncImage() {
  force=$2
  image=$1
  image_name_tag=$(echo "$image" | awk -F'/' '{print $NF}')
  image_file_name="finish.images/$(echo "$image" | sed 's/[\/:]/./g')"
  image_digest=$(skopeo inspect docker://${image} | grep Digest | head -n 1 | awk -F '"' '{print $4}')
  # 镜像复制触发条件
  # 1. images.txt指定force
  # 2. 手动触发参数指定
  # 3. 缓存未标记完成
  # 4. 缓存标记但digest发生变化
  if [[ -n "$force" ]] || [ ! -e "$image_file_name" ] || [ "$(cat $image_file_name)" != "$image_digest" ]; then
    echo "同步镜像：$image"
    skopeo copy --all --dest-creds ${ALIYUN_REGISTRY_USER}:${ALIYUN_REGISTRY_PASSWORD} \
      docker://${image} \
      docker://${ALIYUN_REGISTRY}/${ALIYUN_NAME_SPACE}/${image_name_tag}
    echo "$image_digest" > ${image_file_name}
  else
    echo "跳过镜像：$image"
  fi
}

fi [[ -n "$force_image" ]]; then
  syncImage "$image" "1"
  exit 0
fi

while IFS= read -r line
do
  [[ -z "$line" ]] && continue
  [[ $line =~ ^# ]] && continue
  force=$(echo "$line" | awk '{print $2}')
  image=$(echo "$line" | awk '{print $1}')
  syncImage "$image" "$force"
done < "images.txt"
