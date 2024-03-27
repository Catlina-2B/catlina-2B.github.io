---
layout: "[layout]"
title: 多方安全计算-MPC
date: 2024-03-25 16:52:00
tags: MPC
categories: MPC
---

# 多方安全计算-MPC（ Secure Multi-Party Computation ）

多方安全计算(MPC)是在无可信第三方情况下，多个参与方协同完成计算目标，并保证每个参与者除计算结果外均不能得到其他参与实体的任何输入信息。多方安全计算问题最初起源于1982年姚期智院士提出的百万富翁问题，后来经过多年不断的发展，成为目前密码学的一个重要分支。多方安全计算是基于密码学的算法协议来实现隐私保护，常见的多方安全计算协议包括秘密共享（Secret Sharing，SS） 、混淆电路（Garbled Circuit，GC）、同态加密（Homomorphic Encryption，HE）、不经意传输（Oblivious Transfer，OT）等。多方安全计算技术可以获取数据使用价值，却不泄露原始数据内容，保护隐私，可适用于多方联合数据分析、数据安全查询（PIR，Private Information Retrieval）、隐私求交（PSI，rivate Set Intersection）、数据可信交换等应用场景。一系列用于 MPC 的开源库（例如ABY、EMP-toolkit，FRESCO，JIFF 、MP-SPDZ，MPyC, SCALE-MAMBA，和 TinyGable等) 得到了发展，进一步推动了 MPC 的应用和部署。



作者：京东云开发者
链接：https://juejin.cn/post/7182072953243172923
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。