---
layout: "[layout]"
title: MacOS 删除相同的颜色描述文件
date: 2022-09-09 17:13:00
math: true
quiz: true
tags:
- Mac
categories: Mac
---

Mac电脑外接显示器用久了打开显示器设置里面，发现一堆相同的颜色描述文件，看着就很烦，查了下，这些文件是在外接显示器的时候自动生成的，在访达里面删除一个个的太麻烦了，推荐使用命令行打开folder直接批量删除掉

路径：

> /Library/ColorSync/Profiles/Displays

打开终端，执行命令：

```bash
open /Library/ColorSync/Profiles/Displays
```

{% asset_img screen.jpg  %}

直接选中不需要的删除掉就行了

mac为什么会有这么让人难受的逻辑让人很费解🤔