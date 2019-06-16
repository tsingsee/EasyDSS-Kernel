<template>
	<div class="box box-success videos">
		<div class="box-header">
			<h4 class="text-success text-center">录像({{id}}) - 列表视图</h4>
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
							<router-link :to="{ name: 'timeview', params: { id: this.id, day: this.day}}" class="btn btn-default btn-sm">
								<i class="fa fa-hand-o-right"></i> 时间轴视图
							</router-link>
						</div>
					</div>
				</div>
			</div>

		</div>
		<div class="box-body">
			<el-table :data="pageData" stripe empty-text="暂无数据, 请另选日期">
				<el-table-column min-width="120" label="Stream ID" prop="id"></el-table-column>
				<el-table-column min-width="180" label="开始时间" prop="start_time" ></el-table-column>
				<el-table-column min-width="120" label="录像时长" prop="duration"></el-table-column>
				<el-table-column min-width="450" label="视频地址" inline-template>
					<a role="button" class="text-success" @click.prevent="play(row)">{{row.hls}}</a>
				</el-table-column>
				<el-table-column min-width="150" label="操作" inline-template fixed="right">
					<div>
						<a role="button" class="btn btn-success btn-xs" @click.prevent="play(row)">
							<i class='fa fa-play'></i> 播放
						</a>
						<a role="button" class="btn btn-success btn-xs" @click.prevent="download(row)" v-loading.fullscreen.lock="bDownloading" element-loading-text="拼命加载中">
							<i class='fa fa-download'></i> 下载
						</a>	
					</div>
				</el-table-column>
			</el-table>
		</div>
		<div class="box-footer clearfix">
			<el-pagination layout="prev,pager,next" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage"></el-pagination>
		</div>
	</div>
</template>

<script>
import moment from 'moment'
import DatePicker from 'components/DatePicker.vue'
import axios from 'axios'

export default {

	data() {
		return {
			id: "",
			currentPage: 1,
			pageSize: 10,
			videos: [],
			day: moment().format('YYYYMMDD'),
			bDownloading: false
		}
	},
	components: {
		DatePicker
	},
	methods: {
		showDatePicker() {
			$(this.$refs.datePicker.$el).focus();
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
				this.videos = data.data.list || [];
				this.videos.sort((a,b) => {
					return a['start_time'] - b['start_time'];
				})
			})
		},
		play(row) {
			this.$emit("play", { videoUrl: row.hls, videoTitle: `${row.id}(${row.start_time})` });
		},
		download(row) {
			axios.get(`/query_video?id=${row.id}&time=${row._start_time}`).then(res => {
				var ret = res.data || {};
				if(ret.code == 0 && ret.data.url) {
					this.bDownloading = true;
					var timer = setInterval(() => {
						axios.head(ret.data.url).then(() => {
							clearInterval(timer);
							this.bDownloading = false;
							window.open(ret.data.url);
						}).catch(e => {
							console.log(e);
						})
					}, 800)
				}
			}).catch(e => {
				this.$message({
					type: 'error',
					message: e.message || "未知错误"
				})
			})
		}
	},
	activated() {
		this.id = this.$route.params.id;
		if(!this.id){
			this.$router.replace("/playback");
			return;
		}
		this.day = this.$route.params.day || moment().format('YYYYMMDD');
		this.updateVideos();
	},
	watch: {
		day: function (val) {
			this.updateVideos();
		}
	},
	computed: {
		total() {
			return this.videos.length;
		},
		pageData() {
			let start = (this.currentPage - 1) * this.pageSize;
			let end = start + this.pageSize;
			return this.videos.slice(start, end).map(row => {
				row.id = this.id;
				row._start_time = row.start_time;
				row.start_time = moment(row.start_time, "YYYYMMDDHHmmss").format("YYYY-MM-DD HH:mm:ss");
				row.duration = moment.utc(row.duration * 1000).format("HH:mm:ss");
				return row;
			})
		}
	}
}
</script>

