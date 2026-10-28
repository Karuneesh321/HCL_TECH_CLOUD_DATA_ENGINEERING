# Q15: Azure Data Lake Storage and Security

## Objective
To securely store confidential business data using Azure Data Lake Storage Gen2 and control access through Microsoft Entra ID and Azure role-based access control (RBAC).

## (a) Configure a Storage Account

1. Sign in to the Azure portal.
2. Open Storage accounts and select Create.
3. Select the subscription, resource group, storage account name, and region.
4. In the advanced settings, enable **Hierarchical namespace** to use Azure Data Lake Storage Gen2.
5. Review the configuration and create the storage account.

## (b) Create a Filesystem and Upload a Dataset

1. Open the storage account.
2. Navigate to Data storage → Containers.
3. Create a container or filesystem, for example `business-data`.
4. Open the container and upload a sample CSV dataset.
5. Verify that the uploaded file appears in the container.

## (c) Microsoft Entra ID and Azure RBAC

Microsoft Entra ID provides identity and authentication services. Azure RBAC assigns permissions to users, groups, or service principals based on their roles.

For example, assign the **Storage Blob Data Reader** role to authorized analysts who need to read data. Assign write-capable roles only to identities that must upload or modify data. Scope role assignments to the required storage account or container where supported.

For more granular directory and file permissions, Azure Data Lake Storage Gen2 supports access control lists (ACLs). RBAC and ACLs can be used together to enforce data access requirements.

## (d) Verify Unauthorized Access Is Denied

1. Sign in as a test identity that has no appropriate data-access permission.
2. Attempt to list or read the dataset.
3. Verify that access is denied.
4. Review role assignments and ACLs if access is unexpectedly allowed.
5. Confirm that the authorized analyst can access the dataset while the unauthorized identity cannot.

## Conclusion
Azure Data Lake Storage Gen2, Microsoft Entra ID, Azure RBAC, and ACLs help protect confidential business data by enforcing identity-based access control and restricting unauthorized access.
