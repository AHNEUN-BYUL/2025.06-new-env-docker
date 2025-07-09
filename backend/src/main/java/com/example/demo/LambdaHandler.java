package com.example.demo;

import java.util.Map;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class LambdaHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> event, Context context) {
        context.getLogger().log("Received event: " + event);
        return Map.of(
            "statusCode", 200,
            "body", "LocalStack Java Lambda からの再応答です！"
        );
    }
}
