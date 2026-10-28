# Q11: EC2 Troubleshooting and CloudWatch

## Objective
To troubleshoot an EC2-hosted web application experiencing slow performance and connectivity problems using EC2 monitoring, network configuration, and Amazon CloudWatch.

## (a) Check EC2 Instance State and Status Checks

1. Open the AWS Management Console and navigate to **EC2 → Instances**.
2. Select the affected instance.
3. Verify that the instance state is **Running**.
4. Check the instance status checks:
   - **System status check:** Identifies problems with the underlying AWS infrastructure.
   - **Instance status check:** Identifies problems with the instance operating system or network configuration.
   - **Attached EBS status check:** Where available, identifies issues affecting attached EBS volumes.

If a check fails, inspect the reported issue and follow the recommended recovery or troubleshooting procedure.

## (b) Security Groups and Route Tables

**Security groups:** Security groups act as virtual firewalls for EC2 instances. Missing inbound rules for the application's port, such as TCP 80 for HTTP or TCP 443 for HTTPS, can prevent users from connecting. Outbound rules can also affect communication with other services.

**Route tables:** Route tables determine how network traffic travels from a subnet to its destination. Incorrect routes, a missing internet gateway route for a public subnet, or missing routes between networks can cause connectivity problems.

To troubleshoot, verify the security group rules, subnet association, route table entries, and network access requirements.

## (c) Configure a CloudWatch CPU Utilization Alarm

1. Open **Amazon CloudWatch → Alarms → Create alarm**.
2. Select the EC2 metric **CPUUtilization** for the affected instance.
3. Configure the threshold:
   - Statistic: Average
   - Period: 5 minutes
   - Condition: CPU utilization greater than 85%
   - Evaluation periods: 2 consecutive periods
4. Configure an alarm action, such as sending an Amazon SNS notification to an email subscription.
5. Name the alarm, review the configuration, and create it.

The alarm enters the **ALARM** state when CPU utilization exceeds 85% for the configured evaluation periods. With the example configuration, it evaluates two consecutive five-minute periods.

## (d) Investigate High CPU Utilization

Use **CloudWatch metrics** to inspect CPU utilization over time and identify when the problem started. Connect to the instance using an authorized method and run:

```bash
top
ps aux --sort=-%cpu | head
```

These commands help identify processes consuming the most CPU. Review application logs and system logs to determine the underlying cause.

## Conclusion

EC2 status checks, security group and route table verification, CloudWatch CPU alarms, and process-level investigation help identify and troubleshoot application performance and connectivity issues.