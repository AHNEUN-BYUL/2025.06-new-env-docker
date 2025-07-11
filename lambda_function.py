def handler(event, context):
    print("Received event:", event)
    return {
        'statusCode': 200,
        'body': 'LocalStack Lambda からの応答です！'
    }
