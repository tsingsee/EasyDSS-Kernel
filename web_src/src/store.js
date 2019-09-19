import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

const store = new Vuex.Store({
    state: {
        logoText: "EasyDSS-Kernel",
        logoMiniText: "Kernel",
        serverInfo: {},
        menus: [
            {
                path: "/",
                icon: "desktop",
                title: "视频广场"
            }, {
            //     path: "/list",
            //     icon: "list",
            //     title: "切片详情"
            // }, {
                path: "/live",
                icon: "video-camera",
                title: "视频直播"
            }, {
                path: "/playback",
                icon: "backward",
                title: "视频回看"
            }, {
                path: "/player",
                icon: "play-circle",
                title: "H5播放器"
            }, {
                path: "/config",
                icon: "cogs",
                title: "基础配置"
            }, {
                path: "/about",
                icon: "support",
                title: "版本信息"
            }
        ]
    },
    mutations: {
        updateServerInfo(state, serverInfo){
            state.serverInfo = serverInfo;
        }
    },
    actions : {
        getServerInfo({commit}){
            $.ajax("/api/v1/getserverinfo").then(ret => {
                var serverInfo = Object.assign({}, ret.EasyDSS.Body, ret.EasyDSS.Header);
                commit('updateServerInfo', serverInfo);
            })
        }   
    }
})

export default store;