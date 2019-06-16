<template>
  <aside id="slider" class="main-sidebar">
    <section class="sidebar">
      <ul class="sidebar-menu">
          <router-link class="treeview" v-for="(item,index) in menus" :key="index" :to="item.path" tag="li" :exact="item.path == '/'">
            <a>
              <i :class="['fa', 'fa-' + item.icon]"></i>
              <span>{{item.title}}</span>
            </a>
          </router-link>
      </ul>
    </section>
  </aside>
</template>

<script>
import { mapState } from "vuex";

export default {
  props: {
    menus : {
        default : () => []
    }
  },
  computed: {
    path(){
      return location.pathname;
    }
  }
}

</script>

<style lang="css" scoped="true">
  .main-sidebar{
  /* Fix for IE */
  -webkit-transition: none;
  -o-transition: none;
  transition: none;
}
</style>

