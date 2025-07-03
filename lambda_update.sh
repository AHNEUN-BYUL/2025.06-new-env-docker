#!/bin/bash
set -e

# ここに setup.sh 実行後に出力された固定 API ID を入力してください！
REST_API_ID="fexa1o66ua"

echo "Lambdaコード圧縮完了状態で行ってください。"

echo "Lambda関数のコードを更新中..."
aws lambda update-function-code \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --function-name my-local-lambda \
  --zip-file fileb://lambda_function.zip

echo "Lambda関数のコードが正常に更新されました！"

API_URL="http://localhost:4566/restapis/$REST_API_ID/local/_user_request_"
echo ""
echo "curlを使って更新後のLambdaをテスト中..."
curl -X POST $API_URL -d '{"key":"value"}'
echo ""
