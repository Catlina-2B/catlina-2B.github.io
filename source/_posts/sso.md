---
layout: '[layout]'
title: 一步步实现一个单点登录（含后端）
date: 2020-02-21 16:51:00
tags:
---

## 先来看看实现效果吧

{% asset_img sso.gif %}

## 前端原理

在 a.com 登录之后我们要实现 b.com 打开后自动登录，我们知道两者之间必不可少的环节就是相互通信

但是由于浏览器因为安全问题设置有 cookie 同源策略影响  因此有了两种解决方案：

##### 第一种：子域通过访问主域获取信息

子域可完美获取到主域下的 cookie 信息，此方案没什么可说的，且这种方案限制性太强，需要两个子系统都是二级域

##### 第二种：两个系统统一把登录信息存储到另一个服务中（也是以下实现的方案）

每个系统登录后的信息都传入此作为通信的系统中，每个系统打开后都先尝试去通信服务中获取用户令牌

如若获取到，直接使用令牌登录获取用户信息，如若没有获取到，正常让用户登录，利用手段：跨域存储

### 知识理论层(有基础的可直接进入下方实践层)

**window 提供一个 api 接口叫 postMessage，方法参数如下**

```javascript
otherWindow.postMessage(message, targetOrigin, [transfer]);
```
***otherWindow***
其他窗口的一个引用，比如 iframe 的 contentWindow 属性、执行 window.open 返回的窗口对象、或者是命名过或数值索引的[window.frames](https://developer.mozilla.org/en-US/docs/Web/API/Window/frames)。

***message***
将要发送到其他 window的数据。它将会被[结构化克隆算法](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm)序列化。这意味着你可以不受什么限制的将数据对象安全的传送给目标窗口而无需自己序列化。

***targetOrigin***
通过窗口的origin属性来指定哪些窗口能接收到消息事件，其值可以是字符串"*"（表示无限制）或者一个URI。在发送消息的时候，如果目标窗口的协议、主机地址或端口这三者的任意一项不匹配targetOrigin提供的值，那么消息就不会被发送；只有三者完全匹配，消息才会被发送。这个机制用来控制消息可以发送到哪些窗口；例如，当用postMessage传送密码时，这个参数就显得尤为重要，必须保证它的值与这条包含密码的信息的预期接受者的origin属性完全一致，来防止密码被恶意的第三方截获。如果你明确的知道消息应该发送到哪个窗口，那么请始终提供一个有确切值的targetOrigin，而不是*。不提供确切的目标将导致数据泄露到任何对数据感兴趣的恶意站点。

***transfer(可选)***
是一串和message 同时传递的 [Transferable](https://developer.mozilla.org/zh-CN/docs/Web/API/Transferable) 对象. 这些对象的所有权将被转移给消息的接收方，而发送一方将不再保有所有权。

有了如上这等好东西，那么我们可以在通信服务中设置一个可访问的页面，每个系统登录之后我们就将信息储存到这个服务中

那么我们每个系统在登录前只需要通过 ifarme 去这个通信服务中获取一下信息就好了

为了方便调试，笔者这里在本地开启了三个端口（server1、server2、loginServer），他们的关系大概如下图所示

{% asset_img relation.png %}

### 前端代码实践

有了如上述这般的扯淡，那么接下来直接上代码

**需要登录的server**

```javascript
//登录方法
function login() {
    const name = document.querySelector('.name').value
    const password = document.querySelector('.psw').value
    jQuery.ajax({
        url: 'http://localhost:8083/login',
        method: 'post',
        data: {
            name,
            password
        },
        success: function(res) {
            const resData = JSON.parse(res)
            $('.login').fadeOut(500)
            $('.success').fadeIn(500)
            let str = `
                <div>
                    <p>登录成功</p>
                    <p>message: ${resData.message}</p>
                </div>`
            $(".success").append(str)
            // 登陆成功后将用户令牌发送到通信服务中存好
            postInfo(resData, 'set')
        }
    })
}

function getInfo() {
    return localStorage.getItem('userInfo')
}
// 发送数据到通信服务
function postInfo(data, func) {
    const ifameWin = document.querySelector("#middle").contentWindow
    let Message = {
        method: func === 'set'? 'setItem' : 'getItem',
        key: 'userInfo',
        value: data || ''
    }
    ifameWin.postMessage(Message, '*')
}

window.onload = function() {
    // 先看看自己有没有登录信息
    if(getInfo()) {
        $('.login').hide()
        $('.success').show()
        let str = `
            <div>
                <p>已登录</p>
                <p>用户名: ${localStorage.getItem('userInfo').name}</p>
                <p>用户名: ${localStorage.getItem('userInfo').password}</p>
            </div>`
        $(".success").append(str)
    } else {
        // 自己没有就去通信服务粑粑那儿看看有没有
        postInfo()
    }
    // 监听通信服务粑粑那儿发过来的信息
    window.addEventListener('message', function (e) {
        // 如果有需要的信息（此处判断过于简单，笔者懒你们可不能懒啊）
        if(e.data && JSON.parse(e.data.result)) {
            const data = JSON.parse(e.data.result)
            $('.login').hide()
            $('.success').show()
            let str = `
                <div>
                    <p>已登录</p>
                    <p>用户名: ${data.user.name}</p>
                    <p>用户名: ${data.user.password}</p>
                </div>`
            $(".success").append(str)
        }
    })
}
```

**负责通信的server**

```javascript
let objMap = {
    setItem: (key, val) => window.localStorage.setItem(key, JSON.stringify(val)),
    getItem: (key) => window.localStorage.getItem(key)
}
/*
 * 监听系统儿子发过来的信息，根据儿子需求做对应的事
*/

window.addEventListener('message', function (e) {
    let { method, key, value } = e.data
    let result = objMap[method](key, value)
    let response = {
        result
    }
    window.parent.postMessage(response, '*')
})
```

#### 好了，到这里前端工作就做完了，接下来进入后端工作

神说：我们的系统登录需要后端配合于是后端便有了登录接口

后端为了方便各位自己尝试修改，因此采用的是 node.js 的 koa2 来做，通信服务页面为了方便也放在了这里

大概逻辑就是：客户端发起登录请求，根据用户信息进行验证，验证成功则生成 token 返回给客户端

笔者这里没有连接数据库，甚至连简单的文件数据库都没做，只做了个最简单的信息存储，因为我懒......

如此如此～～  这般这般～～

{% asset_img server.png %}

到这里就结束了，具体源码我已经上传到了 github 了， 有兴趣的可以 down 下来自己试试， [https://github.com/Catlina1996/sso](https://github.com/Catlina1996/sso)