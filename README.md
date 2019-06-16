#easydss

### 目录结构

- dist 

	发布目录

- web_src 

	前端开发代码, 通过 webpack 组织代码, 详细讲解请参考我的[系列博客](http://www.penggy.cc/2017/10/12/EasyDSS%E9%AB%98%E6%80%A7%E8%83%BD%E6%B5%81%E5%AA%92%E4%BD%93%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%89%8D%E7%AB%AF%E9%87%8D%E6%9E%84(%E4%B8%80)-%E4%BB%8E%E9%9B%B6%E5%BC%80%E5%A7%8B%E6%90%AD%E5%BB%BA%20webpack%20+%20vue%20+%20AdminLTE%20%E5%A4%9A%E9%A1%B5%E9%9D%A2%E8%84%9A%E6%89%8B%E6%9E%B6/)

	首次运行, 请执行

		npm run dll

	以开发模式运行

		npm run start

	编译到发布目录

		npm run build

- doc 

	文档编辑目录

### 如何发布

首次发布请安装 NodeJS 环境, 然后执行下面的指令安装打包依赖库

	npm i

	npm i -g @penggy/pack

发布 TAR 包

	pack -F tar

发布 ZIP 包

	pack -F zip	

生成对应的发布包在当前目录下	

### 如何运行

- windows

	cd easydss && 以管理员权限运行 `install service.bat`

- linux

	cd easydss && sh start.sh




# <center>EasyDSS流媒体服务器使用文档</center> #

## 概述 

EasyDSS商用流媒体服务器是EasyDarwin流媒体团队开发的一款支持视频点播、转码、RTMP推流直播、RTMP/HLS直播分发、服务端录像、录像检索、录像下载、时移回放的商用流媒体服务器，采用业界优秀的流媒体框架模式设计，服务运行高效、稳定、可靠、易维护，支持RTMP直播、RTMP推送、HTTP点播、HLS直播，并支持关键帧缓冲，画面秒开等多种特性，能够接入WEB、Android、iOS、微信等全平台客户端，是移动互联网时代贴近企业点播/直播需求的一款接地气的流媒体服务器，配套OBS、EasyRTMP等直播推流工具以及EasyPlayer等网络播放器，可以形成一套完整的视频直播、录播解决方案，满足用户在各种行业场景的流媒体业务需求。

## EasyDSS功能清单

- 接收RTMP推流

    EasyDSS能够接收RTMP推流客户端推送的RTMP音视频流(H264+AAC)，并转发给播放客户端；

- 分发RTMP流

    EasyDSS提供RTMP流的高性能分发，RTMP播放客户端可直接连接EasyDSS进行播放；

- 分发HLS流

    EasyDSS提供同步输出HLS流的功能，可以将推送的RTMP流进行实时HLS切片，并提供HLS流的高性能分发；

- 直播录像

    支持将推送的直播流进行同步录像保存；

- 直播录像检索

    支持检索系统的直播录像，提供录像检索和列表接口；

- 直播录像回放点播

    可以点播录制的服务端录像，提供HLS点播，自由seek与倍数播放功能；

- 录像下载

    可以对检索到的录像段进行下载，另存为MP4文件；

- HTTP服务器

    EasyDSS同时也是一款高性能的HTTP服务器，用于提供HTTP访问，同时用于HLS流分发（具备nginx所有属性功能）；

- 防盗链

    支持HTTP防盗链技术；

- 主动拉取RTMP流进行转发

    EasyDSS支持对RTMP流的主动拉取，并将此RTMP流进行RTMP/HLS的转发；

- 转发RTMP流推送

    支持将推送客户端推送的RTMP流，转发推送到其他RTMP流媒体服务器；

- 推流鉴权验证

    支持对推送客户端的推送流进行推流验证，若无权限的推流地址，则不接收客户端推流；

- 推流信息统计

    可以对推送流进行信息统计，包括推送时长、观看人数、起始时间、持续时长、视频码率、音频码率、推送流量等信息；

- 播放鉴权

    支持播放客户端播放验证，无权限的播放地址将无法进行播放；

- 播放信息统计

    可以对播放客户端的数量进行统计，并且可以统计客户端的开始时间、播放时长、播放流量等信息；

- 视频文件点播

    支持点播HLS/mp4文件；

- 跨平台

    支持多种平台部署运行，Windows、Linux等；

- 二次开发

    提供HTTP二次开发接口，可使用接口进行一定的二次开发；

## 配置与部署

**注：无论是Windows还是Linux运行EasyDSS流媒体服务器，都不支持中文路径，请大家使用全英文路径；**

### 基础配置

根目录下放置了简化配置文件 `easydss.conf`

```json
{
	"RTMP_PORT":		10085,		//RTMP 推送端口
	"HTTP_PORT":		10088,		//HTTP 对外端口
	"HTTP_ROOT_PATH":	"www",		//WEB ROOT 目录
	"HLS_PATH":			"www/hls",	//直播文件目录
	"RECORD_PATH":		"www/hls"	//录播文件目录
}
```

### 高级功能配置

`conf/template.conf` 为 EasyDSS 流媒体服务器高级功能配置文件

1、rtmp功能配置

```nginx
rtmp {
	server {
		listen $RTMP_PORT;		#rtmp 监听端口，默认10085

		#application可以自定义多个,例如：zklt
		application live {		#rtmp 直播应用
			live on;
		}
		
		application hls {		#hls 直播应用
			live on;			#live 表示只分发 rtmp
			hls on;				#hls 同步输出 rtmp 和 hls 直播
			hls_record on;		#不配置或者配置 off 表示不录像，on 表示服务器端同步录像
			hls_path $HLS_PATH;	#hls 直播切片目录
			hls_fragment 4s;	#ts 切片时长
		}
	}
}
```

2、rtmp拉流配置

```nginx
rtmp {
	server {
		#rtmp 监听端口，默认 10085
		listen 10085;

		#自动拉流配置
		application pulltest {
			live on;
			
			#rtmp 地址为拉流地址，name 指定 rtmp 的 name
			pull rtmp://ip:port/app/stream1 name=stream1;
			pull rtmp://ip:port/app/stream2 name=stream2;
			pull rtmp://ip:port/app/stream3 name=stream3;
		}
	}
}
```

例如配置为

`pull rtmp://www.easydass.com:10085/live/livetest name=livetest`，

则本地EasyDSS的转发地址为

`rtmp://ip:port/pulltest/livetest`

3、rtmp推流配置

EasyDSS提供rtmp推流转推功能

```nginx
rtmp {
	server {
		listen 10085;			    #rtmp监听端口，默认10085

		#自动推流配置		
		application pushtest {
			live on;
			
			#rtmp地址为推流地址，name指定rtmp的name
			#当EasyDSS接收app为pushtest，name为stream1的rtmp流时
			#可以同步转发到指定的rtmp推流地址
			push rtmp://ip:port/app/stream1 name=stream1;

			#当EasyDSS接收app为pushtest的推流时
			#可以同步转发到指定的rtmp推流地址
			#rtmp流的name将自动添加到转发地址进行转发
			#如：接收推流为/pushtest/stream
			#则会转发到rtmp://ip:port/app/stream
			push rtmp://ip:port/app;
		}
	}
}
```

4、防盗链功能配置

```nginx
http {
	...
    server {
        listen $HTTP_PORT;
		
        location / {
            root $HTTP_ROOT_PATH;
			#Anti-stealing-link
			valid_referers none blocked localhost 127.0.0.1 ~\.baidu\. ~\.google\. addyourdomain;
			if ($invalid_referer) {
				return   403;
			}
        }
	...
```

addyourdomain 此处替换成您自己的域名如：

`www.easydss.com`

多个用空格分开，如：

`www.easydss.com *.easydss.com`

通过以上配置,当在其他网站下试图打开您域名下的视频时, 将会得到 `access denied` 信息表示防盗链配置成功.

5、接收推流处理-on_publish

```
rtmp {
    ...
    application live {
        live on;
        ...
        on_publish http://ip:port/xxxxx;
    }
    ...
}
```

```
参数说明

method: POST

MIME: application/x-www-form-urlencoded

args: app  - RTMP的application名称

      name - 当前推流的流名称

response: HTTP code返回200允许推流，其他为不允许
```

6、接收推流处理结束-on_publish_done

```
rtmp {
    ...
    application live {
        live on;
        ...
        on_publish_done http://ip:port/xxxxx;
    }
    ...
}
```

```
参数说明

method: POST

MIME: application/x-www-form-urlencoded

args: app  - RTMP的application名称

      name - 当前推流的流名称

      begintime - 推流开始时间，从1970年1月1日的秒数

      duration - 推流持续时间，单位为秒

      inbytes - 推流总流量，单位为bytes

      outbytes - 客户端播放总流量，单位为bytes
```

7、客户端开始播放处理-on_play

```
rtmp {
    ...
    application live {
        live on;
        ...
        on_play http://ip:port/xxxxx;
    }
    ...
}
```

```
参数说明

method: POST

MIME: application/x-www-form-urlencoded

args: app  - RTMP的application名称

      name - 当前推流的流名称

      addr - 客户端地址

response: HTTP code返回200允许推流，其他为不允许
```

8、客户端停止播放处理-on_play_done

```
rtmp {
    ...
    application live {
        live on;
        ...
        on_play_done http://ip:port/xxxxx;
    }
    ...
}
```

```
参数说明

method: POST

MIME: application/x-www-form-urlencoded

args: app  - RTMP的application名称

      name - 当前推流的流名称

      addr - 客户端地址
```

### 部署说明 ###

#### Windows ####

- 直接运行

  Windows 版本 EasyDSS 流媒体服务器运行比较简单，直接运行 `start.bat` 即可，此时可以在 Windows 进程管理器中可以看到 EasyDSS 的进程运行，这里有两点需要注意：

  1. EasyDSS 采用的是多进程模式，所以任务管理器中可能会有多个 `EasyDSS.exe` 进程；

  2. EasyDSS 运行日志无控制台显示，日志记录在 `logs/error.log`；

- 以服务的形式运行

  以服务的形式运行程序, 能够达到开机自启动的目的, 方便维护. 在发布包的根目录下有两个脚本文件 `install service.bat` 和 `uninstall service.bat`, 分别用来安装和卸载 EasyDSS 服务. 

#### Linux ####

 - 启动服务,运行 easydss 目录里面的 `start.sh`；

    cd easydss
    	./start.sh

 - 停止服务,运行 `stop.sh` 即可；

    cd easydss
    	./stop.sh

#### 部署测试 ####

启动服务后,在浏览器中打开测试页面，http://ip:10088

![首页](index_snap.png)

点击播放

![播放页面](play_snap.png)

## 业务调用方案

### 点播调用

- 以 Windows 文件点播为例

  我们将切片好的demo目录放置到EasyDSS服务器的www目录中，例如：

  `www/videos`

  那么demo文件的点播地址就是：

  `http://{ip}:10088/videos/demo/video.m3u8`

### 直播调用

- 单次直播/录像/检索/回放流程

  以单次的警用单兵设备直播为例，在警用单兵 APP 中，以每一次案件或者警员出勤为例，我们为每一例案件或者出勤分配一个32位的 ID，然后再调用 EasyRTMP 推送到对应 EasyDSS 流媒体服务器，推送到：

  `rtmp://{ip}:{port}/hls/{ID}`

  >{ip} 为 EasyDSS 流媒体服务器 IP 地址，公网演示用的地址为：`www.easydss.com`
  >
  >{port} 为直播推流端口，默认为 10085
  >
  >{ID} 为本次直播的案件 ID 或者出勤记录 ID

  例如：我们推送到 

  `rtmp://www.easydss.com:10085/hls/b344ab65-0767-448e-beef-b3c7b3344dc4`

  那么本次直播现场的实时播放地址为：

  `rtmp://www.easydss.com:10085/hls/b344ab65-0767-448e-beef-b3c7b3344dc4`

  本次直播的实时录像回放地址可通过 **[视频回看接口](#playback)** 获取, 再根据侦办过程中的具体时间，对 Playback 地址进行回放即可；

  这样就能够将每一次侦办过程的直播、录像、检索、回放整个流程非常完美地完成！

### 服务接口

服务对外提供 HTTP RESTful 接口, 方便业务系统集成调用.

#### <span id="getlivesessions"></span>获取直播列表

GET /api/v1/getlivesessions

返回结果示例:

```js
{
	"EasyDarwin" : {
		"Body" : {
			"SessionCount" : 1,
			"Sessions" : {
				"Sessions" : [
					{
						"Application" : "hls",
						"AudioBitrate" : 2883,
						"HLS" : "/hls/stream_1/stream_1_live.m3u8",
						"Id" : "stream_1",
						"InBitrate" : 143932,
						"InBytes" : 375083894,
						"NumOutputs" : 0,
						"OutBitrate" : 0,
						"OutBytes" : 0,
						"RTMP" : "rtmp://127.0.0.1:10085/hls/stream_1",
						"Time" : "0h 47m 41s",
						"VideoBitrate" : 141084
					}
				]
			}
		},
		"Header" : {
			"Build" : "2017.1019.164630",
         	"Copyright" : "EasyDarwin",
         	"Version" : "v1.1"
		}
	}
}
```

| 字段           | 说明                 |
| ------------ | ------------------ |
| Id           | 设备 ID              |
| Application  | 直播类型,分为 live 和 hls |
| HLS          | hls直播地址            |
| RTMP         | rtmp直播地址           |
| InBitrate    | 推流输入码率             |
| OutBitrate   | 播放输出码率             |
| VideoBitrate | 视频码率               |
| AudioBitrate | 音频码率               |
| InBytes      | 推流总流量              |
| OutBytes     | 客户端播放总流量           |
| NumOutputs   | 客户端播放人数            |
| Time         | 直播时长               |

#### <span id="playback"></span>视频回看接口

##### 请求回看设备列表

GET /api/v1/query_record_devices

返回结果示例:

```json
{
	"msg": "success",
	"code": 0,
	"data": {
		"devices": [
			"stream_1000",
			"stream_1001"
		]
	}
}
```

| 字段      | 说明       |
| ------- | -------- |
| devices | 设备 ID 数组 |

##### 按月检索录像接口

GET /api/v1/query_record_monthly?id=xxx&period=yyyyMM

| 参数     | 类型     | 说明                     |
| :----- | :----- | :--------------------- |
| id     | string | 指明设备id                 |
| period | string | 格式yyyyMM, 指明查询哪个月的录像记录 |

返回结果示例:
​	
```json
{
	"data": {
		"flags" : "00001100..."
	},
	"code": 0,
	"msg": "成功"
}
```

| 字段    | 类型     | 说明                                |
| :---- | :----- | :-------------------------------- |
| flags | string | 固定长度31,每一位只能是"1"或"0", 分别表示当日有没有录像 |

##### 按日检索录像接口

GET /api/v1/query_record_daily?id=xxx&period=yyyyMMdd

| 参数     | 类型     | 说明                       |
| :----- | :----- | :----------------------- |
| id     | string | 指明设备id                   |
| period | string | 格式yyyyMMdd, 指明查询哪一天的录像记录 |

返回结果示例:

```json
{
	"data": {
		"list" : [{
			"start_time" : "20170731000000",
			"duration" : 90.00,
			"hls" : "/xxx/20170731000000/xxx_record.m3u8",
			"snap" : "/xxx/20170731000000/xxx_snap.png"
		},{
			"start_time" : "20170731010020",
			"duration" : 89.00,
			"hls" : "/xxx/20170731010020/xxx_record.m3u8",
			"snap" : "/xxx/20170731010020/xxx_snap.png"
		}]
	},
	"code": 0,
	"msg": "成功"
}
```

| 字段         | 类型      | 说明                         |
| :--------- | :------ | :------------------------- |
| start_time | string  | 录像开始时间, 格式: yyyyMMddHHmmss |
| duration   | integer | 录像历时，单位：秒                  |
| hls        | string  | 录像文件地址                     |
| snap       | string  | 录像快照地址                     |

##### 下载录像视频

GET /api/v1/download_video?id=xxx&time=yyyyMMddHHmmss

| 参数   | 类型     | 说明                                |
| :--- | :----- | :-------------------------------- |
| id   | string | 指明设备id                            |
| time | string | 格式yyyyMMddHHmmss, 所要下载录像视频的起始录制时间 |

返回结果示例:

```json
{
	"data": {
		"url" : "/hls/1031/20180115/20180115153245/tmp.mp4"
	},
	"code": 0,
	"msg": "success"
}
```

| 字段         | 类型      | 说明                         |
| :--------- | :------ | :------------------------- |
| url | string  | 录像 mp4 文件下载地址 |

> **注:** 接口返回录像mp4文件下载地址, 客户端立即访问可能404, 因为后台合成mp4文件需要一定时间,客户端可以发起一组循环探测,一旦下载地址不再是404,即可启动下载

##### 删除录像视频(按设备)

GET /api/v1/delete_files_device?id=xxx

| 参数   | 类型     | 说明     |
| :--- | :----- | :----- |
| id   | string | 指明设备id |

>注: 不可删除正在推流且开启录像设备录像视频, 业务层可通过[获取直播列表接口](#getlivesessions)确认指定设备是否处于推流且开启录像状态

##### 删除录像视频(按月)

GET /api/v1/delete_files_monthly?id=xxx&period=yyyyMM

| 参数     | 类型     | 说明                     |
| :----- | :----- | :--------------------- |
| id     | string | 指明设备id                 |
| period | string | 格式yyyyMM, 指明删除哪个月的录像记录 |

>注: 不可删除正在推流且开启录像设备的**当月**录像视频, 业务层可通过[获取直播列表接口](#getlivesessions)确认指定设备是否处于推流且开启录像状态

##### 删除录像视频(按日)

GET /api/v1/delete_files_daily?id=xxx&period=yyyyMMdd

| 参数     | 类型     | 说明                       |
| :----- | :----- | :----------------------- |
| id     | string | 指明设备id                   |
| period | string | 格式yyyyMMdd, 指明删除哪一天的录像记录 |

>注: 不可删除正在推流且开启录像设备的**当日**录像视频, 业务层可通过[获取直播列表接口](#getlivesessions)确认指定设备是否处于推流且开启录像状态

##### 删除录像视频(按录像文件)

GET /api/v1/delete_file?id=xxx&period=yyyyMMdd&filename=yyyyMMddHHmmss

| 参数       | 类型     | 说明                              |
| :------- | :----- | :------------------------------ |
| id       | string | 指明设备id                          |
| period   | string | 格式yyyyMMdd, 指明删除哪一天的录像记录        |
| filename | string | 格式yyyyMMddHHmmss, 指明删除当天哪一条录像文件 |

>注: 不可删除正在推流且开启录像设备的**当日**录像视频, 业务层可通过[获取直播列表接口](#getlivesessions)确认指定设备是否处于推流且开启录像状态

#### 获取基础配置信息 

GET /api/v1/getbaseconfig

返回结果示例:

```json
{
	"EasyDarwin" : {
		"Body" : {
			"HTTPWanPort" : 10088,
			"RTMPWanPort" : 10085,
			"ServerWanIP" : "127.0.0.1"
		},
		"Header" : {
			"Build" : "2017.1019.164630",
         	"Copyright" : "EasyDarwin",
         	"Version" : "v1.1"
		}
	}
}
```

| 字段          | 说明      |
| ----------- | ------- |
| HTTPWanPort | HTTP 端口 |
| RTMPWanPort | RTMP端口  |
| ServerWanIP | 服务器IP   |

#### 获取服务运行信息 ####

GET /api/v1/getserverinfo

返回结果示例:

```json
{
	"EasyDarwin" : {
		"Body" : {
			"Hardware" : "x86",
			"InterfaceVersion" : "v1",
			"RunningTime" : "0 Days 5 Hours 15 Mins 35 Secs",
			"Server" : "EasyDSS v1.0",
			"Validity" : "Validity Time Left: 51 day(s)"
		},
		"Header" : {
			"Build" : "2017.1019.164630",
         	"Copyright" : "EasyDarwin",
         	"Version" : "v1.1"
		}
	}
}
```

| 字段               | 说明       |
| ---------------- | -------- |
| Hardware         | 硬件信息硬件信息 |
| InterfaceVersion | 接口版本     |
| RunningTime      | 运行时间     |
| Server           | 软件信息     |
| Validity         | 授权信息     |


## 获取更多信息 ##

WEB：[www.EasyDSS.com](http://www.easydss.com)

Copyright &copy; www.EasyDSS.com 2012-2019

![EasyDarwin](http://upload-images.jianshu.io/upload_images/2692955-5abac51e6427ba78.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)  

