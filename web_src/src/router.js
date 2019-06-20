import Vue from 'vue'
import Router from 'vue-router'
import store from './store'

import AdminLTE from 'components/AdminLTE.vue'

import Index from 'components/Index.vue'
const VideoList = () => import( /* webpackChunkName: 'videolist' */ 'components/VideoList.vue')
const VideoLive = () => import( /* webpackChunkName: 'videolive' */ 'components/VideoLive.vue')

const Playback = () => import( /* webpackChunkName: 'playback' */ 'components/Playback.vue')
const DeviceBox = () => import( /* webpackChunkName: 'playback' */ 'components/DeviceBox.vue')
const PlaybackListBox = () => import( /* webpackChunkName: 'playback' */ 'components/PlaybackListBox.vue')
const PlaybackTimeBox = () => import( /* webpackChunkName: 'playback' */ 'components/PlaybackTimeBox.vue')

const Player = () => import( /* webpackChunkName: 'player' */ 'components/Player.vue')
const Config = () => import( /* webpackChunkName: 'config' */ 'components/Config.vue')
const About = () => import( /* webpackChunkName: 'about' */ 'components/About.vue')
const EasyRtmp = () => import( /* webpackChunkName: 'easyrtmp' */ 'components/EasyRtmp.vue')

Vue.use(Router);

const router = new Router({
    routes: [{
        path: '/',
        component: AdminLTE,

        children: [{
            path: '',
            component: Index,

        }, {
            //     path: 'list',
            //     component: VideoList
            // }, {
            path: 'live',
            component: VideoLive
        }, {
            path: 'playback',
            component: Playback,
            children: [{
                path: '',
                name: 'devicebox',
                component: DeviceBox
            }, {
                name: 'listview',
                path: 'listview',
                component: PlaybackListBox
            }, {
                name: 'timeview',
                path: 'timeview',
                component: PlaybackTimeBox
            }]
        }, {
            path: 'player',
            component: Player
        }, {
            path: 'config',
            component: Config
        }, {
            path: 'about',
            component: About
        }, {
            path: 'easyrtmp',
            component: EasyRtmp
        }, ]
    }, {
        path: '*',
        redirect: '/'
    }],
    linkActiveClass: 'active'
})
router.beforeEach(async (to, from, next) => {
    let title = await fn()
    document.title = title.Server
    function fn() {
    return new Promise((resolve, reject) => {
        $.ajax("/api/v1/getserverinfo").then(ret => {
            let serverInfo = Object.assign({}, ret.EasyDSS.Body, ret.EasyDSS.Header);
            resolve(serverInfo)
        })
    })
    }
    next()
})
export default router;