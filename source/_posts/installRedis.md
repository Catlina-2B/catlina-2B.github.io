---
layout: "[layout]"
title: mac使用brew安装redis报错：Failed to download resource "ca-certificates"
date: 2022-09-14 22:30:00
math: true
quiz: true
tags:
- mac
- 命令行
categories: 命令行
---

# 问题
在mac下使用brew安装redis报错如下：
{% asset_img error.jpg  %}

# 解决方法
在命令行中输入：
```bash
export HOMEBREW_BOTTLE_DOMAIN=''
```

此命令用于临时更改国内的镜像设置。
再次执行 `brew install redis`，大功告成。