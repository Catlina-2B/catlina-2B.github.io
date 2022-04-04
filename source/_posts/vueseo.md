---
title: prerender-spa-plugin Vue预渲染配合meta-info优化seo
tags: 
- vue
- seo
---

## 解决过程

先安装prerender和puppeteer插件  这个国外大神写的  github地址就不附上了(百度有)

cnpm install prerender-spa-plugin

npm install --save puppeteer --ignore-scripts

这里注意  一定要用cnpm代理下载   不然下载不到chromium

安装好之后注意在package.json上查看版本号  不同版本号有不同的写法  这个一定要注意（可以上github上查看不同版本的写法）

#### 第一步 引入插件及方法（不同版本不同用法  此处版本为3.x，2.x请忽略）

![avatar](https://img2018.cnblogs.com/blog/1416731/201904/1416731-20190425155946382-1423490041.png)

#### 第二步 配置PrerenderSPAPlugin

![avatar](https://img2018.cnblogs.com/blog/1416731/201904/1416731-20190425160146809-1146864215.png)

#### 第三步 main.js中将render-event方法放入

![avatar](https://img2018.cnblogs.com/blog/1416731/201904/1416731-20190425160305484-411664263.png)

<font color="#FF0000" >这里记住一定要将方法放入mouted里面</font>

#### 第四步 将 mode 设置为 history 模式（不用 history 模式不行！！！这里一定要改为 history 模式）

#### 第五步 将 config/index.js 下的 build 中的 assetsPublicPath 换成'../'

![avatar](https://img2018.cnblogs.com/blog/1416731/201904/1416731-20190425161649573-385520517.png)

最后直接打包npm run build就可以了

过程中会出现minichrome测试浏览器，生成dist文件内包含预渲染文件目录