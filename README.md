# 🚀 環境構築ガイド

このリポジトリは、**Java 21 + Spring Boot 3 + Docker**をベースとした、新環境構築内容をまとめたものです。

---

## 🔧 環境構築手順

### ✅ 事前インストール（必須）

- [Java 21 (Amazon Corretto)](https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html) インストール（Gradleビルドのため）
  - 例: `amazon-corretto-21.x.x-windows-x64.msi`
  - インストール後、環境変数設定必要
    - 例: `C:\Program Files\Amazon Corretto\jdk21.x.x_x\bin`
      > ※`Gradle Toolchain`をソース側に記載しましたので、今後自動認識してJava21にビルドします。
- [Docker Desktop](https://www.docker.com/get-started/) インストール及び実行
  - 設定バージョン：
    - **Docker version 28.1.1**
    - **Docker Compose version v2.35.1-desktop.1**
      > Docker Desktopは Docker Compose v2 バージョンを基本的に含めています。
  - AMD64 ダウンロード
  - WSL2有効（インストール中に WSL2 を有効にするオプションを選択します。）
    - オプション: ✓ Use WSL 2 instead of Hyper-V (recommended)
- [Git](https://git-scm.com/)
  - バージョン：git version 2.49.0.windows.1
- [Visual Studio Code](https://code.visualstudio.com/)
  - **拡張（必須）**:
    - Spring Boot Extension Pack
    - Docker
    - Extension Pack for Java
    - EditorConfig for VS Code
      - `.editorconfig` ファイルは、コードフォーマットのルールを定義しています。
      - Visual Studio Code を使用する場合、**EditorConfig for VS Code** 拡張機能をインストールするだけで自動的に適用されます。
      - 他の IDE を使用する場合も、対応する EditorConfig プラグインをインストールすることで同じルールを適用できます。
      - これにより、チーム全体でコードフォーマットの一貫性を維持できます。
    - Google Java Format for VS Code(Jose V Sebastian)
    - Vue(Official)
    - SonarQube for IDE
    - JBoss Toolkit
    - Runtime Server Protocol UI
  - 拡張（選択）:
    - Git Graph
    - GitHub Copilot
    - CSS Peek
    - Auto Close Tag
    - Auto Import
    - Auto Rename Tag
    - Better Comments
    - GitLens
    - TODO Highlight
- [Node.js](https://nodejs.org/)
  - バージョン：v22.16.0
  - フロントエンド依存関係のインストールやローカル開発サーバーの実行に必要です。
    - 例: Husky & Lint-staged など
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)（Lambdaテスト環境用）
  - バージョン：aws-cli/2.27.47 Python/3.13.4 Windows/11 exe/AMD64
  - Lambda テスト環境をローカルで構築するために必要です。

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

### 2️⃣ プロジェクトビルド（Gradle Wrapper使用）

まず、`backend` ディレクトリに移動してください:

> **why?** Gradle Wrapper(`gradlew`)が backend ディレクトリに配置されています。

```bash
cd backend
```

その後、以下のコマンドを実行してプロジェクトをビルドします:

```bash
./gradlew clean build
```

- Gradle Wrapper (`gradlew`) を使用することで、ローカルに Gradle をインストールする必要はありません。
- このコマンドを実行すると、プロジェクトに設定された Gradle バージョン (**8.14**) が自動的にダウンロードされ、使用されます。
  > **注意**: Gradle 7.x のバージョンではこのプロジェクトは正しく動作しません。必ず Gradle Wrapper を使用してください。
- ビルドが完了した次第 `build/libs` ディレクトリに `.jar` ファイルが生成されます。
- 例: `2025.06-new-env-docker-0.0.1-SNAPSHOT.jar`

### 3️⃣ タスクビルド（lambdaテスト用）

`backend` ディレクトリに移動してください:

```bash
./gradlew lambdaZip
```

- Lambda テストに必要な形式の zip ファイルが `backend/build/distributions` に生成されます。

### 4️⃣ Git Hook 構成 (Husky + lint-staged)

このプロジェクトはコミットの時、自動的にPrettier及びESLintを実行します。
プロジェクトのルートディレクトリで以下のコマンドを実行してください:

```bash
npm install
```

- このコマンドにより、`husky` と `lint-staged` がインストールされます。
- `husky` は Git Hook を設定し、コミット時に自動的にコードスタイルを検査します。
- `lint-staged` はステージングされたファイルに対してのみコードフォーマットを適用します。
- `husky` のインストール後、Git Hook が自動的に設定されます。

---

### 5️⃣ フロントエンド依存関係インストール（Vue.js）

`frontend` ディレクトリに移動してください:

```bash
cd frontend
```

その後、以下のコマンドを実行して依存関係をインストールします:

```bash
npm install
```

- Vue.js を含むフロントエンド依存関係がインストールされます。
- インストール後、フロントエンドの開発を開始できます。

### 6️⃣ フロントエンド開発サーバー起動

```bash
npm run dev
```

- ウェブブラウザから次のURLで接続確認してください。
  - `http://localhost:5173/demo/`
  - 結果：`You did it!`画面が表示されます🎉

## 🐳 Docker Compose 実行（複数サービス）

Docker Compose は複数のコンテナを一括で管理するツールです。このプロジェクトでは以下のサービスを使用しています:

- **app**: Spring Boot アプリケーション

  - Java 21 を使用して構築されたバックエンドサービスです。
  - HTTP リクエストを処理し、データベースや外部 API と連携します。

- **db**: PostgreSQL データベース

  - アプリケーションのデータを保存するためのリレーショナルデータベースです。
  - `pgdata/` ディレクトリにデータが永続化されます。

- **localstack**: Lambda + API Gateway テスト環境
  - AWS のサービスをローカルでシミュレーションするためのツールです。
  - Lambda 関数や API Gateway をローカルでテストできます。

Docker Compose を使用することで、これらのサービスを簡単に起動・停止できます。

### 実行方法

以下のコマンドを実行してください:

```bash
docker compose up -d
```

- これにより、すべてのサービスが自動的に起動します。
- 個別に `docker run` コマンドを実行する必要はありません。
- ローカルPCの8080ポートにコンテナの8080ポートにマッピングします。
- ウェブブラウザから次のURLで接続確認してください。
  - `http://localhost:8080`
  - 結果：`Hello, World!`画面が表示されます🎉

### 停止方法

サービスを停止するには以下のコマンドを使用します:

```bash
docker compose stop
```

---

## 📁 ファイル説明

| ファイル/ディレクトリ | 説明                                                                              |
| --------------------- | --------------------------------------------------------------------------------- |
| `Dockerfile`          | Dockerイメージを作るための設定ファイル                                            |
| `build.gradle.kts`    | Gradleプロジェクト設定ファイル（Kotlin DSL）                                      |
| `src/`                | Javaソースコード                                                                  |
| `README.md`           | 現在の文章（実行ガイド）                                                          |
| `docker-compose.yml`  | Docker Compose 設定ファイルで、複数のサービスを定義し実行します。                 |
| `lambda_setup.sh`     | Lambda 環境設定のためのスクリプトファイルです。                                   |
| `lambda_update.sh`    | Lambda 環境更新のためのスクリプトファイルです。                                   |
| `frontend/`           | Vue.js ベースのフロントエンドコードが含まれるディレクトリです。                   |
| `pgdata/`             | PostgreSQL データベース関連の設定およびデータファイルが含まれるディレクトリです。 |
| `localstack-data/`    | LocalStack 関連のキャッシュおよび設定ファイルが含まれるディレクトリです。         |

---

## 💬 参考事項

- GradleビルドはJava21が必要のため、JDK21インストールされていなければなりません。
- ビルド後生成される`.jar`ファイルの中で`-plain.jar`は実行用ではないので無視してください。
  - 使用: `*-SNAPSHOT.jar`

---

## 🛠️ よくある問題と解決方法

### 1️⃣ Node.js の インストールに失敗する場合

- 問題: `npm install` 実行時にエラーが発生する。
- 解決方法:
  - Node.js のバージョンを確認してください。推奨バージョンは `v22.17.1` です。
  - Node.js を再インストールしてください。[公式サイト](https://nodejs.org/)から最新バージョンをダウンロードできます。

### 2️⃣ PowerShellで .ps1 ファイルが実行できないエラー

- 問題: `npm` 実行時に次のようなエラーが出ることがあります。
  ```perl
  このシステムではスクリプトの実行が無効になっているため、xxx.ps1 を読み込むことができません。
  ```
- 解決方法:
  - これは PowerShell の実行ポリシーが厳しく設定されているためです。
  - 以下のコマンドを実行して、実行ポリシーを緩和してください。
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```

### 3️⃣ Docker Compose 実行時にエラーが発生する場合

- 問題: `docker compose up -d` 実行時にサービスが起動しない。
- 解決方法:
  - Docker Desktop が起動していることを確認してください。
  - `docker --version` を実行して Docker が正しくインストールされているか確認してください。
  - `docker compose logs` を使用してエラーの詳細を確認してください。

### 4️⃣ LocalStack のイメージ取得エラー

- 問題: `docker compose up -d` を実行した際に、以下のようなエラーが発生する場合があります。

```bash
failed to copy: httpReadSeeker: failed open: failed to do request: Get ...
lookup docker-images-prod.***.cloudflarestorage.com: no such host
```

> これは `LocalStack` イメージのダウンロード中に発生するネットワークエラーで、DNS 解決やプロキシの設定が原因となることがあります。

- 解決方法:
  - 以下のコマンドで `LocalStack` イメージを先に手動で取得してください。
  ```bash
  docker pull localstack/localstack
  ```
  - その後、再度 `docker compose up -d` を実行します。
  ```bash
  docker compose up -d
  ```

### 5️⃣ フロントエンド開発サーバーが起動しない場合

- 問題: `npm run dev` 実行後にブラウザでアクセスできない。
- 解決方法:
  - `frontend` ディレクトリで `npm install` を再度実行してください。
  - ポート `5173` が他のプロセスで使用されていないことを確認してください。

### 6️⃣ ボリューム関連のパーミッションエラーが発生する場合（特に Windows + WSL2 環境）

- 問題: `docker compose up -d` 実行時、PostgreSQL や LocalStack などのサービスが `permission denied` エラーで起動しない。
- 解決方法:
  - WSL2 のファイルシステムと Docker のボリュームマウントに関連する権限エラーの可能性があります。
  - プロジェクトルートの `pgdata/` や `localstack-data/` フォルダに適切なアクセス権を付与してください。
  - 以下のコマンドを WSL2 ターミナルで実行してみてください:
  ```bash
  chmod -R 777 pgdata localstack-data
  ```
  - それでも解決しない場合は、該当ディレクトリを削除して Docker により自動再生成させてください（※永続データは削除されます）。
  ```bash
  rm -rf pgdata localstack-data
  docker compose up -d
  ```

### 7️⃣ ポート競合でコンテナが起動しない場合

- 問題: `docker compose up -d` 実行後、`localhost:8080` や `localhost:5432` にアクセスできない、または既存のアプリが動作を阻害している。
- 解決方法:
  - すでに他のアプリケーションが該当ポート（例: 8080 や 5432）を使用している可能性があります。
  - 以下のコマンドでポートの使用状況を確認してください（PowerShell）:
  ```powershell
  netstat -aon | findstr :8080
  ```
  - 競合しているプロセスを停止するか、docker-compose.yml の該当ポートを別のポートに変更して再度起動してください。
  - 例: `8080:8080` を `8081:8080` に変更 → `http://localhost:8081` にアクセス

### 8️⃣ Git Bash で ./lambda_setup.sh 実行時のエラー対処法

- 問題: `./lambda_setup.sh` を Git Bash で実行すると、以下のようなエラーが発生する場合があります。

```bash
Unable to locate credentials. You can configure credentials by running "aws configure".
```

- 解決方法:
  - AWS CLI に認証情報（クレデンシャル）が設定されていないためです。
  - ただし、LocalStack を使用する場合は実際の認証は行われないため、ダミーの値でも問題ありません。
  - ①ターミナルで以下のコマンドを実行します。
  ```bash
  aws configure
  ```
  - ②以下のようにすべて test や適当な値を入力してください。
  ```pgsql
  AWS Access Key ID [None]: test
  AWS Secret Access Key [None]: test
  Default region name [None]: us-east-1
  Default output format [None]: json
  ```
