---
layout: "[layout]"
title: mac安装brew报错 fatal unable to access 'https://github.com/Homebrew/brew/'
date: 2022-09-14 22:00:00
math: true
quiz: true
tags:
- mac
- 命令行
categories: 命令行
---

# 问题
在mac下安装brew报错如下：
{% asset_img error.jpg  %}

# 解决方法
将dns设置首选为8.8.8.8
- 步骤:
  - 打开系统偏好设置
  - 选择网络
  - 高级
  - 进入DNS选项
  - 在左侧DNS中添加8.8.8.8并将它拖到首选

# 安装完执行brew却报错找不到命令
```bash
zsh: command not found: brew
```

原因是缺少环境变量，将以下变量放到`~/.zprofile`文件下：
```bash
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
```

执行 `brew help`，大功告成。