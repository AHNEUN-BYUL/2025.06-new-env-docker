## 💡 準備事項

- [Java 21 (Amazon Corretto)](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html) インストール（Gradleビルドのため）
  - 例: `amazon-corretto-21.x.x-windows-x64.msi`
  - インストール後、環境変数設定必要
    > ※`Gradle Toolchain`をソース側に記載しましたので、今後自動認識してJava21にビルドします。
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) インストール及び実行
  - AMD64 ダウンロード
- Gitインストール及び使用可能状態
- vscodeの [Spring Boot Extension Pack](https://marketplace.visualstudio.com/items?itemName=vmware.vscode-boot-dev-pack) インストール
- vscodeの [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) インストール

---

## ⚙️ 実行方法

安は下記の通りにプロジェクト生成しました。

> - Language: Java
> - Spring Boot: 3.5.0
> - Java Version: 21
> - Dependencies: Spring Web
> - Group: com.example
> - プロジェクト生成後、Dockerfileファイル追加及び内容記入

### 1️⃣ プロジェクトクローン

```bash
git clone https://github.com/AHNEUN-BYUL/2025.06-new-env-docker.git
```

### 2️⃣ プロジェクトビルド（Gradle使用）

```bash
./gradlew clean build
```

- ビルドが完了した次第`build/libs`ディレクトリに`.jar`ファイルが生成されます。
- 例: `2025.06-new-env-docker-0.0.1-SNAPSHOT.jar`

### 3️⃣ Dockerイメージ生成

> ※ 本プロジェクトはDockerfileを含んでいますので、各自ローカルでDockerイメージをビルドしてください（イメージ共有はしていません）。

```bash
docker build -t helloworld-demo .
```

- 現在のディレクトリの`Dockerfile`を基準としてイメージをビルドします。
- `helloworld-demo`はDockerイメージの名前です。

### 4️⃣ Dockerコンテナ実行

```bash
docker run -p 8080:8080 helloworld-demo
```

- ローカルPCの8080ポートにコンテナの8080ポートにマッピングします。
- ウェブブラウザから次のURLで接続確認してください。
  - `http://localhost:8080`
  - 結果：`Hello, World!`画面が表示されます🎉

### 5️⃣ コンテナ終了

```bash
docker ps  # 実行中のコンテナ確認
docker stop <コンテナID及び名前>
```

---

## 📁 ファイル説明

| ファイル/ディレクトリ | 説明                                   |
| --------------------- | -------------------------------------- |
| `Dockerfile`          | Dockerイメージを作るための設定ファイル |
| `build.gradle`        | Gradleプロジェクト設定ファイル         |
| `src/`                | Javaソースコード                       |
| `README.md`           | 現在の文章（実行ガイド）               |

---

## 💬 参考事項

- GradleビルドはJava21が必要のため、JDK21インストールされていなければなりません。
- ビルド後生成される`.jar`ファイルの中で`-plain.jar`は実行用ではないので無視してください。
  - 使用: `*-SNAPSHOT.jar`

## Git Hook 構成 (Husky + lint-staged)

このプロジェクトはコミットの時、自動的にPrettier及びESLintを実行します。

### 事前条件

```bash
npm install
```
