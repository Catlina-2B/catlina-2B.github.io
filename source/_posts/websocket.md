---
title: uni-app 真机测试 socketTask = uni.connectSocket 可以成功，但是socketTask.onOpen 监听不到连接成功
tags: websocket
---

## 问题
后台采用 node + ts + socket.io
本地demo在浏览器运行没问题
在真机测试连接不上

## IDE版本号
2.4.2.20191115

## uniapp前端代码

```javascript
const msg = ‘要发送的数据’
var SocketTask1 = uni.connectSocket({
  url: "ws://localhost:3000/ws",
  success: function(e) {
    console.log(JSON.stringify(e));
  }
});

SocketTask1.onOpen(function(){
  console.log("连接成功")

  SocketTask1.send({
    data: msg,
    success(res) {
      console.log('发送成功')
      console.log(res)
    },
    fail(err) {
      console.log('发送失败')
      console.log(err)
    }
  })
});

SocketTask1.onMessage(function(){
  console.log("接收数据")
});

SocketTask1.onError(function(){
  console.log("连接错误")
});

SocketTask1.onClose(function(){
  console.log("连接关闭")
});
```

## 解决过程

经过反复排查问题所在  最终确定问题出现在连接问题上
因此调用了其他ws接口  发现并没有问题
笔者这里后台使用的是 socket.io ，后台 socket.io 模块换成了websocket
测试  完美 连接上了~

## 结论

uniapp 的 socketTask 方法是基于websocket建立的连接
而 websocket 是基于 socket.io 开发出来使用 web 端的一个模块  双方有共同性但不具备联系性
因此前后端使用 websocket 需注意是否一致