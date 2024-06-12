# DockerHub镜像同步

## 使用

获取[阿里容器镜像服务](https://cr.console.aliyun.com/)参数，配置到action保密变量中.

* 用户名：${{ secrets.ALIYUN_REGISTRY_USER }}
* 密码：${{ secrets.ALIYUN_REGISTRY_PASSWORD}}
* 仓库地址：${{ secrets.ALIYUN_REGISTRY}}
* 命名空间：${{ secrets.ALIYUN_REGISTRY_USER }}

## 说明

需要同步的镜像填写到`images.txt`即可，默认每日周一同步一次，也可以手动触发。

## 参考

[tech-shrimp/docker_image_pusher](https://github.com/tech-shrimp/docker_image_pusher)