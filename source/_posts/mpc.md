---
layout: "[layout]"
title: MPC协议
date: 2024-03-25 15:52:00
tags: MPC
categories: MPC
---

# MPC介绍

安全多方计算（Secure Multi-Party Computation），记为 SMPC/ MPC，它是指在无可信第三方的情况下，多个参与方协同计算一个约定的函数。MPC 起源于姚期智先生于 1982 年提出的百万富翁问题及其密码学解法，后来不断发展和完善，已成为当前密码学的一个重要分支。
Safeheron Lab 一直以来深耕 MPC 研究，与姚期智院士创建的图灵研究院共建联合实验室，深度参与可信计算与区块链融合的研究，Safeheron Lab 已将部分 MPC 研究课题开源。
从 2018 年开始，MPC 技术被应用在区块链数字资产领域的私钥安全设计中。据不完全统计，4 年时间内，超过 3 万亿美元的数字资产转移通过 MPC 私钥方案签署完成，这一方案被纽约梅隆等上千家银行和顶级机构采用。2010 年后，MPC 开始越来越频繁地进入实用阶段。
目前 MPC 协议可以分成两大类：通用 MPC 协议和专用 MPC 协议。
通用 MPC 协议，顾名思义，具有通用性，理论上可支持任何计算任务。它一般基于混淆电路（Garbled Circuit）实现。具体实现步骤是将计算逻辑编译成电路，然后混淆执行。然而，随着问题的复杂化（大部分常见问题就很复杂），电路的规模也会迅速扩大，导致计算效率大大降低。
专用 MPC 协议则是指为解决特定问题所构造出的特殊 MPC 协议。由于是针对性构造并进行优化，专用算法的效率会比基于混淆电路的通用框架高很多。常见 MPC 专用算法包含，四则运算、比较运算、矩阵运算、隐私集合求交集、隐私数据查询、私钥门限签名等。
在实际应用场景中，人们常常会寻求快速高效的专用 MPC 协议。

# 区块链领域的 MPC 研究

随着研究的推进，一些重要的 MPC 多签协议相继被发表。在 MPC-ECDSA 研究方向，典型的有，Lin17 提出的关于 ECDSA 的两方签名算法和 [GG18](https://eprint.iacr.org/2019/114.pdf) 提出的多方参与的门限签名协议。此后，算法协议层出不穷，比如 [DKLS18](https://eprint.iacr.org/2018/499.pdf)、[DKLS19](https://eprint.iacr.org/2019/523.pdf)、[GG20](https://eprint.iacr.org/2020/540.pdf)、[MPC-CMP](https://eprint.iacr.org/2020/492.pdf)、[DMZ-21](https://eprint.iacr.org/2022/297.pdf) 等等。这些算法研究的重心在于：

- 减少通信次数
- 降低计算工作量
- 安全性分析与安全增强
- 增强对恶意敌手的识别能力
- 降低生成私钥的算力要求

`更快、更高效、更安全`始终是 MPC 研究的目标。

# 开源 MPC-ECDSA 协议
Safeheron 此次一共开源 3 种具有代表性的 MPC-ECDSA 协议：

- [GG18](https://eprint.iacr.org/2019/114.pdf)
- [GG20](https://eprint.iacr.org/2020/540.pdf)
- [MPC-CMP](https://eprint.iacr.org/2020/492.pdf)

其中，`GG18` 是 Rosario Gennaro 和 Steven Goldfeder 提出来的，并且是第一个有影响力的、进入实用阶段的 MPC-ECDSA 门限多签协议。大部分后续提出的 MPC-ECDSA 门限多签协议，都可以看作是 `GG18` 不同角度的优化版本。需要注意的是，`GG18` 早期版本存在一些安全隐患，在安全分析报告的基础上，此次开源的算法对其进行了针对性的修正。