---
layout: "[layout]"
title: OKX MPC wallet
date: 2024-03-24 12:10:00
tags:
- MPC
- Web3钱包
categories: MPC
---

OKX 无私钥钱包基于 MPC 技术，将原本的 1 个完整私钥，变成 3 个各自生成的私钥碎片，分开存储，签名时使用其中 2 份私钥碎片即可完成签名，过程中不会产生完整的私钥。在创建无私钥钱包时，OKX 服务器生成一份私钥碎片 1，用户设备生成私钥碎片 2 和私钥碎片 3，其中私钥碎片 2 加密保存在用户设备上，私钥碎片 3 加密备份到 iCloud 或 Google Drive。交易签名时使用私钥碎片 1 + 私钥碎片 2，私钥碎片 3 用作备份。
此外，OKX首创紧急出口功能，使用者可在紧急场景下，透过完全由自己管理的两个私钥分片（私钥碎片2和私钥碎片3），即可导出私钥提走资产，实现了真正意义上的去中心化自托管无私钥钱包。使用OKX帐户即可轻松建立该钱包，无需再管理复杂的私钥或者助记词，非常注重用户体验