<template>
    <div class="modal fade" data-keyboard="true" data-backdrop="static" tabindex='-1'>
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
					    <span aria-hidden="true">&times;</span>
					</button>
                    <h4 class="modal-title text-success text-center">{{videoTitle}}</h4>
                </div>
                <div class="modal-body">
                    <EasyPlayer v-if="bShow" :videoUrl="videoUrl" :snapUrl="snapUrl" :live="live"></EasyPlayer>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>    
</template>

<script>
import 'jquery-ui/ui/widgets/draggable'
import EasyPlayer from '@easydarwin/easyplayer'

export default {
    data() {
        return {
            videoUrl: "",
            videoTitle: "",
            snapUrl: "",
            bShow: false
        }
    },
    props: {
        live : {
            type: Boolean,
            default: false
        }
    },
    mounted() {
        $(this.$el).find('.modal-content').draggable({
            handle: '.modal-header',
            addClasses: false,
            containment: 'document',
            delay: 100,
            opacity: 0.5
        });
        $(this.$el).on("hide.bs.modal", () => {
            this.bShow = false;
        }).on("show.bs.modal", () => {
            this.bShow = true;
        })
    },
    components: { EasyPlayer },
    methods: {
        play(src,_title,snap) {
            this.videoUrl = src||"";
            this.videoTitle = _title||"";
            this.snapUrl = snap||"";
            
            $(this.$el).modal("show");
        }
    }
}
</script>

<style lang="less" scoped>
.modal-title {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
</style>







