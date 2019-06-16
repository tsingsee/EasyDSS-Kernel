<template>
    <div class="container-fluid no-padding">
        <br>
        <div class="col-sm-8 col-sm-offset-2">
            <form role="form" class="form-horizontal" id="url-form">
                <div class="form-group" style="position:relative;">
                    <div class="input-group" id="input-url-group">
                        <input type="text" class="form-control" id="input-url" name="url" placeholder="输入播放地址" v-model.trim="url" @keydown.enter.prevent="play" autocomplete="off" @focusin="showSuggest" @focusout="hideSuggest">
                        <span class="input-group-btn">
                            <a class="btn btn-primary" role="button" @click.prevent="play">
                                <i class="fa fa-play"></i> 播放</a>
                        </span>
                    </div>
                    <ul class="dropdown-menu" id="suggest" v-if="urls.length > 0">
                        <li v-for="(item, index) in urls" :key="index">
                            <a @mousedown.prevent="selectSuggest(item)" role="button">
                                {{item}}
                                <i class="fa fa-times-circle text-red fa-1x" @mousedown.prevent="deleteSuggest(index)" title="删除记录"></i>
                            </a>
                        </li>
                    </ul>        
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import 'jquery.cookie/jquery.cookie.js'

export default {
    data() {
        return {
            url: "",
            urls: []
        }
    },
    mounted() {
        var urls = $.cookie('input-urls');
        if(urls) {
            this.urls = urls.split(",");
        }
    },
    methods: {
        showSuggest() {
            $("#suggest").css({
                "left": $("#input-url").position().left,
                "top": $("#input-url").position().top + $("#input-url").outerHeight(),
                "width": $("#input-url").outerWidth()
            }).show();
        },
        hideSuggest() {
            setTimeout(function() {
                $("#suggest").hide();
            }, 100);
        },
        selectSuggest(val) {
            this.url = val;
            this.hideSuggest();
        },
        deleteSuggest(idx) {
            this.urls.splice(idx,1);
            $.cookie('input-urls', this.urls.join(','), {
                expires: 365
            });
        },
        play() {
            if (!this.url) {
                this.$message({
                    type: 'error',
                    message: "播放地址不能为空"
                });
                return;
            }
            if (this.urls.indexOf(this.url) < 0) {
                this.urls.push(this.url);
                while (this.urls.length > 5) {
                    this.urls.shift();
                }
                $.cookie("input-urls", this.urls.join(','), {
                    expires: 365
                });
            }              
            this.$emit("play", { videoUrl: this.url, videoTitle : this.url });
        }
    }
}
</script>

<style lang="less" scoped>

#suggest {
    display: none;
    position: absolute;
    z-index: 1000;
    overflow: hidden;

    li {
        position: relative;

        i.fa-times-circle {
            position: absolute;
            right: 10px;
            top: 7px;
            cursor: pointer;
        }
    }
}
</style>

