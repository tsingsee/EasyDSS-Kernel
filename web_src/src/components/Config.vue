<template>
    <div class="container-fluid no-padding">
        <div class="nav-tabs-custom col-lg-offset-2 col-lg-8 no-padding">
            <ul class="nav nav-tabs">
                <li class="active">
                    <a href="#dss-config" data-toggle="tab">EasyDSS 基础配置</a>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane active" id="dss-config">
                    <form role="form" class="form-horizontal" data-toggle="validator" data-disable="false">
                        <div class="form-group">
                            <label for="channel-snap-interval" class="col-sm-4 control-label">服务器IP</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="ServerWanIP" name="ServerWanIP" readonly="readonly" :value="ServerWanIP">
                                <span class="help-block with-errors"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="channel-snap-interval" class="col-sm-4 control-label">HTTP端口</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="HTTPWanPort" name="HTTPWanPort" pattern="^[0-9]+$" readonly="readonly" :value="HTTPWanPort">
                                <span class="help-block with-errors"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="service-lan-ip" class="col-sm-4 control-label">RTMP端口</label>
                            <div class="col-sm-7">
                                <input type="text" class="form-control" id="RTMPWanPort" name="RTMPWanPort" pattern="^[0-9]+$" readonly="readonly" :value="RTMPWanPort">
                                <span class="help-block with-errors"></span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            ServerWanIP: "",
            HTTPWanPort: "",
            RTMPWanPort: ""
        }
    },
    mounted() {
        $.ajax("/api/v1/getbaseconfig", { dataType: "json" }).then(ret => {
            var data = ret.EasyDarwin.Body;
            this.ServerWanIP = data.ServerWanIP;
            this.HTTPWanPort = data.HTTPWanPort;
            this.RTMPWanPort = data.RTMPWanPort;
        })
    }
}
</script>

