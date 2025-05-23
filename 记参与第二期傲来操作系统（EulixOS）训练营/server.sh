#! /bin/bash

echo "install deps"
sudo dnf install qemu-kvm qemu xz curl podman sshpass -y

echo "ready to pull openeuler 24 RV image"

if [[ ! -e openEuler-24.03-LTS-riscv64.qcow2.xz ]]; then
        echo "pulling openeuler 24 RV"
        curl -o openEuler-24.03-LTS-riscv64.qcow2.xz https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS/virtual_machine_img/riscv64/openEuler-24.03-LTS-riscv64.qcow2.xz
fi

if [[ ! -e RISCV_VIRT_VARS.fd ]]; then
        echo "pulling RISCV_VIRT_VARS.fd"
        curl -o RISCV_VIRT_VARS.fd https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS/virtual_machine_img/riscv64/RISCV_VIRT_VARS.fd
fi

if [[ ! -e RISCV_VIRT_CODE.fd ]]; then
        echo "pulling RISCV_VIRT_CODE.fd"
        curl -o RISCV_VIRT_CODE.fd https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS/virtual_machine_img/riscv64/RISCV_VIRT_CODE.fd
fi

echo "openeuler 24 RV image exists"

if [[ ! -e openEuler-24.03-LTS-riscv64.qcow2 ]]; then
        echo "extract downloaded image"
        xz -dk openEuler-24.03-LTS-riscv64.qcow2.xz
fi

echo "extract image ok"

echo "ready to start virtual machine"

qemu-system-riscv64 -machine virt,pflash0=pflash0,pflash1=pflash1,acpi=off -smp 12 -m 4G -blockdev node-name=pflash0,driver=file,read-only=on,filename=RISCV_VIRT_CODE.fd -blockdev node-name=pflash1,driver=file,filename=RISCV_VIRT_VARS.fd -drive file=openEuler-24.03-LTS-riscv64.qcow2,format=qcow2,id=hd0,if=none -device virtio-vga -device virtio-rng-device -device virtio-blk-device,drive=hd0,bootindex=1 -device virtio-net-device,netdev=usernet -netdev user,id=usernet,hostfwd=tcp::2222-:22,hostfwd=tcp::9000-:9000,hostfwd=tcp::9001-:9001 -device qemu-xhci -usb -device usb-kbd -device usb-tablet -display none -daemonize

sleep 30

sshpass -p 'openEuler12#$' scp -o StrictHostKeyChecking=no -P 2222 ./run.sh root@localhost:/root/run.sh

sshpass -p 'openEuler12#$' ssh -o StrictHostKeyChecking=no root@localhost -p 2222 "sh /root/run.sh"
