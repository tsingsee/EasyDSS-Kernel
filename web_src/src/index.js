import Vue from 'vue'
import store from "src/store";
import router from 'src/router'

new Vue({
  el: '#app',
  store,
  router,
  template: `
  <transition>
    <router-view></router-view>
  </transition>
  `
})