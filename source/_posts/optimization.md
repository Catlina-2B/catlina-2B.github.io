---
title: nuxt打包压缩代码
tags: nuxt
---
webpack4中使用 <font color="#FF0000" >uglifyjs-webpack-plugin</font> 来压缩代码会报错
网上有人说是<font color="#FF00FF" >uglifyjs</font>不支持ES6语法，babel会把项目中的es6编译成es5
但是node_modules中会存在es6的  而这里的代码babel并不会帮助一块编译  因此还是会报错

这里是在 [nuxt](https://zh.nuxtjs.org/) 开发中打包删除 console.log 和 debugger 遇到的
曾尝试将 <font color="#FF00FF" >uglifyjs-webpack-plugin</font> 放入 package.json 的开发模式所需插件中，也就是 \--save--dev安装
但是并没有用  由此看来不是这个方向的问题

网上大神的解决方案：  手动设置mode: 'development'  将其设置为开发模式
这样就可以不添加任何代码就可以使用
```javascript
optimization: {
  minimizer: [ new UglifyJsPlugin() ]
}
```

掉了无数头发的我陷入了沉思：
我这个是nuxt项目  nuxt.config.js里面设置mode 应该是 spa  或者 universal  怎么可能设置为开发或生产模式呢？
于是我抛弃了这个思路  尝试从nuxt文档上找答案  功夫不负有心人
在build配置中发现了这个东西：

<h1>optimization</h1>

仔细看才发现  terser-webpack-plugin 这个插件  原来nuxt中压缩手段和webpack4还是有些许区别  
可能是因为nuxt需要打包服务端的原因？（猜想）
所以才会将webpack的  UglifyJsPlugin() 这个插件封装了一层？
按照文档配置了下之后npm run build  果然没问题了  谢天谢地  终于搞定了
这里附上文档网址：[https://zh.nuxtjs.org/api/configuration-build#optimization](https://zh.nuxtjs.org/api/configuration-build#optimization)

nuxt的问题在网上很少  只能一点点自己摸索  还是要多看文档  多了解版本差异啊！
