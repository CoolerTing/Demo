
***DotaMax Demo***
==============
![Aragaki](https://github.com/CoolerTing/Demo/blob/master/aragaki.png)</br>
# 该demo为我仿写的dotamax，只包含一部分功能</br>
## 功能
* 主界面dota2用户ID的最近8场的战绩（ID被我写死，暂未添加通过输入ID来查询）
* 点击任意一场可跳转到该场次详细战绩页面
* 实现了点击用户头像的抽屉效果和背景毛玻璃效果
* 采用了AFNetworking、MJRefresh、SDWebImage等常用第三方库
* 添加了数据载入时的载入动画及载入失败后提示刷新按钮
* 添加了视频功能，能够播放视频
* 添加了FPS监测
* Tabbar为自定义，中心dota2按钮不响应tabbar点击，为单独的可响应其他点击事件的按钮（类似于微博发布按钮）
* UITableviewCell可点击展开
* 适配各种屏幕的Iphone
* 里面的图片都是采用网络资源并添加了缓存，可以清除图片缓存
## 截图
* 战绩场次
![IMG_1514](https://github.com/CoolerTing/Demo/blob/master/IMG_1514.PNG)</br>
* 战绩详情
![IMG_1515](https://github.com/CoolerTing/Demo/blob/master/IMG_1515.PNG)</br>
* 展开后的战绩详情
![IMG_1516](https://github.com/CoolerTing/Demo/blob/master/IMG_1516.PNG)</br>
* 视频列表
![IMG_1517](https://github.com/CoolerTing/Demo/blob/master/IMG_1517.PNG)</br>
* 视频播放界面
![IMG_1518](https://github.com/CoolerTing/Demo/blob/master/IMG_1518.PNG)</br>
* 抽屉效果加背景毛玻璃
![IMG_1519](https://github.com/CoolerTing/Demo/blob/master/IMG_1519.PNG)</br>
## 不足
* 由于API是通过Steam获取的，所以接口较多，要重复调用接口获取数据，所以完成载入通常要几秒钟
* 很多功能未完善
* 视频不能播放优酷等视频网站的视频
* 一些细节问题
