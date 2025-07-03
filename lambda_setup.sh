#!/bin/bash
set -e

echo "Lambdaコード圧縮完了状態で行ってください。"
## powershell で実行する場合は、以下のコマンドを使用してください。
## Compress-Archive -Path .\lambda_function.py -DestinationPath .\lambda_function.zip -Force

echo "Lambda関数の作成中..."
aws lambda create-function \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --function-name my-local-lambda \
  --runtime python3.9 \
  --handler lambda_function.handler \
  --zip-file fileb://lambda_function.zip \
  --role arn:aws:iam::000000000000:role/lambda-role

echo "REST APIの作成中..."
REST_API_ID=$(aws apigateway create-rest-api \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --name my-local-api \
  --query 'id' \
  --output text)
echo "API ID: $REST_API_ID"

echo "Root Resource IDの取得中..."
ROOT_RESOURCE_ID=$(aws apigateway get-resources \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --rest-api-id $REST_API_ID \
  --query 'items[0].id' \
  --output text)
echo "Root Resource ID: $ROOT_RESOURCE_ID"

echo "ANYメソッドの作成中..."
aws apigateway put-method \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --rest-api-id $REST_API_ID \
  --resource-id $ROOT_RESOURCE_ID \
  --http-method ANY \
  --authorization-type NONE

echo "LambdaとAPI Gatewayの統合中..."
aws apigateway put-integration \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --rest-api-id $REST_API_ID \
  --resource-id $ROOT_RESOURCE_ID \
  --http-method ANY \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:my-local-lambda/invocations

echo "APIのデプロイ中..."
aws apigateway create-deployment \
  --endpoint-url http://localhost:4566 \
  --region us-east-1 \
  --rest-api-id $REST_API_ID \
  --stage-name local

echo ""
API_URL="http://localhost:4566/restapis/$REST_API_ID/local/_user_request_"
echo "セットアップが完了しました！"
echo ""
echo "curlを使ってLambdaをテスト中..."
curl -X POST $API_URL -d '{"key":"value"}'
echo ""
