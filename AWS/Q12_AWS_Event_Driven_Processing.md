# Q12: AWS Event-Driven Processing

## Objective
To automatically validate and process CSV files uploaded to Amazon S3 and store the results in another S3 location.

## (a) Suitable Service for Processing

AWS Lambda is suitable for executing the processing code without managing servers. The Lambda function can read a CSV file, validate its contents, process valid records, and generate an output file.

## (b) Trigger Processing After an S3 Upload

1. Create an input S3 bucket or input prefix for uploaded CSV files.
2. Create a Lambda function containing the validation and processing logic.
3. Configure an Amazon S3 Object Created event notification to invoke the Lambda function when a CSV file is uploaded.
4. Configure the event filter for the appropriate prefix and `.csv` suffix.
5. Store the processed output in a separate S3 bucket or prefix.

**Workflow:** CSV upload → Amazon S3 event notification → AWS Lambda → validation and processing → output stored in S3.

## (c) IAM Permissions

Assign the Lambda function an execution role with least-privilege permissions.

- `s3:GetObject` on the designated input objects to read uploaded CSV files.
- `s3:PutObject` on the designated output objects to write processed results.
- CloudWatch Logs permissions to create log streams and publish log events.

Restrict each permission to the required resources. Avoid granting unrestricted access to all S3 buckets.

## (d) Error Handling and Logging

Configure the Lambda function to write processing messages and errors to Amazon CloudWatch Logs. Use structured log messages to record the input object, processing status, and failure reason without exposing confidential data.

Configure appropriate Lambda error handling, retries where suitable, and a dead-letter destination or failure destination where supported. Monitor invocation errors and duration using CloudWatch metrics and alarms.

## (e) Prevent Duplicate Processing and Recursive Triggering

- Make processing idempotent so that processing the same file again does not create duplicate results.
- Track processed object identifiers, such as the bucket, object key, and version or event identifier, using a suitable persistence mechanism.
- Configure the S3 notification to accept only the intended input prefix or `.csv` suffix.
- Store output files in a separate bucket or prefix that does not match the input event filter.

These measures reduce duplicate work and prevent the Lambda function from repeatedly triggering itself.

## Conclusion

Amazon S3 event notifications and AWS Lambda provide a serverless, event-driven solution for validating and processing CSV files. IAM roles, CloudWatch Logs, idempotency, and separate input and output locations improve security and reliability.
