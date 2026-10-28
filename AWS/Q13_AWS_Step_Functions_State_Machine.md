# Q13: AWS Step Functions State Machine Design

## Objective
To coordinate sales-file processing through validation, transformation, aggregation, storage, and completion notification using AWS Step Functions.

## (a) Suitable States

The workflow contains the following states:

1. **ValidateFile:** Invokes a Lambda function to check the input file.
2. **ValidateResult:** A Choice state evaluates whether the file is valid.
3. **TransformData:** Invokes a Lambda function to transform the sales data.
4. **CalculateSales:** Calculates total sales by product.
5. **StoreResults:** Stores the aggregated results in Amazon S3.
6. **SendNotification:** Sends a completion notification, for example through Amazon SNS.
7. **InvalidFile:** Stops processing when validation fails.
8. **ProcessingFailed:** Records an unrecoverable workflow failure.

## (b) Choice State

The Choice state checks the validation result. If `isValid` is `true`, execution proceeds to transformation. If `isValid` is `false`, execution moves to the invalid-file failure path. This prevents invalid files from entering subsequent processing stages.

## (c) Retry and Catch

- **Retry:** Retries transient errors, such as temporary service failures, using an interval and a maximum number of attempts.
- **Catch:** Routes an unrecoverable error to an error-handling state, where the failure can be recorded and an appropriate notification sent.

Retries should be limited to suitable transient errors rather than all failures.

## (d) Invoking AWS Services

Step Functions can invoke Lambda functions through Task states and can also integrate with supported AWS services using service integrations. Each task receives input from the workflow and returns output for subsequent states.

## (e) Execution History

The execution history records state transitions, task inputs and outputs where configured, execution timestamps, and error details. Administrators can use it to identify the failed state, inspect the reported error, and troubleshoot the workflow.

## Example Amazon States Language (ASL)

Replace the placeholder Lambda and SNS ARNs before deploying this example.

```json
{
  "Comment": "Sales file processing workflow",
  "StartAt": "ValidateFile",
  "States": {
    "ValidateFile": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:ValidateFile",
      "Next": "CheckValidation",
      "Retry": [
        {
          "ErrorEquals": ["Lambda.ServiceException", "Lambda.TooManyRequestsException"],
          "IntervalSeconds": 2,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ],
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "ProcessingFailed"
        }
      ]
    },
    "CheckValidation": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.isValid",
          "BooleanEquals": true,
          "Next": "TransformData"
        }
      ],
      "Default": "InvalidFile"
    },
    "TransformData": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:TransformData",
      "Next": "CalculateSales"
    },
    "CalculateSales": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:CalculateSales",
      "Next": "StoreResults"
    },
    "StoreResults": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:StoreResults",
      "Next": "SendNotification"
    },
    "SendNotification": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:REGION:ACCOUNT_ID:SalesCompletionTopic",
        "Message": "Sales file processing completed successfully."
      },
      "End": true
    },
    "InvalidFile": {
      "Type": "Fail",
      "Error": "InvalidSalesFile",
      "Cause": "Input file validation failed."
    },
    "ProcessingFailed": {
      "Type": "Fail",
      "Error": "SalesProcessingFailed",
      "Cause": "An unrecoverable processing error occurred."
    }
  }
}
```

## Conclusion
AWS Step Functions coordinates each stage, uses a Choice state to route invalid files, applies Retry and Catch error handling, and provides execution history for troubleshooting.
