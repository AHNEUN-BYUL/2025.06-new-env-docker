/// <reference types="vite/client" />

// TypeScriptが.vueファイルを認識できるようにするための型定義
declare module '*.vue' {
  import { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}