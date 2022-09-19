---
layout: "[layout]"
title: Node 实现单点登录 sso
date: 2020-09-19 18:50:00
tags:
- node
- http
---

# 概念
> 什么是单点登录？

单点登录即是，当我们在访问某个公司一系列的产品时，登录了某个产品，那么在其他产品也能免登录。
比如，我在a.com登录之后，由于b.com和它同属一个产品系列，用户系统是打通的，那么在b.com就可以免登录进入。
今天，我们就着这个登录来说一下吧。

## 从状态开始说

我们都知道，http是无状态的，换句话说就是，请求和响应是基于TCP一次性的，它其实本身是不知道发生了什么的。
但是大多数场景我们都是有状态的，例如一个用户登录了淘宝，买了一件衣服，跟商家扯皮，看直播发了一条弹幕......这些都是在登录之后才能有的操作，也就是有了登录状态。

> 小明参加了一场X公司举办大型研讨会，来的人有上千个人，为了记录本次大会参与人数，以及识别谁都是谁，大会让他去X公司楼下登记处领一张身份卡，上面有X公司的特殊logo，写了小明的名字，关键是还会发光诶～
> 小明大感舒服，仿佛有了当贵宾的感jio，为了表明自己是贵宾，他拿着这个身份卡去购买了很多周边产品......
> 小明把身份卡放在了口袋，每当他去敏感的地方就有一个人来检查身份，他就要掏出来一次，他觉得很麻烦，于是把身份卡挂在了脖子上，这下保安检查身份只需要远远看一眼身份卡上的特有标识就好了，再也没人烦小明买东西[泡妞]了

以上身份卡就是我们俗知的token，代表了我们的身份，那么如何保证我们的操作是有状态的呢？
很明显，只需要每次都拿着我们的身份卡去请求内容就好啦，所以延伸出来几个点
- 收身份卡
- 存身份卡
- 发身份卡

## 状态接收、存储、发送
简单的收发存，大家也都耳熟能详了，这里大致介绍一下。

<b>接收分为两种方式：</b>
- `response`的data接收`token`类字段
- `response`的header中`set-cookie`字段直接写入cookie

其中第二种方式有需要前后端配合清楚，服务端在设置cookie的时候，因为可以选择设置为http-only，也就是前端通过js无法获取和修改，只能服务端读取，那么对前端的状态读取就有问题了。

<b>存储分为两种方式：</b>
- 将token直接存入全局变量或全局状态库，比如：vuex、redux
- 保存token至localStorage或cookie中

存储方式一般由前端与服务端配合方式决定，如果token只是会话级别，那么存全局变量还是cookie都行，如果是存localStorage，那么要记得清理。

<b>发送分为两种方式：</b>
- 将token放入头部`Authorization`或`Token`之类的字段中
- 将token放入cookie，服务端直接读取cookie信息

发送方式完全由服务端决定接受方式。

## 单点登录原理

基于以上概念，我们可以使则某个系统拥有登录状态，但是由于cookie受域名（domain）限制，如何让其他域名的系统免登录呢？

> 小明从研讨会出来身份卡就主动退回去了，紧接着他又去参加了X公司举办的驴友会，到这里又让他去X公司楼下登记处领一张身份卡，小明看了下跟研讨会的身份卡几乎一模一样，都有X公司的特殊logo，小明的名字，关键是都会发光诶～
> 小明想是不是可以通过这个卡进去研讨会呢？于是他马上去试了试，真的可以凭借这个身份卡自由进出两场会～
> 这个发现让小明惊喜不已，但是这个身份卡用的是特殊的电池，一旦没电了，就没用了，到时候就只能去X公司重新领一张身份卡了......

如上述所说，小明拿着X公司登记处给的身份卡可以自由进出两场会，代码中也是一样：
当系统A开始进入，发现需要登录，携带当前页面的url跳转到统一登录中心，登录完成后，后端将token设置到页面cookie中，然后携带token和url回到系统A的`callback页面`，`callback页面`将token存入cookie，并跳转回系统A最初页面。
系统B进入之后，发现需要登录，同样的携带当前页面的url跳转到统一登录中心，登录中心发现当前已经登录，且携带的url是经过sso注册后的系统，于是携带token和url跳转回到系统B的`callback页面`，`callback页面`将token存入cookie，并跳转回系统B最初页面。

因此整体流程图如下：
{% mermaid %}
sequenceDiagram
clientA-->>serverA: 请求资源
serverA-->>clientA: 获取失败，未登录
clientA-->>clientSSO: 登录，携带页面url-pageA
clientSSO-->>serverSSO: 输入帐号密码，请求登录
serverSSO-->>clientSSO: set-cookie，种cookie
clientSSO-->>clientA: 携带token等信息至callback
Note left of clientA: 将token等信息设置到cookie，并重定向至pageA
{% endmermaid %}

{% mermaid %}
sequenceDiagram
clientB-->>serverB: 请求资源
serverB-->>clientB: 获取失败，未登录
clientB-->>clientSSO: 登录，携带页面url-pageB
clientSSO-->>clientB: 已登录，携带token等信息至callback
Note left of clientB: 将token等信息设置到cookie，并重定向至pageB
{% endmermaid %}

# 实现

基于以上原理，我们实践需要用到以下系统：client-A、client-B、client-SSO、server-A、server-B、server-SSO，接下来我们开始构建对应系统。

## 服务端

```javascript
yarn init midway
```

服务端采用`midwayjs`快速搭建：

参考<a href="https://midwayjs.org/docs/quickstart">midwayjs快速开始</a>

<b>server-A和server-B核心在于中间件验证token，当请求进来时，将请求头部身份信息拿去server-SSO系统去验证token：</b>

```javascript
import { IMiddleware, makeHttpRequest } from "@midwayjs/core";
import { Middleware } from "@midwayjs/decorator";
import { NextFunction, Context } from "@midwayjs/koa";

@Middleware()
export class JwtMiddleware implements IMiddleware<Context, NextFunction> {
  resolve() {
    return async (ctx: Context, next: NextFunction) => {
      const cookies: { identity?: string; sid?: string; name?: string } = {};

      const keys = ctx.request.ctx.headers.cookie.trim().split(";");

      keys.forEach(i => {
        const arr = i.split("=");
        cookies[arr[0].trim()] = arr[1];
      });

      // 获取cookie信息，请求server-SSO，验证token
      const verify = await makeHttpRequest("http://127.0.0.1:7001/api/verify", {
        data: {
          name: cookies.name,
          sid: cookies.sid,
          identity: cookies.identity
        },
        dataType: "json"
      });

      if (verify.data.success) {
        ctx.session.user = verify.data.data;
        await next();
      } else {
        return { success: false, message: verify.data.msssage };
      }
    };
  }

  static getName(): string {
    return "report";
  }
}
```

<b>server-SSO我们这里只做两件事：</b>

- 登录，利用jwt生成token，并存入redis
- 验证token是否有效

```javascript
import {
  Inject,
  Controller,
  Get,
  Post
} from "@midwayjs/decorator";
import { Context } from "@midwayjs/koa";
import { UserService } from "../service/user.service";
import { RedisService } from "@midwayjs/redis";
import { JwtService } from "@midwayjs/jwt";
import { v4 as uuid } from "uuid";

@Controller("/api")
export class APIController {
  @Inject() ctx: Context;

  @Inject() userService: UserService;

  @Inject() redisService: RedisService;

  @Inject() jwtService: JwtService;

  // 验证token
  @Get("/verify")
  async verify() {
    try {
      const {
        identity,
        sid
      }: { sid?: string; identity?: string; name?: string } = this.ctx.request.query;
      const tokenExists = await this.redisService.get(sid);

      if (tokenExists && identity == tokenExists) {
        const user: any = this.jwtService.decode(identity);
        return {
          success: true,
          message: "OK",
          data: this.userService.getUser(user.username)
        };
      } else {
        return { success: false, msssage: "token is invaild." };
      }
    } catch (err) {
      return { success: false, msssage: "data is invaild." };
    }
  }

  setCookie(key, val) {
    this.ctx.response.ctx.cookies.set(key, val, {
      expires: new Date(Date.now() + 600000),
      signed: false,
      httpOnly: false,
      sameSite: "none"
    });
  }

  // 登录
  @Post("/login")
  async login(): Promise<{ success: boolean; message: string }> {
    const {
      username,
      password
    }: { username?: string; password?: string } = this.ctx.request.body;

    const user = this.userService.getUser(username);
    // 用户名密码验证
    if (user && user.password === password) {
      const token = await this.jwtService.sign({ username, password });
      // 生成随机id
      const sid = uuid();

      if (user.sid != "") {
        // 将redis中原token删除
        this.redisService.del(user.sid);
      }
      // 将新的token存入redis
      this.redisService.set(sid, token, "EX", 86400);

      this.ctx.session.user = {
        sid,
        token
      };

      // 将token信息设置到web的cookie中
      this.setCookie('sid', sid);
      this.setCookie('identity', token);
      this.setCookie('username', user.username);

      this.userService.setUserToken(username, token, sid);
      return {
        success: true,
        message: "OK"
      };
    } else {
      return { success: false, message: "username or password is invalid." };
    }
  }
}

```


## 前端

前端采用`vite + vue3`快速搭建：

```bash
yarn create vite
```

参考<a href="https://cn.vitejs.dev/guide/#scaffolding-your-first-vite-project">vite官方文档</a>

<b>client-A和client-B系统页面路由守卫鉴权，如果cookie中令牌不存在，跳转到client-SSO：</b>

```javascript
import Cookies from 'js-cookie'

const back_page = '/callback'

router.beforeEach((to, from, next) => {

  const identity = Cookies.get('identity');
  const sid = Cookies.get('sid');

  if (identity && sid) {
    if (to.path === back_page) {
      next('/')
    }
  } else {
    if (to.path === back_page) {
      const redirect_url = to.fullPath
      window.location.href = `http://127.0.0.1:6001/?redirect_url=${encodeURIComponent(redirect_url)}&name=a`
    }
  }
  next();
})
```

<b>client-SSO登录页面做两件事：</b>

- 当没有token去登录
- 当有token直接携带token重定向回去

```javascript
<script setup>
// This starter template is using Vue 3 <script setup> SFCs
// Check out https://vuejs.org/api/sfc-script-setup.html#script-setup
import { ref, onMounted, computed, watch } from 'vue'

import { useRoute } from 'vue-router'

import Cookies from 'js-cookie'

const username = ref("");
const password = ref("");
const user = ref("");

const logined = ref(false);

const route = useRoute();

const ssoRegisters = {
  "a": {
    path: "http://test-a.com:6002/callback"
  },
  "b": {
    path: "http://test-b.com:6003/callback"
  },
}

const signIn = () => {
  fetch("http://127.0.0.1:7001/api/login", {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=utf-8"
    },
    body: JSON.stringify({
      username: username.value,
      password: password.value
    }),
    credentials: "include"
  }).then(async r => {
    const res = await r.json();
    if (res.success) {
      logined.value = true;
    } else {
      alert(res.message)
    }
  })
}

const replaceUrl = (val) => {
  const { identity, sid, name } = getCookie();

  const ssoObj = ssoRegisters[val.name]
  if (ssoObj && identity && sid && name) {
    const url = `${ssoObj.path}?redirect_url=${encodeURIComponent(val.redirect_url)}&identity=${encodeURIComponent(identity)}&name=${name}&sid=${encodeURIComponent(sid)}`;
    window.location.replace(url);
  }
}

const getCookie = () => {
  const identity = Cookies.get('identity')
  const sid = Cookies.get('sid')
  const name = Cookies.get('username')
  return {
    identity,
    sid,
    name
  }
}

onMounted(() => {
  const { identity, sid, name } = getCookie();
  if (identity && sid && name) {
    user.value = name;
    logined.value = true;
  } else {
    logined.value = false;
  }
})

watch([() => logined.value, () => route.query], (val) => {
  const [newLogined, newRoute] = val;
  if (newLogined && newRoute) {
    replaceUrl(newRoute);
  }
}, {
  deep: true
})

const isLogined = computed(() => logined.value)

</script>

<template>
  <div v-if="!isLogined">
    <h1>SSO登录</h1>
    <p>
      <span>username: </span>
      <input type="text" v-model="username">
    </p>
    <p>
      <span>password: </span>
      <input type="password" v-model="password">
    </p>
    <button @click="signIn">登录</button>
  </div>
  <div v-else>
    <h1>已登录</h1>
    <p>Hi， {{ user }}</p>
  </div>
</template>
```

到此，sso登录就完成了，其实过程很简单，只要掌握了其中关键，一切就通了。

当然，这里面还有一些可优化的地方，比如：
- token设置为same-site，避免csrf攻击
- token有效期，token刷新优化
- 系统域名绑定更严谨一些，通过配置中心读取
- sso系统采用服务端渲染，服务端读取sso认证配置
- 跳转client-sso前通过请求server-sso一个接口，一般来说可以是一个img文件，然后通过服务端set-cookie设置sso令牌

等等......这里只是做一个比较简单的sso登录，大家了解原理之后可以改善一下。