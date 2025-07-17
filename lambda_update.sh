#!/bin/bash
set -e

# ここに setup.sh 実行後に出力された固定 API ID を入力してください！
REST_API_ID="7chna2gv7p"

echo "Lambdaコード圧縮完了状態で行ってください。"
# zip ファイルのパス (jar + zipTree方式の結果)
ZIP_PATH="backend/build/distributions/lambda.zip"

if [ ! -f "$ZIP_PATH" ]; then
  echo "エラー: $ZIP_PATH が見つかりません。lambdaZip タスクを実行してください。"
  exit 1
fi

echo "Lambda関数のコードを更新中..."
aws lambda update-function-code \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --function-name my-local-lambda \
  --zip-file fileb://$ZIP_PATH

echo "Lambda関数が更新され、Active になるまで待機中..."
aws lambda wait function-updated-v2 \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --function-name my-local-lambda

echo "Lambda関数のコードが正常に更新されました！"

API_URL="http://localhost:4566/restapis/$REST_API_ID/local/_user_request_"
echo ""
echo "curlを使って更新後のLambdaをテスト中..."
curl -X POST "$API_URL" -d '{"key":"value"}'
echo ""
