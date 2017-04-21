# Gobang
五子棋AI大战，该项目主要用到MVC框架，用算法搭建AI实现进攻或防守

### 一.项目介绍
#### 1.地址：


github地址：[Gobang](https://github.com/YYSheng/Gobang)


#### 2.效果图：

![五子棋大战1](http://upload-images.jianshu.io/upload_images/2292690-3c46d0eb685e9eaa.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)
![五子棋大战2](http://upload-images.jianshu.io/upload_images/2292690-f32ded62f3fef27d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)
![五子棋大战3](http://upload-images.jianshu.io/upload_images/2292690-7c3a799388dd5655.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)




### 二.思路介绍
大概说下思路，具体看代码实现。
#### 1.画棋盘及落点
这个可以去慕课网看看这个视频:[五子棋](http://www.imooc.com/learn/646)，里面有详细的讲解，我对里面的进行了部分优化。比如怎么判断两点之间到底触摸的哪个点。


#### 2.重来
每个点都是一个对象，让后把对象放数组里面，进行删去，或者重置。


#### 3.人机模式
![AI简介.png](http://upload-images.jianshu.io/upload_images/1352811-1d9630f0550e20de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这里的AI（人工智能）比较简单，这个算法可深可浅，此项目就是比较浅的，深的可以去看[算法](http://blog.csdn.net/onezeros/article/details/5542379)，此项目AI的大体思路是：

- 先便利棋盘上面的点，找到AI的棋子有活四，死四的点，既下一步能形成5个点的落子点，找到就直接在此点落子。

- 如果没找到，就遍历玩家活四，或者死四的点，并在此进行落点进行防守，虽然活四没法防守。

- 然后这两个点都没找到的话，就直接找AI有形成活三，或者死三的点，进行落子进攻。

- 如果没找到，就找用户能形成活三，死三的点进行防守。就这样简单的进行交互。



#### 三.用到的三方和借鉴
感谢下面作者

3.[慕课网五子棋](http://www.imooc.com/learn/646)

#### 四.结语
 如果能对你有帮助，就给个star或赞鼓励下，有什么没明白的欢迎留言交流。
#### 五.许可证
本项目使用[MIT](https://choosealicense.com/licenses/mit/)许可证

