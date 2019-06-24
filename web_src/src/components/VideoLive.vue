<template>
<div class="container-fluid no-padding">
    <el-popover ref="format" placement="bottom" trigger="hover">
        <img src="~assets/images/push-url-format.png" style="width:1000px;height:350px;">
    </el-popover>    
	<div class="alert alert-success alert-dismissible">
        <small>
		    <strong><i class="fa fa-info-circle"></i> 提示 : </strong> 
            桌面直播工具可以采用<a href="http://blog.csdn.net/xiejiashu/article/details/68483758" target="_blank"> OBS推流工具 <i class="fa fa-external-link"></i></a>，
            手机直播可以采用<router-link to="/easyrtmp" target="_blank"> EasyRTMP <i class="fa fa-external-link"></i></router-link>，
            &nbsp;&nbsp;
            <span class="push-url-format" v-popover:format>推流URL规则: rtmp://{ip}:{port}/{application}/{id}</span> ，
            例如 : rtmp://www.easydss.com:10085/hls/your_stream_id
        </small>
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
	<div class="box box-success">
		<div class="box-header">
			<h4 class="text-success text-center">直播列表</h4>
            <form class="form-inline pull-right hidden-xs">
                <div class="form-group">
                    <label>显示模式 &nbsp;</label>
                    <select v-model.trim="viewMode" class="form-control" ref="view-model">
                        <option value="list">列表模式</option>
                        <option value="block4">四分屏</option>
                        <option value="block16">十六分屏</option>
                    </select>
                    <button type="button" class="btn btn-default" @click.prevent="fullscreen" v-show="viewMode == 'block4' || viewMode == 'block16'" title="全屏显示">
                        <i class="fa fa-arrows-alt"></i>
                    </button>
                </div>                
            </form>            
            <form class="form-inline visible-xs">
                <select v-model.trim="viewMode" class="form-control" ref="view-model">
                    <option value="list">列表模式</option>
                    <option value="block4">四分屏</option>
                    <option value="block16">十六分屏</option>
                </select>
            </form>             
		</div>
		<div class="box-body">
            <el-table :data="pageData" stripe v-if="viewMode == 'list'" class="view-list">
                <el-table-column prop="Id" label="Stream ID" min-width="150"></el-table-column>
                <el-table-column prop="Application" label="直播类型" min-width="100"></el-table-column>
                <el-table-column prop="InBitrate" label="推送码率" min-width="120" :formatter="formatInBitrate"></el-table-column>
                <el-table-column prop="InBytes" label="推送流量" min-width="120" :formatter="formatInBytes"></el-table-column>
                <el-table-column prop="NumOutputs" label="在线人数" min-width="100"></el-table-column>
                <el-table-column prop="Time" label="直播时长" min-width="150"></el-table-column>
                <el-table-column prop="Time" label="操作" width="180" inline-template fixed="right">
                   <div>
                    <el-dropdown split-button type="primary"  size="mini"  @click="handleClick(row)">
                        播放
                        <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item><span @click="onChange('FLV',row)">HTTP-FLV</span></el-dropdown-item>
                            <el-dropdown-item><span @click="onChange('HLS',row)">HLS(m3u8)</span></el-dropdown-item>
                            <el-dropdown-item><span @click="onChange('RTMP',row)">RTMP</span></el-dropdown-item>
                        </el-dropdown-menu>
                        </el-dropdown>
                        <el-button type="primary" size="mini" @click="dialogFormVisibles(row)"><i class="fa fa-exclamation-circle"></i> 直播详情</el-button>
                   </div>
                </el-table-column>
            </el-table>  
            <div v-if="viewMode == 'block4'" class="view-block4">
                <EasyPlayer v-for="idx in 4" :key="`block4-${idx}`" :videoUrl="videoUrl(idx)" :videoTitle="videoTitle(idx)" live muted class="col-xs-6 no-margin no-padding block-video"></EasyPlayer>
            </div>
            <div v-if="viewMode == 'block16'" class="view-block16">
                <EasyPlayer v-for="idx in 16" :key="`block16-${idx}`" :videoUrl="videoUrl(idx)" :videoTitle="videoTitle(idx)" live muted class="col-xs-3 no-margin no-padding block-video"></EasyPlayer>
            </div>                        
		</div>
		<div class="box-footer clearfix">
			<el-pagination layout="prev,pager,next" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage"></el-pagination>
		</div>
	</div>
    <el-dialog title="直播信息" :visible.sync="dialogFormVisible">
    <el-row class="el-row-span">
        <el-col :span="7"><span>HTTP-FLV播放地址</span></el-col>
        <el-col :span="15" class="el-col-span">
            <span v-clipboard="form.flv" @success="handleSuccess" @error="handleError"><i class="fa fa-files-o"></i></span>
        <el-input  :disabled="true" v-model="form.flv" auto-complete="off"></el-input></el-col>
    </el-row>
    <el-row class="el-row-span">
        <el-col :span="7"><span>HLS(m3u8)源地址</span></el-col>
        <el-col :span="15" class="el-col-span"> <span v-clipboard="form.hls" @success="handleSuccess" @error="handleError"><i class="fa fa-files-o"></i></span>
            <el-input  :disabled="true" v-model="form.hls" auto-complete="off"></el-input>
        </el-col>
    </el-row>
    <el-row class="el-row-span">
        <el-col :span="7"><span>RTMP播放地址</span></el-col>
        <el-col :span="15" class="el-col-span">
            <span v-clipboard="form.rtmp" @success="handleSuccess" @error="handleError"><i class="fa fa-files-o"></i></span>
            <el-input  :disabled="true" v-model="form.rtmp" auto-complete="off"></el-input>
        </el-col>
    </el-row>
    <el-row class="el-row-span">
        <el-col :span="7"><span>分享页面链接</span></el-col>
        <el-col :span="15" class="el-col-span"> 
            <span v-clipboard="form.share" @success="handleSuccess" @error="handleError"><i class="fa fa-files-o"></i></span>
            <el-input  :disabled="true" v-model="form.share" auto-complete="off"></el-input>
        </el-col>
    </el-row>
    <el-row class="el-row-span">
        <span></span>
        <el-col :span="7"><span>分享页面iframe集成</span></el-col>
        <el-col :span="15" class="el-col-span"> 
            <span v-clipboard="form.iframe" @success="handleSuccess" @error="handleError"><i class="fa fa-files-o"></i></span>
            <el-input  :disabled="true" v-model="form.iframe" auto-complete="off"></el-input>
        </el-col>
    </el-row>
    <el-row class="el-row-span">
        <el-col :span="7"><span>扫码观看</span></el-col>
        <el-col :span="15" class="el-qrcode-img"><Qrcode :value="form.sweep" tag="img" :options="{size: 150}"></Qrcode></el-col>
        
    </el-row>
    <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
    </div>
    </el-dialog>
    <VideoDlg ref="videoDlg" live></VideoDlg>		
</div>
</template>

<script>
import Vue from 'vue'
import { Table, TableColumn, Pagination , Popover,Option,Select,DropdownItem,Dropdown,DropdownMenu,Button,Form,Dialog,FormItem,Input,Row,Col} from 'element-ui'
import VideoDlg from 'components/VideoDlg.vue'
import prettyBytes from 'pretty-bytes'
import EasyPlayer from '@easydarwin/easyplayer'
import fullscreen from 'vue-fullscreen'
import Qrcode from "@xkeshi/vue-qrcode"
import VueClipboards from 'vue-clipboards'
 
Vue.use(VueClipboards)

Vue.use(fullscreen);

Vue.use(Table)
.use(TableColumn).use(Pagination)
.use(Popover).use(Option)
.use(Select).use(DropdownItem)
.use(Dropdown).use(DropdownMenu)
.use(Button).use(Form).use(Dialog)
.use(FormItem).use(Input)
.use(Row).use(Col);

export default {
    data() {
        return {
            currentPage : 1,
            lives: [],
            timer: 0,
            viewMode: 'list',
            value:'FLV',
            dialogFormVisible: false,
            form: {
                flv: '第三方',
                hls: '',
                rtmp: '',
                share: '',
                iframe: '',
                sweep: '',
                
            },
            formLabelWidth: '120px'
        }
    },
    components: { VideoDlg, EasyPlayer, Qrcode },
    beforeDestroy() {
        if(this.timer){
            clearInterval(this.timer);
            this.timer = 0;
        }
    },
    mounted(){
        this.update();
        this.timer = setInterval(() => {
            // this.viewMode == 'list' && this.update();
            this.update();
        },3000)
    },
    computed: {
        pageSize() {
            switch (this.viewMode) {
                case 'block4':
                    return 4;
                case 'block16':
                    return 16;
                default:
                    return 10;
            }
        },  
              
        total(){
            return this.lives.length;
        },
        pageData(){
            let start = (this.currentPage - 1) * this.pageSize;
            let end = start + this.pageSize;
            return this.lives.slice(start, end);
        }
    },
    methods: {
        onChange(value,row){
            this.value = value
            console.log(value,11);
            
             this.play(row)
        },
        handleClick(row){
            this.play(row)
            
        },
        dialogFormVisibles(row){
            this.dialogFormVisible = true
            this.form.rtmp = row.RTMP
            this.form.flv = window.location.origin + row['HTTP-FLV']
            this.form.hls = window.location.origin + row.HLS
            this.form.share = window.location.origin + `/share.html?id=${row.Id}`
            this.form.iframe = `<iframe src="${this.form.share}" width="640" height="360" style="border:0" allow="autoplay" allowfullscreen></iframe>`
            this.form.sweep = this.form.share
        },
        play(row){
            if(!row.HLS && (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID)){
                this.$message({
                    type: 'error',
                    message: '手机端不支持 live 类型直播， 请使用 hls 类型'
                });
                return;
            }
            if(this.value == 'HLS'){
              row.videoUrl = window.location.origin + row.HLS
            } else if(this.value == 'RTMP'){
                row.videoUrl = row.RTMP
            }else if(this.value == 'FLV'){
                row.videoUrl = window.location.origin + row['HTTP-FLV']
            }
            row.videoTitle = row.Id;
            // row.videoUrl = (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID) ? row.HLS : row.RTMP;
            this.$refs.videoDlg.play(row.videoUrl, row.videoTitle);
        },
        update(){
            $.ajax("/api/v1/getlivesessions", {dataType: "json"}).then(data => {
                this.lives = (data.EasyDSS.Body.Sessions||{}).Sessions||[];
            })            
        },
        formatInBitrate(row, col, val) {
            return prettyBytes(val) + "/s";
        },
        formatInBytes(row, col, val) {
            return prettyBytes(val);
        },
        videoUrl(idx) {
            if(this.pageData.length > idx - 1){
                var row = this.pageData[idx - 1];              
                return (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID ) ? row.HLS : row.RTMP;
            }
            return "";
        },
        videoTitle(idx) {
            if(this.pageData.length > idx - 1){
                var row = this.pageData[idx - 1];              
                return row.alias || row.Id;
            }
            return "";
        },
        handleSuccess(){
            this.$message('复制信息成功!');
        },
        handleError(){
            this.$message.error('复制信息失败!');
        },
 
        fullscreen() {
            this.$fullscreen.enter(this.$el.querySelector(`.view-${this.viewMode}`), {
                wrap: false
            })
        }        
    }
}
</script>

<style lang="less" scoped>
.block-video {
    border: 1px solid #FFF;
}
.fullscreen {
    position: fixed;
    left:0;top:0;right:0;bottom:0;
}
.inline-select {
    width: 80px;
   display: inline-block;
   select {
       cursor: pointer;
       padding: 2px;
       border: 1px solid #ccc;
       border-radius: 3px;
   }
   option {
    cursor: pointer;
   }
   select:hover{
       border: 1px solid #00a65a;
   }
}
.el-row-span {
    text-align: right;
    margin: 15px 0;
    span {
        line-height: 36px;
        display: inline-block;
        padding-right: 20px;
    }
}
.el-col-span {
    position: relative;
    >span {
        cursor: pointer;
        padding-left: 10px;
        position: absolute;
        top: 0;
        right: 0;
        height: 36px;
        width: 36px;
        z-index: 99;
        border: 1px solid #bfcbd9;
        background-color: #eef1f6;
        border-top-right-radius: 4px;
        border-bottom-right-radius: 4px;
    }
}
.el-qrcode-img {
    text-align: left;
}
</style>

