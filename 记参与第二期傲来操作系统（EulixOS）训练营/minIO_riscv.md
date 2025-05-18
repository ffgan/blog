# minIO适配RV平台

## 适配对象

minIO RELEASE.2025-04-22T22-12-26Z，Github Repo -> [链接](https://github.com/minio/minio/tree/RELEASE.2025-04-22T22-12-26Z)

## 适配目标

能在openEuler的RISCV64环境跑起来。

## 适配过程

首先来看到的是minIO项目本身的README，里面列出了基本的安装、启动方式和支持的架构，minIO官方支持的架构嘛有x86、arm和PowerPC LE (ppc64le)，刚好这个适配工作就是为了让minIO能在RV上跑起来。

接下来再看到的是minIO项目本身所使用到的语言，在Github界面可以看到99%是Go，还有1%是other。Go的话本身跨平台、跨架构的支持能力还是不错的，提供了一些相对来说比较友好的支持，不至于说从零开始。没有使用cgo，这下交叉编译的难度一下就下去了，也就是minIO本身不会有太大的交叉编译问题，如果有的话，也是go编译器本来对于跨平台的支持问题。

说这么多，不如先来看看minIO怎么从源码构建出来一个能跑的二进制可执行程序。我们从最一般的流程入手，对于编译型语言，Go、C这些都需要依赖编译器来编译为二进制可执行程序，对于有一定规模的项目，都会使用脚本来辅助完成编译，c里面常见的就是使用make来进行编译，实质上是一种封装过的调用编译器来完成编译操作的程序。在go这边也可以不用make，简单写一个shell脚本即可，都是等价的。所以我们去看构建流程的话，就需要优先去查看这些构建脚本。对这些脚本加上一些与git相关的hook，就可以换个名词，名为CI了。比如说当`git push`后触发自动构建流程，从源码打包出二进制产物。对于github平台，使用的CI工具是github action。（这些devops平台都大差不差）

所以对于在github上的开源项目，如果想查看他的构建流程，可以优先去看看项目根目录下是否有一个.github文件夹，这里会配置对应的CI脚本。对于minIO来说，也使用github action。细心找找，可以看到在[这里](https://github.com/minio/minio/blob/master/.github/workflows/go-cross.yml)。
核心在于最后的一句`make crosscompile`，在往上找找到Makefile里面的crosscompile，可以看到

crosscompile:
 ## cross compile minio
	@(env bash $(PWD)/buildscripts/cross-compile.sh)

再顺藤摸瓜，可以看到里面的交叉编译脚本，[链接](https://github.com/minio/minio/blob/master/buildscripts/cross-compile.sh)

里面目前列出了linux/ppc64le linux/mips64 linux/amd64 linux/arm64 linux/s390x darwin/arm64 darwin/amd64 freebsd/amd64 windows/amd64 linux/arm linux/386 netbsd/amd64 linux/mips openbsd/amd64。咱们可以照猫画虎，加一个linux/riscv64。这里的列表可以在go官网找到go编译器支持的交叉编译的有效值，[链接](https://go.dev/doc/install/source#environment)。
