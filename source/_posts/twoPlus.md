---
layout: "[layout]"
title: 两数相加
date: 2022-04-03 17:46:00
math: true
quiz: true
tags: 算法
categories: 算法学习
---

# 学算法

昨天于晚上时间开始了长达一个多小时时间的算法学习过程，今天巩固了一下昨天的所学知识，准备开始今天的题目学习。
我信心满满地打开了力扣题库中的第二题，名叫：[两数相加](https://leetcode-cn.com/problems/add-two-numbers)，好家伙，力扣题库中扑面而来的前两道题竟然都是做加法的题🥲

fine，同样的

## 看一下题目

```markdown
给你两个非空的`链表`，表示两个非负的整数。它们每位数字都是按照逆序的方式存储的，并且每个节点只能存储一位数字。
请你将两个数相加，并以相同形式返回一个表示和的链表。
你可以假设除了数字 0 之外，这两个数都不会以 0  开头。
```
示例1：
<img src="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2021/01/02/addtwonumber1.jpg" alt="https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2021/01/02/addtwonumber1.jpg" width="480" border="10" />

```markdown
输入：l1 = [2,4,3], l2 = [5,6,4]
输出：[7,0,8]
解释：342 + 465 = 807.
```
示例2：
```markdown
输入：l1 = [0], l2 = [0]
输出：[0]
```

好家伙，又是一道奇怪的题，好好的相加硬是玩出了花儿来了，是的，我又被虐了，以我的思路我只能想到反转两个数组，然后相加，再反转回去🤔
在用我自己的思路去实现了遍，提交代码时告诉我错误，看了半天，原来不是数组，是个叫`链表`的结构体，说实话，一脸懵逼，什么是链表？

## 链表

祭出百度谷歌大法后，终于了解到什么是链表
> 链表是一种物理存储单元上非连续、非顺序的存储结构，数据元素的逻辑顺序是通过链表中的指针链接次序实现的。 链表由一系列结点（链表中每一个元素称为结点）组成，结点可以在运行时动态生成。 每个结点包括两个部分：一个是存储数据元素的数据域，另一个是存储下一个结点地址的指针域。 相比于线性表顺序结构，操作复杂。

其实就是一个存有前后指向的`map`类型，如此来说，我的思路再次被定格住了，完全没见过这样的操作呀，还是直接看题解吧。

# 学思维

由于输入的两个链表都是逆序存储数字的位数的，因此两个链表中同一位置的数字可以直接相加。

我们同时遍历两个链表，逐位计算它们的和，并与当前位置的进位值相加。具体而言，如果当前两个链表处相应位置的数字为 n1，n2，进位值为 carry，则它们的和为n1 + n2 + carry；其中，答案链表处相应位置的数字为 (n1 + n2 + carry) mod 10，而新的进位值为：

$$\begin{array}{c}

\frac {n1+n2+carry}{10}

\end{array}$$

如果两个链表的长度不同，则可以认为长度短的链表的后面有若干个0。

此外，如果链表遍历结束后，有carry > 0，还需要在答案链表的后面附加一个节点，节点的值为 carry。

## 代码

```javascript
function ListNode(val, next) {
    this.val = (val === undefined ? 0 : val)
    this.next = (next === undefined ? null : next)
}
/**
 * @param {ListNode} l1
 * @param {ListNode} l2
 * @return {ListNode}
 */
var addTwoNumbers = function(l1, l2) {
    let head = null, tail = null, carry = 0;
    while(l1 || l2) {
        const n1 = l1 ? l1.val : 0;
        const n2 = l2 ? l2.val : 0;
        const sum = n1 + n2 + carry;
        if(!head) {
            head = tail = new ListNode(sum % 10);
        } else {
            tail.next = new ListNode(sum % 10);
            tail = tail.next;
        }

        carry = Math.floor(sum / 10);
        if(l1) {
            l1 = l1.next;
        }
        if(l2) {
            l2 = l2.next;
        }
    }
    if(carry) {
        tail.next = new ListNode(carry);
    }
    return head;
};
```
## 学习过程

对于我这种初学算法者来说，这段代码可谓是无厘头，乍眼一看，几乎看不懂，我在看这里的时候来回看了几次没发现关键点在哪里，脑海里似乎有个过程动画在复现，但是又不能完全理解，这里有几个关键点：

-  始终在操作指向的next
-  保存进位
-  位数不同补 0 处理

我在第一点困扰了很久，为什么始终在操作tail和tail的next，最终却return head呢？
想不明白，那就直接上手敲，打开了控制台，然后尝试了一番，终于得到结论了：
> 在js中对象是引用关系，变量指针指向内存地址，因此`head = tail = new ListNode(sum % 10)`使得`head`始终指向`tail`。

第二点好理解，每次位数之间相加最大值为18，>= 10的时候，将进位保存，以便下个位数相加进位。
第三点的意思是当两个链表位数不同的时候，那么需要补0，
例如：
```markdown
123 + 45678
↓
1 -> 2 -> 3 -> 4 -> 0
+    +    +    +    + 
4 -> 5 -> 6 -> 7 -> 8
```

# 总结
我觉得这种方式是一种利用指针指向的便捷，类似使用的方案的有vue和react的虚拟dom的数据绑定，目的是为了减少空间复杂度，提升性能。