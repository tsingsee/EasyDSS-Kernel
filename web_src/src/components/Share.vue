<template>
  <EasyPlayer :videoUrl="videoUrl" live></EasyPlayer>
</template>

<script>
import EasyPlayer from '@easydarwin/easyplayer'
import $ from 'jquery'

export default {
  data() {
      return {
          videoUrl: ''
      }
  },
  mounted() {
      var id = this.getQueryString("id") || "";
      if(id){
          $.ajax('/api/v1/getlivesessions?id=' + id).then(data => {
                var body = data.EasyDSS.Body;
                if(!body) return;
                if(!body.HLS && (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID)){
                    this.$message({
                        type: 'error',
                        message: '手机端不支持 live 类型直播， 请使用 hls 类型'
                    });
                    return;
                }
                this.videoUrl = (videojs.browser.IS_IOS||videojs.browser.IS_ANDROID) ? body.HLS : body.RTMP;
          })

      }
  },
  methods: {
		getQueryString(name) {
			var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
			var r = window.location.search.substr(1).match(reg);
			if (r != null) {
				return unescape(r[2]);
			}
			return null;
		}
  },
  components: {
      EasyPlayer
  }
}
</script>
