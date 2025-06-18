// 【ES Modules】ルーターインスタンスを作成し、ルートを定義します。
/**
 * ? Vue Routerの設定ファイルです。
 */
import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.VITE_BASE_URL), // .env環境変数から取得
  routes: [ // ルートの定義
    {
      path: '/',              // ルートパス
      name: 'home',           // 内部で使用するルート名
      component: HomeView,    // ルートに対応するコンポーネント
    },
    {
      path: '/about',
      name: 'about',
      /**
       * * 非同期コンポーネントの読み込み(lazy-load)
       * これにより、初期ロード時にこのコンポーネントは読み込まれません。
       * ユーザーがこのルートにアクセスしたときにのみ読み込まれます。
       */
      component: () => import('../views/AboutView.vue'),
    },
  ],
})

export default router
