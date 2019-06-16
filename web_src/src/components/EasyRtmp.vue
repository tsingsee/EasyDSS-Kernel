<template>
    <div class="container-fluid no-padding">
        <div class="col-lg-offset-2 col-lg-8 no-padding">
            <div class="box box-widget">
                <div class="box-header">
                    <h3> <i class="fa fa-sign-in"></i> EasyRTMP 直播推送功能组件</h3>
                </div>
                <div class="box-body no-padding">
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <td style="width:25%;">项目介绍</td>
                                <td>
                                    EasyRTMP是EasyDarwin团队开发的一套RTMP直播推送功能组件，内部集成了包括：基本RTMP协议、断线重连、异步推送、环形缓冲区、推送网络拥塞自动丢帧、缓冲区关键帧检索、事件回调(断线、音视频数据回调)，
                                    通过EasyRTMP我们就可以避免接触到稍显复杂的RTMP推送或者客户端流程，只需要调用EasyRTMP的几个API接口，就能轻松、稳定地进行流媒体音视频数据的推送，
                                    支持市面上绝大部分的RTMP流媒体服务器，包括Red5、Ngnix_rtmp、crtmpserver等主流RTMP服务器，
                                    全平台支持：Windows、Linux、ARM(各种交叉编译工具链)、Android、iOS;
                                </td>
                            </tr>					
                            <tr>
                                <td>EasyRTMP 项目地址</td>
                                <td><a href="https://github.com/EasyDarwin/EasyRTMP">https://github.com/EasyDarwin/EasyRTMP</a></td>
                            </tr>
                            <tr>
                                <td>EasyRTMP Android：支持前/后摄像头直播、安卓屏幕直播</td>
                                <td><a href="https://fir.im/easyrtmp">https://fir.im/easyrtmp</a>
                                    <br/>
                                    <img style="width: 200px;height: 200px;" :src="qr"></img>
                                </td>
                            </tr>
                            <tr>
                                <td>EasyRTMP iOS : 支持前/后摄像头直播</td>
                                <td><a href="https://itunes.apple.com/us/app/easyrtmp/id1222410811?mt=8">https://itunes.apple.com/us/app/easyrtmp/id1222410811?mt=8</a>
                                    <br/>
                                    <img style="width: 200px;height: 200px;" :src="ios_qr"></img>
                                </td>
                            </tr>					
                            <tr>
                                <td>详细介绍</td>
                                <td><a href="https://github.com/EasyDarwin/EasyRTMP/blob/master/README.md">https://github.com/EasyDarwin/EasyRTMP/blob/master/README.md</a></td>
                            </tr>
                        </tbody>					
                    </table>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import qr from 'assets/images/easyrtmp_qr.png'
import ios_qr from 'assets/images/easyrtmp_ios_qr.png'

export default {
  data(){
      return {
          qr: qr,
          ios_qr: ios_qr
      }
  }
}
</script>

