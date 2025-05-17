# minIO适配RV平台

## 适配对象

minIO RELEASE.2025-04-22T22-12-26Z，Github Repo -> [链接](https://github.com/minio/minio/tree/RELEASE.2025-04-22T22-12-26Z)

## 适配目标

能在openEuler的RISCV64环境跑起来。

## 适配过程

首先来看到的是minIO项目本身的README，里面列出了基本的安装、启动方式和支持的架构，minIO官方支持的架构嘛有x86、arm和PowerPC LE (ppc64le)，刚好这个适配工作就是为了让minIO能在RV上跑起来。

接下来再看到的是minIO项目本身所使用到的语言，在Github界面可以看到99%是Go，还有1%是other。Go的话本身跨平台、跨架构的支持能力还是不错的，提供了一些相对来说比较友好的支持，不至于说从零开始。