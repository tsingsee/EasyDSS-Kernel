<template>
    <div class="box box-success ids">
        <div class="box-header">
            <h4 class="text-success text-center">设备列表</h4>
            <div class="form-inline">
                <input type="text" class="form-control pull-right" placeholder="搜索" v-model.trim="q" ref="search">
            </div>
        </div>
        <div class="box-body">
            <el-table :data="pageData" stripe :show-header="false">
                <el-table-column min-width="120" inline-template>
                    <router-link :to="{ name:'timeview', params: {id : row} }" class="text-success" style="display:block;">{{row}}</router-link>
                </el-table-column>
            </el-table>
        </div>
        <div class="box-footer clearfix">
            <el-pagination layout="prev,pager,next" class="pull-right" :total="total" :page-size.sync="pageSize" :current-page.sync="currentPage"></el-pagination>
        </div>
    </div>
</template>

<script>
import Vue from 'vue'
import { Table, TableColumn, Pagination } from 'element-ui'
Vue.use(Table);
Vue.use(TableColumn);
Vue.use(Pagination);

import $ from 'jquery'

export default {
    data() {
        return {
            currentPage: 1,
            pageSize: 10,
            q: "",
            devices: []
        }
    },
    activated() {
        this.$refs['search'].focus();
    },
    mounted() {
        this.$refs['search'].focus();
        $.ajax("/api/v1/query_devices").then(data => {
            try{
                this.devices = data.data.devices || [];
            } catch(e) {
                this.devices = [];
            }
            if($.isEmptyObject(this.devices)){
                this.devices = [];
            }
        })
    },
    computed: {
        total() {
            return this.filterData.length;
        },
        pageData() {
            let start = (this.currentPage - 1) * this.pageSize;
            let end = start + this.pageSize;
            return this.filterData.slice(start, end);
        },
        filterData() {
            return this.devices.filter((val) => {
                return new RegExp(this.q, "i").test(val);
            })
        }
    },
    methods: {
        selectDevice(id){
            this.$emit("select-device", id);
        }
    }
}
</script>
