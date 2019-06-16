<template>
<div class="container-fluid no-padding">
	<div class="col-lg-offset-2 col-lg-8 no-padding server-info">
		<div class="box box-widget">
			<div class="box-header">
				<h3> <i class="fa fa-support"></i> 版本信息</h3>
			</div>
			<div class="box-body table-responsive no-padding">
				<table class="table table-striped">
                    <tbody>
                        <tr>
                            <td>硬件信息</td>
                            <td><span id="hardware-info">{{serverInfo.Hardware}}</span></td>
                        </tr>
                        <tr>
                            <td>接口版本</td>
                            <td><span id="interface-info">{{serverInfo.InterfaceVersion}}</span></td>
                        </tr>
                        <tr>
                            <td>运行时间</td>
                            <td><span id="running-time-info">{{serverInfo.RunningTime}}</span></td>
                        </tr>					
                        <tr>
                            <td>软件信息</td>
                            <td><span id="software-info">{{serverInfo.Server}} &nbsp; {{serverInfo.Version}} &nbsp; Build: {{serverInfo.Build}}</span></td>
                        </tr>
                    </tbody>
				</table>
			</div>
		</div>
        <div class="box box-widget">
			<div class="box-header">
				<h3> <i class="fa fa-key"></i> 授权信息</h3>
			</div>
			<div class="box-body table-responsive no-padding">
				<table class="table table-striped">
                    <tbody>
                        <tr>
                            <td>授权时间</td>
                            <td><span v-if="Validity.indexOf('Unlimited')<0">未授权&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;试用期还剩</span>
                                <span v-if="Validity.indexOf('Unlimited')>=0">永久授权</span>
                                <span v-if="Validity.indexOf('Unlimited')<0" id="validity-info">{{Validity}}</span>
                            </td>
                        </tr>
                        <tr  v-if="Validity.indexOf('Unlimited')<0">
                            <td>机器码</td>
                            <td>
                                <span id="key-info">{{machineCode}}</span>
                                <br />
                                <span style="color:#bbb">（通过邮箱：support@easydarwin.org 向商务人员咨询永久授权信息）</span>
                            </td>
                        </tr>					
                        <tr v-if="Validity.indexOf('Unlimited')<0">
                            <td>提交激活码</td>
                            <td>
                                <textarea  placeholder="输入申请到的激活码" rows="1" cols="50" v-model.trim="ActivationCode"></textarea>
                                </br>
                                <button @click="CheckCode">提交</button>
                            </td>
                        </tr>
                        
                    </tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</template>

<script>

import { mapState } from 'vuex'
export default {
  data(){
      return {
        Validity:"",
        machineCode:"",//机器码
        ActivationCode:"",//激活码
      }
  },
  computed: {
      ...mapState([
          "serverInfo",
      ])
  },
  mounted() {
    $.ajax('/api/v1/getserverinfo').then(data => {
        var Validity = data.EasyDarwin.Body.Validity;
        var reg2 = /([^:]+)$/;
        this.Validity = Validity.match(reg2)[1];
    })
     $.ajax('/api/v1/getrequestkey').then(key => {
        this.machineCode = key.EasyDarwin.Body.RequestKey
    })
  },
  
  methods:{
      CheckCode() {
         if(this.ActivationCode == ""){
            this.$message({
                type: 'error',
                message: '请输入激活码'
            });
             return false;
         } else{
            $.ajax('/api/v1/verifyproductcode?productcode=' + this.ActivationCode).then(data=>{
                if(data.EasyDarwin.Body.State==1){
                    this.$message({
                        type: 'success',
                        message: '授权成功，重启EasyDSS后生效！'
                    });
                    console.log("授权成功，重启流媒体服务器")
                }else{
                    this.$message({
                        type: 'error',
                        message: '输入有效激活码'
                    });
                }
            })
         }
      }
  },
}
</script>

