## 下载qemu镜像

需要先下载图里的这两

![alt text](https://8.219.13.0/download/%E8%AE%B0%E5%8F%82%E4%B8%8E%E7%AC%AC%E4%BA%8C%E6%9C%9F%E5%82%B2%E6%9D%A5%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F%EF%BC%88EulixOS%EF%BC%89%E8%AE%AD%E7%BB%83%E8%90%A5/1748000307072_image.png)

<https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS/virtual_machine_img/riscv64/>

然后再下载qemu镜像，放在了阿里云盘，有时间限制（阿里云盘的时间限制，仅有1天有效期）

<https://www.alipan.com/t/35GoJzvFarTltufN21JK>

## 启动虚拟机

```shell
qemu-system-riscv64 -machine virt,pflash0=pflash0,pflash1=pflash1,acpi=off -smp 12 -m 4G -blockdev node-name=pflash0,driver=file,read-only=on,filename=RISCV_VIRT_CODE.fd -blockdev node-name=pflash1,driver=file,filename=RISCV_VIRT_VARS.fd -drive file=openEuler-24.03-LTS-riscv64-minIO-and-django.qcow2,format=qcow2,id=hd0,if=none -device virtio-vga -device virtio-rng-device -device virtio-blk-device,drive=hd0,bootindex=1 -device virtio-net-device,netdev=usernet -netdev user,id=usernet,hostfwd=tcp::2222-:22,hostfwd=tcp::9000-:9000,hostfwd=tcp::9001-:9001 -device qemu-xhci -usb -device usb-kbd -device usb-tablet -display none -daemonize
```

## 进入到django

```shell
ssh root@localhost -p 2222 # 密码为 9966
su emt
cd ~/django # 里面即为适配过程所使用的环境
ls -l ./dist # 查看构建出来的whl
```

## 进入到minIO

```shell
ssh root@localhost -p 2222 # 密码为 9966
su emt
cd ~/minio # 里面即为适配所使用的环境

file ./minio

./minio --version


./minio server ~/data # 启动minio
```
