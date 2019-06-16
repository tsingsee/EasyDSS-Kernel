<template>
    <div class="container-fluid no-padding">
        <div class="box box-success videos">
            <div class="box-header">
                <h4 class="no-padding no-margin text-success text-center">切片详情</h4>
            </div>
            <div class="box-body">
                <el-table :data="pageData" stripe>
                    <el-table-column prop="videoName" label="视频名称" min-width="120"></el-table-column>
                    <el-table-column prop="videoState" label="切片状态" min-width="100" inline-template>
                        <a role="button" v-if="row.videoState == '已完成'" @click.prevent="play(row)" class="text-success">{{row.videoState}}</a>
                        <span v-else>{{row.videoState}}</span>
                    </el-table-column>
                    <el-table-column prop="videoDir" label="原文件地址" min-width="300"></el-table-column>
                    <el-table-column prop="m3u8Dir" label="切片地址" min-width="300"></el-table-column>
                </el-table>
            </div>
            <div class="box-footer clearfix">
                <el-pagination layout="prev,pager,next" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage"></el-pagination>
            </div>
        </div>
    </div>
</template>

<script>
import Vue from 'vue'
import { Table, TableColumn, Pagination } from 'element-ui'
Vue.use(Table);
Vue.use(TableColumn);
Vue.use(Pagination);

export default {
    data() {
        return {
            currentPage : 1,
            pageSize: 10,
            videos: []
        }
    },
    mounted(){
        $.ajax("/EasyTrans/Json/list.json", {dataType: "json"}).then(data => {
            this.videos = data.list;
        })
    },
    computed: {
        total(){
            return this.videos.length;
        },
        pageData(){
            let start = (this.currentPage - 1) * this.pageSize;
            let end = start + this.pageSize;
            return this.videos.slice(start, end);
        }
    },
    methods: {
        play(row){
            row.videoTitle = row.videoName;
            this.$emit("play", row);
        }
    }
}
</script>

<style lang="less" scoped>

</style>


