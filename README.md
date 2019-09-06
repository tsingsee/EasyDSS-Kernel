# EasyDSS-Kernel

EasyDSS-Kernel是一款高性能流媒体音视频服务软件，是整个Easy系列商业产品的流媒体核心服务，EasyDSS-Kernel是[EasyDarwin开源团队](http://www.easydarwin.org "EasyDarwin开源流媒体服务器")和[TSINGSEE青犀团队](http://www.tsingsee.com "TSINGSEE青犀云视频")经过多年的商业发展和迭代磨砺，集各种大成于一体的商业流媒体服务软件，采用业界优秀的nginx服务框架模式设计，充分秉承了高性能、高并发、高可用、易扩展的设计理念，目前基于EasyDSS-Kernel的多款商业软件（[EasyDSS流媒体服务器](http://www.easydss.com "EasyDSS流媒体服务器")、[EasyNVR智能云终端](http://www.easynvr.com/ "EasyNVR智能云终端")、[EasyGBS国标流媒体服务](http://www.easygbs.com "EasyGBS国标流媒体服务")、[EasyNVS视频综合管理平台](http://www.easynvs.com/ "EasyNVS视频综合管理平台")）已经在旅游业、教育业、物流仓储、平安工地、能源环保、广电行业、工业与物联网、智能农业、视频智能分析等几乎所有的行业都已服务并稳定运营多年。EasyDSS移动互联网时代贴近企业点播/直播需求的一款接地气的流媒体服务器，可以形成一套完整的视频直播、录播解决方案，满足用户在各种行业场景的流媒体业务需求。

EasyDSS-Kernel是一套完全可靠的音视频流媒体服务，可基于EasyDSS-Kernel开发各种各样的流媒体应用！

## 服务参数

EasyDSS-Kernel在技术上非常好地融合了nginx、nginx-rtmp、flv、live555、ffmpeg等多项流媒体技术之大成：

### 主要性能参数包括

- [x] 支持多CPU多核心，能够充分挖掘硬件性能；
- [x] 7x24 全天候稳定运行；
- [x] 10Gb网卡,RTMP稳定输出8Gb/s+，HLS稳定输出9Gb/s+，稳定并发5K+连接；
- [x] 支持视频秒开；
- [x] 支持master/worker,自动请求master；
- [x] 支持负载均衡/集群；
- [x] 支持CDN部署(最大2W节点小型CDN)，部署简单；
- [x] 支持3台控制服务器热备，任意两台出问题不影响服务；
- [x] 支持Flash RTMP直播推送；
- [x] 支持RTMP信号源自由切换，播放不间断；
- [x] 录制回放支持多盘高速读写，硬盘写入与网卡完美匹配，支持分布式存储，可定制各种存储接口；
- [x] 单台服务器支持域名隔离；

### 主要技术参数包括

- [x] 接收RTMP推流：接收RTMP推流客户端推送的RTMP音视频流，并转发给播放客户端；
- [x] 分发RTMP流：提供RTMP流的高性能分发，RTMP播放客户端可直接连接EasyDSS进行播放；
- [x] 分发HLS流：提供同步输出HLS流的功能，可以将推送的RTMP流进行实时HLS切片，并提供HLS流的高性能分发；
- [x] 直播录像：支持将推送的直播流进行同步录像保存；
- [x] 直播录像检索：支持检索系统的直播录像，提供录像检索和列表接口；
- [x] 直播录像回放点播：可以点播录制的服务端录像，提供HLS点播，自由seek与倍数播放功能；
- [x] 录像下载：可以对检索到的录像段进行下载，另存为MP4文件；
- [x] HTTP服务器：高性能的HTTP服务支持，用于提供HTTP访问，同时用于HLS流分发（具备nginx所有属性功能）；
- [x] 防盗链：支持HTTP防盗链技术；
- [x] 主动拉取RTMP流进行转发：支持对RTMP流的主动拉取，并将此RTMP流进行RTMP/HLS的转发；
- [x] 转发RTMP流推送：支持将推送客户端推送的RTMP流，转发推送到其他RTMP流媒体服务器；
- [x] 推流鉴权验证：支持对推送客户端的推送流进行推流验证，若无权限的推流地址，则不接收客户端推流；
- [x] 推流信息统计：可以对推送流进行信息统计，包括推送时长、观看人数、起始时间、持续时长、视频码率、音频码率、推送流量等信息；
- [x] 播放鉴权：支持播放客户端播放验证，无权限的播放地址将无法进行播放；
- [x] 播放信息统计:对播放客户端的数量进行统计，并且可以统计客户端的开始时间、播放时长、播放流量等信息；
- [x] 跨平台：平台部署运行，Windows、Linux等；
- [x] 二次开发：提供HTTP二次开发接口，可使用接口进行一定的二次开发；
- [x] 支持lua扩展：支持自定义lua脚本扩展服务功能与接口功能；
- [x] 支持H.265：支持H.265视频编码格式的输入与输出；
- [x] 支持RTSP：支持同步输出RTSP协议流媒体；
- [x] 支持推送成功通知
- [x] 支持推送关闭通知
- [x] 支持播放前鉴权
- [x] 支持播放关闭后通知
- [x] 支持关键帧缓冲，支持直播秒开功能；

### 关于并发

程序并发没有任何限制，但是实际并发数取决于网卡的速率和CPU的性能以及视频码率。期待大家拿更性能更强的机器测试，性能强劲的机器需要优化easydss.conf发挥多CPU性能

### 支持的协议

1）输入协议：RTMP；
2）输出协议：RTMP、RTSP、HLS、HTTP-FLV；


### 目录结构

- release 

	发布目录

- web_src 

	前端网页代码目录

## 使用方法


### 如何运行

- windows

	cd easydss && 以管理员权限运行 `install service.bat`

- linux

	cd easydss && sh start.sh

## 如何配置

配置文件路径：conf/easydss.conf，注意：**无论是Windows还是Linux运行EasyDSS流媒体服务器，都不支持中文路径，请大家使用全英文路径**；

### 基础功能配置

	http{ easydss_host				127.0.0.1;				//本机对外服务IP,默认127.0.0.1
	http{ init_by_lua server:set("RECORD_PATH", "www/hls")	//录像检索的路径
	http{ server{ listen			10088,					//HTTP服务端口
	http{ server{ location{ root	www,					//HTTP Web目录
	
	rtmp{ server{ listen			10085,					//RTMP 服务端口
	rtmp{ server{ application{ hls_path	www/hls				//HLS直播切片目录


### 高级功能配置

1、rtmp功能配置

	rtmp {
		server {
			listen $RTMP_PORT;		#rtmp 监听端口，默认10085
	
			#application可以自定义多个,例如：live/hls/record

			application live {		#rtmp 直播应用
				live on;
			}
			
			application hls {		#hls 直播应用
				live on;			#live 表示只分发 rtmp
				hls on;				#hls 同步输出 rtmp 和 hls 直播
				hls_path $HLS_PATH;	#hls切片目录
				hls_fragment 4s;	#ts 切片时长
			}

			application record {	#record 直播应用
				live on;			#live 表示只分发 rtmp
				hls on;				#hls 同步输出 rtmp 和 hls 直播
				hls_record on;		#不配置或者配置 off 表示不录像，on 表示服务器端同步录像
				hls_path $RECORD_PATH;	#hls录像目录
				hls_fragment 4s;	#ts 切片时长
			}
		}
	}


2、rtmp拉流配置


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


例如配置为

`pull rtmp://www.easydass.com:10085/live/livetest name=livetest`，

则本地EasyDSS的转发地址为

`rtmp://ip:port/pulltest/livetest`

3、rtmp推流配置

EasyDSS提供rtmp推流转推功能


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


4、防盗链功能配置


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


addyourdomain 此处替换成您自己的域名如：

`www.easydss.com`

多个用空格分开，如：

`www.easydss.com *.easydss.com`

通过以上配置,当在其他网站下试图打开您域名下的视频时, 将会得到 `access denied` 信息表示防盗链配置成功.

5、接收推流处理-on_publish


	rtmp {
	    ...
	    application live {
	        live on;
	        ...
	        on_publish http://ip:port/xxxxx;
	    }
	    ...
	}



参数说明：

- method: POST

- MIME: application/x-www-form-urlencoded

- args: app  - RTMP的application名称

      name - 当前推流的流名称

- response: HTTP code返回200允许推流，其他为不允许


6、接收推流处理结束-on_publish_done


	rtmp {
	    ...
	    application live {
	        live on;
	        ...
	        on_publish_done http://ip:port/xxxxx;
	    }
	    ...
	}



参数说明：

- method: POST

- MIME: application/x-www-form-urlencoded

- args: app  - RTMP的application名称

      name - 当前推流的流名称

      begintime - 推流开始时间，从1970年1月1日的秒数

      duration - 推流持续时间，单位为秒

      inbytes - 推流总流量，单位为bytes

      outbytes - 客户端播放总流量，单位为bytes

7、客户端开始播放处理-on_play

	
	rtmp {
	    ...
	    application live {
	        live on;
	        ...
	        on_play http://ip:port/xxxxx;
	    }
	    ...
	}


参数说明：

- method: POST

- MIME: application/x-www-form-urlencoded

- args: app  - RTMP的application名称

      name - 当前推流的流名称

      addr - 客户端地址

- response: HTTP code返回200允许推流，其他为不允许


8、客户端停止播放处理-on_play_done

	
	rtmp {
	    ...
	    application live {
	        live on;
	        ...
	        on_play_done http://ip:port/xxxxx;
	    }
	    ...
	}

参数说明：

- method: POST

- MIME: application/x-www-form-urlencoded

- args: app  - RTMP的application名称

      name - 当前推流的流名称

      addr - 客户端地址

## 部署说明

### Windows

- 直接运行

  Windows 版本 EasyDSS 流媒体服务器运行比较简单，直接运行 `start.bat` 即可，此时可以在 Windows 进程管理器中可以看到 EasyDSS 的进程运行，这里有两点需要注意：

  1. EasyDSS 采用的是多进程模式，所以任务管理器中可能会有多个 `EasyDSS.exe` 进程；

  2. EasyDSS 运行日志无控制台显示，日志记录在 `logs/error.log`；

- 以服务的形式运行

  以服务的形式运行程序, 能够达到开机自启动的目的, 方便维护. 在发布包的根目录下有两个脚本文件 `install service.bat` 和 `uninstall service.bat`, 分别用来安装和卸载 EasyDSS 服务. 

### Linux

 - 启动服务,运行 easydss 目录里面的 `start.sh`；

    cd easydss
    	./start.sh

 - 停止服务,运行 `stop.sh` 即可；

    cd easydss
    	./stop.sh



> 启动服务后,在浏览器中打开测试页面，http://ip:10088


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

	{
	   "EasyDSS" : {
	      "Body" : {
	         "SessionCount" : 1,
	         "Sessions" : {
	            "Sessions" : [
	               {
	                  "Application" : "hls",
	                  "AudioBitrate" : 0,
	                  "AudioChannel" : 2,
	                  "AudioCodec" : "AAC",
	                  "AudioSampleRate" : 8000,
	                  "AudioSampleSize" : 16,
	                  "HLS" : "/hls/Livestream/Livestream_live.m3u8",
	                  "HTTP-FLV" : "/hls/Livestream.flv",
	                  "Id" : "Livestream",
	                  "InBitrate" : 0,
	                  "InBytes" : 167498,
	                  "NumOutputs" : 0,
	                  "OutBitrate" : 0,
	                  "OutBytes" : 0,
	                  "RTMP" : "rtmp://192.168.99.199:10085/hls/Livestream",
	                  "RTSP" : "rtsp://192.168.99.199:554/Livestream",
	                  "StartTime" : 1561102585655,
	                  "Time" : "0h 0m 9s",
	                  "VideoBitrate" : 0,
	                  "VideoCodec" : "H264",
	                  "VideoHeight" : 1280,
	                  "VideoWidth" : 720
	               }
	            ]
	         }
	      },
	      "Header" : {
	         "Build" : "2019.0620.105128",
	         "Copyright" : "www.easydss.com",
	         "Version" : "v3.0"
	      }
	   }
	}

| 字段           | 说明                 		|
| ------------ | ------------------ 		|
| Id           | 直播流ID              		|
| Application  | 直播类型,分为 live 和 hls 	|
| HLS          | hls直播地址            		|
| RTMP         | rtmp直播地址           		|
| HTTP-FLV     | http-flv直播地址           	|
| RTSP         | rtsp直播地址           		|
| InBitrate    | 推流输入码率           	  	|
| OutBitrate   | 播放输出码率             	|
| VideoBitrate | 视频码率               		|
| AudioBitrate | 音频码率               		|
| InBytes      | 推流总流量              	|
| OutBytes     | 客户端播放总流量           	|
| NumOutputs   | 客户端播放人数            	|
| Time         | 直播时长               		|
| AudioChannel | 音频通道数 					|
| AudioCodec   | 音频编码格式 				|
| AudioSampleRate | 音频采样率 				|
| AudioSampleSize | 音频采样大小 				|
| StartTime | 直播开始时间 					|
| VideoCodec | 视频编码格式 					|
| VideoHeight | 视频高 						|
| VideoWidth | 视频宽 						|

#### <span id="playback"></span>视频回看接口

##### 请求回看设备列表

GET /api/v1/query_record_devices

返回结果示例:

	
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
	{
		"data": {
			"flags" : "00001100..."
		},
		"code": 0,
		"msg": "成功"
	}


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

	{
		"data": {
			"url" : "/hls/1031/20180115/20180115153245/tmp.mp4"
		},
		"code": 0,
		"msg": "success"
	}


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

	{
	   "EasyDSS" : {
	      "Body" : {
	         "HTTPWanPort" : 10088,
	         "RTMPWanPort" : 10085,
	         "ServerWanIP" : "127.0.0.1"
	      },
	      "Header" : {
	         "Build" : "2019.0620.105128",
	         "Copyright" : "www.easydss.com",
	         "Version" : "v3.0"
	      }
	   }
	}


| 字段          | 说明      |
| ----------- | ------- |
| HTTPWanPort | HTTP 端口 |
| RTMPWanPort | RTMP端口  |
| ServerWanIP | 服务器IP   |

#### 获取服务运行信息 ####

GET /api/v1/getserverinfo

返回结果示例:

	{
	   "EasyDSS" : {
	      "Body" : {
	         "Hardware" : "x86",
	         "InterfaceVersion" : "v1",
	         "LiveCount" : "0,20",
	         "ProductType" : 0,
	         "RunningTime" : "0 Days 0 Hours 0 Mins 23 Secs",
	         "Server" : "EasyDSS-Kernel",
	         "Validity" : "Validity Time Left: 9 day(s)",
	         "VirtualLiveCount" : "0,20"
	      },
	      "Header" : {
	         "Build" : "2019.0620.105128",
	         "Copyright" : "www.easydss.com",
	         "Version" : "v3.0"
	      }
	   }
	}



| 字段               | 说明       |
| ---------------- | -------- |
| Hardware         | 硬件信息硬件信息 |
| InterfaceVersion | 接口版本     |
| RunningTime      | 运行时间     |
| Server           | 软件信息     |
| Validity         | 授权信息     |


## 更多流媒体音视频资源

EasyDarwin开源流媒体服务器：<a href="http://www.easydarwin.org" target="_blank" title="EasyDarwin开源流媒体服务器">www.EasyDarwin.org</a>

EasyDSS高性能互联网直播服务：<a href="http://www.easydss.com" target="_blank" title="EasyDSS高性能互联网直播服务">www.EasyDSS.com</a>

EasyNVR安防视频可视化服务：<a href="http://www.easynvr.com" target="_blank" title="EasyNVR安防视频可视化服务">www.EasyNVR.com</a>

EasyNVS视频综合管理平台：<a href="http://www.easynvs.com" target="_blank" title="EasyNVS视频综合管理平台">www.EasyNVS.com</a>

EasyNTS云组网：<a href="http://www.easynts.com" target="_blank" title="EasyNTS云组网">www.EasyNTS.com</a>

EasyGBS国标GB/T28181服务器：<a href="http://www.easygbs.com" target="_blank" title="EasyGBS国标GB/T28181视频服务器">www.EasyGBS.com</a>

EasyRTS应急指挥平台：<a href="http://www.easyrts.com" target="_blank" title="EasyRTS应急指挥平台">www.EasyRTS.com</a>

TSINGSEE青犀开放平台：<a href="http://open.tsingsee.com" target="_blank" title="TSINGSEE青犀开放平台">open.TSINGSEE.com</a>

Copyright © <a href="http://www.tsingsee.com" target="_blank" title="青犀TSINGSEE">www.TSINGSEE.com</a> Team 2012-2019

![青犀TSINGSEE](http://www.easydarwin.org/public/images/tsingsee_qrcode_160.jpg)
