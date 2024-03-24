<script setup lang="ts">
import pb from '@/lib/pocketbase'
import { useRoute } from 'vue-router'
import { onMounted } from 'vue'

const route = useRoute()

onMounted(() => {
  pb.collection('rooms').getFirstListItem(`name=${route.params.roomID}`)
})

</script>

<template>
  <main>
    <h2>Room: {{ route.params.roomID }}</h2>
  </main>
</template>