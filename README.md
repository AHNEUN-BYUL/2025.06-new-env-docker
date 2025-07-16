# 🚀 環境構築ガイド

このリポジトリは、**Java 21 + Spring Boot 3 + Docker**をベースとした、新環境構築内容をまとめたものです。

---

## 🔧 環境構築手順

### ✅ 事前インストール

- [Java 21 (Amazon Corretto)](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html) インストール（Gradleビルドのため）
  - 例: `amazon-corretto-21.x.x-windows-x64.msi`
  - インストール後、環境変数設定必要
    > ※`Gradle Toolchain`をソース側に記載しましたので、今後自動認識してJava21にビルドします。
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) インストール及び実行
  - AMD64 ダウンロード
  - WSL2有効
- [Git](https://git-scm.com/)
- [Visual Studio Code](https://code.visualstudio.com/)
  - 拡張（必須）: Spring Boot Extension Pack, Docker, STS plugin, Extension Pack for Java, EditorConfig for VS Code, Google Java Format for VS Code(Jose V Sebastian), Vue(Official), SonarQube for IDE, JBoss Toolkit, Runtime Server Protocol UI
  - 拡張（選択）: Git Graph, GitHub Copilot, CSS Peek, Auto Close Tag, Auto Import, Auto Rename Tag, Better Comments, GitLens, TODO Highlight
- [Node.js](https://nodejs.org/)（Husky & Lint-staged 実行のため）
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)（Lambdaテスト環境用）

---

## ⚙️ プロジェクトの実行手順

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

## 🐳 Docker Compose 実行（複数サービス）

```bash
docker compose up -d
```

停止：

```bash
docker compose stop
```

---

## 🧪 Lambda テスト環境（LocalStack使用）

このプロジェクトでは、LocalStack を使用してローカルで Lambda + API Gateway をテスト可能な環境を構築しています。

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
