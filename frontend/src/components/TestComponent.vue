<template>
  <div class="test">
    <p>Prettier テスト</p>
  </div>
</template>

<script setup>
const name = "Test User"; // ← セミコロンが付いている (semi: false 違反)
const greeting = "Hello, " + name + "!" // ← セミコロンなし、OK
</script>

<style scoped>
.test {
  color: red;
}
</style>