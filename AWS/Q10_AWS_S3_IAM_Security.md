# Q10: S3 and IAM Security

## Objective
To securely store confidential employee reports in Amazon S3 and restrict access to authorized HR employees.

## (a) Create a Private S3 Bucket and Upload a Sample File

1. Open the AWS Management Console and navigate to Amazon S3.
2. Select **Create bucket** and enter a globally unique bucket name, such as `hr-reports-<unique-suffix>`.
3. Select the required AWS Region.
4. Keep **Block all public access** enabled.
5. Create the bucket.
6. Create a sample file named `employee_report.txt` containing dummy employee-report data.
7. Open the bucket, select **Upload**, add the file, and complete the upload.

The bucket remains private, and access should be granted only through authorized IAM permissions.

## (b) IAM Policy for Read Access

Attach the following least-privilege policy to the IAM role or user authorized to read HR reports. Replace the example bucket name with the actual bucket name.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListDesignatedHRBucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::hr-reports-unique-suffix"
    },
    {
      "Sid": "ReadHRReportObjects",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::hr-reports-unique-suffix/*"
    }
  ]
}
```

**Explanation:**
- `s3:ListBucket` permits listing objects in the designated bucket.
- `s3:GetObject` permits reading objects in that bucket.
- The resource ARNs restrict these permissions to the designated bucket and its objects.
- No write or delete permissions are granted.

## (c) Verify Unauthorized Access Is Denied

1. Sign in using an IAM identity that does not have permission to read the HR report.
2. Attempt to open or download the object.
3. Verify that AWS denies the request, typically with an `AccessDenied` response.
4. Check the IAM policies and, if available, AWS CloudTrail events to investigate the denied request.

A successful test should demonstrate that the unauthorized identity cannot read the confidential file. An administrator's access alone does not prove that unauthorized access is blocked.

## (d) Encryption at Rest

Encryption at rest protects stored data by encrypting object contents on the storage system. Amazon S3 provides server-side encryption, including SSE-S3 and SSE-KMS options. When an authorized request retrieves an object, S3 decrypts it for the authorized recipient.

Encryption reduces the risk of exposing readable data if underlying storage is accessed improperly. It complements, but does not replace, IAM permissions and Block Public Access settings.

## Conclusion

A private S3 bucket, Block Public Access, a least-privilege IAM policy, unauthorized-access testing, and encryption at rest help protect confidential HR reports.
