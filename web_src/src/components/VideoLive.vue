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
                <el-table-column prop="Time" label="操作" min-width="100" inline-template fixed="right">
                    <a role="button" class="btn btn-xs btn-success" @click.prevent="play(row)"> <i class='fa fa-play'></i> 播放</a>
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
    <VideoDlg ref="videoDlg" live></VideoDlg>		
</div>
</template>

<script>
import Vue from 'vue'
import { Table, TableColumn, Pagination , Popover } from 'element-ui'
import VideoDlg from 'components/VideoDlg.vue'
import prettyBytes from 'pretty-bytes'
import EasyPlayer from 'easy-player'
import fullscreen from 'vue-fullscreen'
Vue.use(fullscreen);

Vue.use(Table).use(TableColumn).use(Pagination).use(Popover);

export default {
    data() {
        return {
            currentPage : 1,
            lives: [],
            timer: 0,
            viewMode: 'list'
        }
    },
    components: { VideoDlg, EasyPlayer },
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
        play(row){
            if(!row.HLS && (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID)){
                this.$message({
                    type: 'error',
                    message: '手机端不支持 live 类型直播， 请使用 hls 类型'
                });
                return;
            }
            row.videoTitle = row.Id;
            row.videoUrl = (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID) ? row.HLS : row.RTMP;
            this.$refs.videoDlg.play(row.videoUrl, row.videoTitle);
        },
        update(){
            $.ajax("/api/v1/getlivesessions", {dataType: "json"}).then(data => {
                this.lives = (data.EasyDarwin.Body.Sessions||{}).Sessions||[];
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
</style>

