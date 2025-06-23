/// <reference types="vite/client" />

// TypeScriptが.vueファイルを認識できるようにするための型定義
declare module '*.vue' {
  import { DefineComponent } from 'vue';
  const component: DefineComponent<Record<string, unknown>, Record<string, unknown>, unknown>;
  export default component;
}
