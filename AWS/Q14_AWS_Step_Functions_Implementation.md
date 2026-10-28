# Q14: AWS Step Functions Implementation

## Objective
To execute ValidateFile, TransformData, and LoadResults sequentially using AWS Step Functions, with appropriate retry and error-handling policies.

## (a) Amazon States Language (ASL) JSON Definition

Replace the placeholder ARNs with the actual Lambda function ARNs before deployment.

```json
{
  "Comment": "Sequential data processing workflow",
  "StartAt": "ValidateFile",
  "States": {
    "ValidateFile": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:ValidateFile",
      "Next": "TransformData",
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "ValidationFailed"
        }
      ]
    },
    "TransformData": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:TransformData",
      "Next": "LoadResults",
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ],
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "TransformationFailed"
        }
      ]
    },
    "LoadResults": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:LoadResults",
      "End": true,
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "Next": "LoadingFailed"
        }
      ]
    },
    "ValidationFailed": {
      "Type": "Fail",
      "Error": "ValidationFailed",
      "Cause": "Input validation failed; processing stopped."
    },
    "TransformationFailed": {
      "Type": "Fail",
      "Error": "TransformationFailed",
      "Cause": "Transformation failed after retry or encountered an unrecoverable error."
    },
    "LoadingFailed": {
      "Type": "Pass",
      "Result": {
        "status": "FAILED",
        "message": "Loading failed permanently."
      },
      "Next": "RecordLoadingFailure"
    },
    "RecordLoadingFailure": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:REGION:ACCOUNT_ID:function:RecordFailure",
      "End": true
    }
  }
}
```

## (b) Retry Policy

The `TransformData` task retries selected transient AWS Lambda service errors.

- `IntervalSeconds: 2` — wait two seconds before the first retry.
- `MaxAttempts: 3` — allow up to three retries after the initial attempt.
- `BackoffRate: 2` — double the wait interval after each retry.

This reduces the impact of temporary service failures. Persistent errors are routed to `TransformationFailed` through the Catch transition.

## (c) Catch Transition for Loading Failure

The `LoadResults` task uses a Catch transition for any unhandled error. It moves to `LoadingFailed`, which prepares a failure result, then invokes `RecordFailure` to record the failure. The workflow therefore records the loading failure rather than reporting successful completion.

## (d) Passing Data Between Tasks

By default, Step Functions passes the output of one state as input to the next state. A Lambda task's returned JSON becomes available to the next task. `InputPath`, `ResultPath`, and `OutputPath` can be configured to select, combine, or filter the data passed between states.

## (e) Testing Successful and Failed Executions

1. Use valid input to test the successful sequence: ValidateFile → TransformData → LoadResults.
2. Use invalid input to confirm validation failure stops the workflow.
3. Simulate a transient transformation error and verify retries occur.
4. Simulate a permanent loading error and verify the Catch path invokes `RecordFailure`.
5. Inspect Step Functions execution history and CloudWatch Logs to verify state transitions, inputs, outputs, retries, and errors.

## Conclusion
The state machine executes the three processing functions sequentially. Retry handles selected transient transformation failures, Catch routes errors to dedicated states, and the loading failure path records unsuccessful execution.
