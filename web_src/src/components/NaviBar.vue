<template>
  <header class="main-header">
    <router-link class="logo" style="position: relative;" to="/">
        <span class="logo-mini">{{logoMiniText}}</span>
        <span class="logo-lg">{{logoText}}</span>
        <span class='logo-lg label label-warning' style='position: absolute;top:8px;right: 20px;font-size: 8px;' v-if="versionText">{{versionText}}</span>
    </router-link>    
  
    <nav class="navbar navbar-static-top">
      <a class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>
    </nav>
  </header>
</template>

<script>

export default {
  props: {
    logoText: {
      default: "AdminLte"
    },
    logoMiniText: {
      default: "AD"
    },
    versionText: {
      default: ""
    }
  }
}

</script>

<style lang="css" scoped="true">
.main-header .navbar,
.main-header .logo {
  /* Fix for IE */
  -webkit-transition: none;
  -o-transition: none;
  transition: none;
}
</style>

