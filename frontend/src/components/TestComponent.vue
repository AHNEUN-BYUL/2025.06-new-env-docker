<template>
  <div class="test">
    <p>Prettier テスト</p>
    <p>{{ greeting }}</p>
  </div>
</template>

<script setup lang="ts">
  const name = 'Test User';
  const greeting = 'Hello, ' + name + '!';
</script>

<style scoped>
  .test {
    color: red;
  }
</style>
