---
title: nuxt引入字体问题
tags: nuxt
---
nuxt默认配置了css文件的url-loader
scss文件引入字体需要单独配置  build中的extend
具体如何配置  有待研究  暂且记录下这个问题

这里顺便记录下中英文引用不同字体的问题
英文字体名字放前面，中文放后面  这是因为英文字体不识别中文字体  系统选择font-family时自动从前面开始一个个寻找  
如果不识别自动跳过  因此大概代码如下：

```css
@font-face {
  font-family: '英文',
  src: url('英文.ttf')
}

@font-face {
  font-family: '中文',
  src: url('中文.ttf')
}

.body {
  font-family: '英文', '中文';
}
```

具体规则参考网址：https://www.cnblogs.com/goloving/p/9721328.html
