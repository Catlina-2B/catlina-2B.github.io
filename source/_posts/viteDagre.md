---
layout: "[layout]"
title: vite 中使用 dagre-d3 报错
date: 2022-09-09 17:13:00
math: true
quiz: true
tags:
- vite
- dagre
categories: vite
---

# 报错信息
在本地 dev 环境中一切正常，但build完成后到线上，就发生了报错：
> TypeError: Cannot read properties of undefined (reading 'layout')

如下图：
{% asset_img error-1.jpg %}

# 原使用方法

```javascript
import dagreD3 from 'dagre-d3'

var g = new dagreD3.graphlib.Graph().setGraph({
    multigraph: true,
    compound: true
});
// rank direction
g.graph().rankdir = "RL"
```

# 分析原因

> 是的，根据文档写出的代码出了问题，那么电脑的问题占了百分之70，因此我砸了这台电脑换了台新的mac，不得不说是真香（跑偏了～）

上网上搜了下，并没有得到解决方法，只能自己研究下，一步步查看执行过程：

## 查找报错位置：
图中显示报错是变量layout找不到，因此一定是内部执行时遇到了问题，先找到dagreD3源码：

```javascript
module.exports =  {
  graphlib: require("./lib/graphlib"),
  dagre: require("./lib/dagre"),
  intersect: require("./lib/intersect"),
  render: require("./lib/render"),
  util: require("./lib/util"),
  version: require("./lib/version")
};
```

接着继续找到graphlib：
```javascript
/* global window */

var graphlib;

if (typeof require === "function") {
  try {
    graphlib = require("graphlib");
  }
  catch (e) {
    // continue regardless of error
  }
}

if (!graphlib) {
  graphlib = window.graphlib;
}

module.exports = graphlib;
```

在这里发现当识别不到`require`时，便会去`window`下的`graphlib`寻找，那么原因就找到了，vite默认是不支持require的，所以graphlib找到了window下的graphlib，
可以想象后续执行一定是报错的，我们实验一下，在下方加入打印：
```javascript

if (!graphlib) {
  console.log("It's been here.");
  graphlib = window.graphlib;
  console.log(graphlib)
}

module.exports = graphlib;
```

执行一下：
{% asset_img error-2.jpg %}
<br/>
果然，在这个地方跪了，所以问题也找到了。

## 问题的解决

既然是`graphlib`未找到，那么我们有两种解决方案
- 第一：将require在vite打包前注入到vite中，这也是为什么dev的时候好好的，但是build之后就会报错，因为vite本地server是node环境，所以需要配置 vite 支持 require。
- 第二：将dagre-d3.min.js 放到index.html 模板头部引入，这样dagre-d3就会被放入window下。

Cat这里使用的是第二种方式，比较暴力一些。

# 总结
> 报错信息很重要！
> 报错信息很重要！
> 报错信息很重要！

重要的事情说三遍，开发中还是要善于分析报错信息，不然就会无脑被卡很久，说多了都是泪～