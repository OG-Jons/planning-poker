import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    // Route that has field roomID (e.g. /123)
      {
        path: '/:roomID',
      name: 'room',
      component: () => import('../views/RoomView.vue')
    }
  ]
})

export default router
