<template>
<div class="container-fluid no-padding">
    <keep-alive>
        <router-view @play="play"></router-view>
    </keep-alive>
</div>
</template>

<script>
export default {
  data(){
      return {
      }
  },
  methods: {
      play(video){
          this.$emit("play", video);
      }
  }
}
</script>

