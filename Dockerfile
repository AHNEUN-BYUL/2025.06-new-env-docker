# Amazon Corretto 21 JDK ベースのイメージ使用
FROM amazoncorretto:21

# 作業ディレクトリ作成
WORKDIR /app

# JARファイルコピー
COPY backend/build/libs/2025.06-new-env-docker-0.0.1-SNAPSHOT.jar app.jar

# アプリケーション実行
ENTRYPOINT ["java", "-jar", "app.jar"]