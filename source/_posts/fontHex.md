---
layout: "[layout]"
title: css某些字体中0x会变成0
date: 2022-09-09 17:13:00
math: true
quiz: true
tags:
- css
categories: vite
---

# 现象
在使用Inter字体包时，同样的设置，字符串`0xa1`和`0x1a`的显示不同，具体表现是当`0x`后面是字母时，显示正常，当`0x`后面是数字时，`x`会变成`✖️`

{% asset_img 0xa1.png %}

# 字体设置

```css
@font-face {
    font-family: "Inter";
    font-weight: 100;
    font-style: normal;
    src: url("./Inter-Thin.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 200;
    font-style: normal;
    src: url("./Inter-ExtraLight.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 300;
    font-style: normal;
    src: url("./Inter-Light.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 400;
    font-style: normal;
    src: url("./Inter-Regular.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 500;
    font-style: normal;
    src: url("./Inter-Medium.ttf") format('truetype');
}

@font-face {
    font-family: "Inter";
    font-weight: 600;
    font-style: normal;
    src: url("./Inter-SemiBold.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 700;
    font-style: normal;
    src: url("./Inter-Bold.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 800;
    font-style: normal;
    src: url("./Inter-ExtraBold.ttf");
}

@font-face {
    font-family: "Inter";
    font-weight: 900;
    font-style: normal;
    src: url("./Inter-Black.ttf");
}
```
<br/>

很明显，并不是字体设置的问题，因为字体如果设置不正确，那么应该所有都不会正确，但是其他字体显示就是正常的。
排除设置问题，剩下就是字体问题，初步猜测应该是这个字体在浏览器下对16进制字符识别有不同的处理。

# 解决办法
在尝试了很多个属性设置之后，发现设置`text-rendering: optimizeSpeed;`竟然有效果，查询了下这个属性：

> 当 text-rendering为optimizeSpeed时，浏览器在绘制文本时将着重考虑渲染速度，而不是易读性和几何精度，它会使字间距和连字无效。

因此，这个设置会让浏览器暂时忽略对字符的读取，也就是易读性和几何精度，直接完整渲染。