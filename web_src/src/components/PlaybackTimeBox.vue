<template>
	<div class="box box-success records">
		<div class="box-header">
			<h4 class="text-success text-center">录像({{id}})-时间轴视图</h4>
			<div class="form-inline">
				<div class="form-group">
					<router-link to="/playback" class="btn btn-primary btn-sm" exact>
						<i class="fa fa-chevron-left"></i> 返回
					</router-link>
				</div>
				<div class="form-group pull-right">
					<div class="input-group input-group-sm">
						<DatePicker class="form-control" :day.sync="day" ref="datePicker" :id="id"></DatePicker>
						<div class="input-group-btn">
							<button type="button" class="btn btn-sm btn-default" @click.prevent="showDatePicker">
								<i class="fa fa-calendar"></i>
							</button>
							<router-link :to="{ name: 'listview', params: { id: this.id, day: this.day}}" class="btn btn-default btn-sm">
								<i class="fa fa-hand-o-right"></i> 列表视图
							</router-link>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="box-body">
			<EasyPlayer :videoUrl="videoUrl" :currentTime="currentTime" @ended="onVideoEnd" @timeupdate="onVideoTimeUpdate" style="margin:0 auto; max-width:700px;" v-if="bActive" alt="当前时间没有录像"></EasyPlayer>
			<br>
			<br>
			<TimeRule :videos="videos" @timeChange="onTimeChange" ref="timeRule" v-show="bActive"></TimeRule>
			<br>
		</div>
		<div class="box-footer clearfix">
			<br>
		</div>		
	</div>
</template>

<script>
import moment from 'moment'
import DatePicker from 'components/DatePicker.vue'
import EasyPlayer from '@easydarwin/easyplayer'
import TimeRule from 'components/TimeRule.vue'

export default {
	data() {
		return {
			id: "",
			videos: [],
			videoUrl: "",
			currentTime: 0,
			bActive: false,
			day: moment().format('YYYYMMDD')
		}
	},
	components: {
		DatePicker, EasyPlayer, TimeRule
	},
	watch: {
		day: function (val) {
			this.updateVideos();
		}
	},		
	methods: {
		showDatePicker() {
			$(this.$refs['datePicker'].$el).focus();
		},
		updateVideos() {
			$.ajax("/api/v1/query_record_daily", {
				type: "get",
				data: {
					id: this.id,
					period: this.day
				}
			}).then(data => {
				if (data.code != 0) {
					return $.Deferred().reject();
				}
				var list = data.data.list || [];
				list.sort((a, b) => {
					return (a.start_time||"").localeCompare((b.start_time||""));
				})
				this.videos = list;
			})
		},
		onTimeChange(video){
			this.videoUrl = (video||{}).hls || "";
			this.currentTime = (video||{}).currentTime || 0;
		},
		onVideoEnd() {
			var idx = this.videoUrls.indexOf(this.videoUrl);
			if(idx >=0 && idx < this.videos.length - 1) {
				var nextVideo = this.videos[idx + 1];
				if(!nextVideo) return;
				var startTime = moment(nextVideo.start_time, 'YYYYMMDDHHmmss');
				var n = startTime.diff(startTime.clone().startOf('day'),'minutes');
				this.$refs['timeRule'].clickMinute(n);
			}
		},
		onVideoTimeUpdate(currentTime) {
			var idx = this.videoUrls.indexOf(this.videoUrl);
			if(idx >= 0 && idx < this.videos.length) {
				var video = this.videos[idx];
				var startTime = moment(video.start_time, 'YYYYMMDDHHmmss');
				startTime.add(currentTime, 'seconds');
				var n = startTime.diff(startTime.clone().startOf('day'),'minutes');
				this.$refs['timeRule'].clickMinute(n, false);
			}
		}
	},	
	computed: {
		videoUrls() {
			return this.videos.map((val, index, array) => {
				return (val||{}).hls;
			});
		}
	},
	activated() {
		this.id = this.$route.params.id;
		if (!this.id) {
			this.$router.replace("/playback");
			return;
		}
		let mmt = moment();
		this.day = this.$route.params.day || mmt.format('YYYYMMDD');
		this.updateVideos();
		this.bActive = true;
		let n = mmt.diff(mmt.clone().startOf('day'),'minutes');
		this.$refs.timeRule.clickMinute(n);
	},
	deactivated() {
		this.bActive = false;
	}
}
</script>

