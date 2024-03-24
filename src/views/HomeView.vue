<script setup lang="ts">
import { ref } from 'vue'
import pb from '@/lib/pocketbase'
import { useRouter } from 'vue-router'

const router = useRouter()
const username = ref('')

const createRoom = async (): Promise<void> => {
  const planner = await pb.collection('planners').create({ name: username.value, admin: true })

  let roomName = randomString();

  while (roomExists(roomName)) {
    roomName = randomString();
  }

  console.log('New Room', roomName);

  pb.collection('rooms').create({ name: roomName, planners: [planner.id] }).then((record) => {
    console.log(record);
  });

  // then push new URL to router
  await router.push(`/${roomName}`)
}

const roomExists = (name: string): boolean => {
  let exists = false;
  pb.collection('rooms').getFirstListItem(`name=${name}`)
  .then(async (record) => {
    if (record.items.length > 0) {
      let created = new Date(record.items[0].created)
      let now = new Date()
      let diff = now.getTime() - created.getTime()
      if (diff > 24 * 60 * 60 * 1000) {
        await pb.collection('rooms').delete(record.items[0].id)
      }
    }
  })
  return exists
}

const randomString = (): string => {
  return Math.random().toString(36).replace(/[^a-z]+/g, '').slice(0, 5);
}
</script>

<template>
  <main>
    <input placeholder="Username" type="text" v-model="username" />
    <button @click="createRoom">Create</button>
  </main>
</template>