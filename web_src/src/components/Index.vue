  <template>
    <div class="container-fluid no-padding videos">
        <div class="col-sm-4 video" v-for="(video,index) in pageData" :key="index">
            <div class="thumbnail">
                <div class="wrapper" style="padding-bottom:55%;position:relative;height:auto;">
                    <div class="inner" style="position:absolute;top:0;bottom:0;left:0;right:0;">
                        <img style="width:100%;height:100%;" role="button" :src="video.snapUrl" :onerror="imgError" @click.prevent="play(video)">
                    </div>
                </div>
                <div class="caption text-center">
                    {{video.videoTitle}}
                </div>
            </div>
        </div>
    
        <div class="clearfix"></div>
        <el-pagination layout="prev,pager,next" :total="total" class="video-pager" :current-page.sync="currentPage" :page-size.sync="pageSize" v-if="total > pageSize"></el-pagination>
    </div>
</template>

<script>

import srcFallback from 'assets/images/snap.png'
import { Pagination } from 'element-ui'
import Vue from 'vue'

Vue.use(Pagination);

export default {
    data() {
        return {
            imgError: `this.src='${srcFallback}'`,
            currentPage: 1,
            pageSize: 6,
            videos: []
        }
    },
    mounted() {
        $.ajax("/videos/list.json", { dataType: "json" }).then(data => {
            if (!data || !Array.isArray(data.videos)) {
                this.$message("没有数据");
                return;
            }
            this.videos = data.videos;
        })
    },
    methods: {
        play(video) {
            this.$emit("play", video);
        }
    },
    computed: {
        total() {
            return this.videos.length;
        },
        pageData() {
            let start = (this.currentPage - 1) * this.pageSize;
            let end = start + this.pageSize;
            return this.videos.slice(start, end)
        }
    }
}
</script>

<style lang="less" scoped>
.video {
    .thumbnail {
        position: relative;

        .caption {
            padding: 5px;
        }
    }
    .mask {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(255, 255, 255, 0.5);
    }
}

.video-pager {
    text-align: center;
    margin: 0 auto;
}
</style>
