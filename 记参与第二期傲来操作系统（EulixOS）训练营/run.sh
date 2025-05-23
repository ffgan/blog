uname -m

date -s "2025-05-01 10:00:00"

dnf install chrony git make tar -y
systemctl enable chronyd
systemctl start chronyd
chronyc makestep

git clone https://github.com/minio/minio.git
cd minio
git checkout RELEASE.2025-04-22T22-12-26Z

curl https://dl.google.com/go/go1.24.3.linux-riscv64.tar.gz -o go1.24.3.linux-riscv64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.3.linux-riscv64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin

go version

go env

go mod tidy

sed -i 's/loongarch64)/loongarch64 | riscv64)/g' buildscripts/checkdeps.sh

make

file minio

./minio server ~/data --console-address ":9001"
