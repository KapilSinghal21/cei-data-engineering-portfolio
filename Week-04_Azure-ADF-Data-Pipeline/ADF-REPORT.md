# Azure Data Factory Data Pipeline Assignment Report

## Submitted By
**Kapil Singhal**

---

# 1. Objective

The objective of this assignment was to understand Microsoft Azure cloud services and build an end-to-end data pipeline using Azure Storage Account and Azure Data Factory. The project involved creating cloud resources, configuring datasets, building a pipeline using Get Metadata and Copy Data activities, executing the pipeline, and monitoring its execution.

---

# 2. Project Architecture

```text
Source CSV File
      │
      ▼
Azure Blob Storage
      │
      ▼
Get Metadata Activity
      │
      ▼
ForEach Activity
      │
      ▼
Copy Data Activity
      │
      ▼
Destination Blob Storage
```

The architecture demonstrates the complete data movement process from source storage to destination storage using Azure Data Factory orchestration activities.

---

# 3. Azure Resources Created

| Resource Type      | Resource Name         |
| ------------------ | --------------------- |
| Resource Group     | rg-adf-demo           |
| Storage Account    | kapiladf              |
| Azure Data Factory | adf-kapil             |
| Pipeline           | pl_copy_with_metadata |

---

# 4. Resource Group Creation

A Resource Group named **rg-adf-demo** was created in the **Central India** region. The Resource Group serves as a logical container for managing and organizing all Azure resources associated with the project.

### Figure 4.1 – Resource Group Overview

<img src="screenshots/Resource_group.png" width="1000">

### Observation

The Resource Group was successfully created and contains the Azure Storage Account and Azure Data Factory resources required for the implementation of the data pipeline.

---

# 5. Storage Account Creation

A Storage Account named **kapiladf** was created under the Resource Group. The Storage Account provides scalable cloud storage services and acts as both the source and destination location for the pipeline.

### Configuration Details

| Property             | Value                           |
| -------------------- | ------------------------------- |
| Storage Account Name | kapiladf                        |
| Region               | Central India                   |
| Performance          | Standard                        |
| Replication          | Locally Redundant Storage (LRS) |
| Account Type         | StorageV2 (General Purpose v2)  |

### Figure 5.1 – Storage Account Overview

<img src="screenshots/Storage.png" width="1000">

### Observation

The Storage Account was successfully provisioned and configured with standard performance and LRS replication for reliable data storage.

---

# 6. Azure Data Factory Creation

An Azure Data Factory instance named **adf-kapil** was created within the Resource Group. Azure Data Factory provides a cloud-based data integration service used for creating and managing data pipelines.

### Figure 6.1 – Azure Data Factory Overview

<img src="screenshots/ADF.png" width="1000">

### Observation

The Azure Data Factory instance was successfully deployed and is ready for creating and executing data integration workflows.

---

# 7. Dataset Configuration

Two datasets were configured in Azure Data Factory to establish communication with Azure Blob Storage.

| Dataset Name   | Purpose             |
| -------------- | ------------------- |
| ds_service_csv | Source Dataset      |
| ds_output_csv  | Destination Dataset |

The source dataset points to the input CSV file, while the destination dataset is configured to store the processed output data.

---

# 8. Pipeline Development

A pipeline named **pl_copy_with_metadata** was created to automate the data movement process.

The pipeline consists of the following activities:

### Get Metadata Activity

The Get Metadata activity retrieves information about the source file and validates its existence before processing.

### ForEach Activity

The ForEach activity iterates through the retrieved metadata and performs operations on each item dynamically.

### Copy Data Activity

The Copy Data activity transfers data from the source dataset to the destination dataset.

### Pipeline Workflow

```text
Get Metadata
      │
      ▼
ForEach
      │
      ▼
Copy Data
```

### Figure 8.1 – Pipeline Design and Execution

<img src="screenshots/Pipeline.png" width="1000">

### Observation

The pipeline was designed successfully and demonstrates the integration of metadata validation, iterative processing, and data transfer activities.

---

# 9. Pipeline Execution and Monitoring

The pipeline was executed using Azure Data Factory Debug mode.

### Execution Results

| Activity           | Status  |
| ------------------ | ------- |
| Get Metadata       | Success |
| ForEach            | Success |
| Copy Data          | Success |
| Pipeline Execution | Success |

### Monitoring Details

Azure Data Factory Monitoring was used to track:

* Pipeline execution status
* Activity execution status
* Runtime information
* Processing duration
* Error monitoring

### Observation

All activities completed successfully without errors, confirming that the pipeline correctly validated metadata and transferred data between storage locations.

---

# 10. Learning Outcomes

After completing this assignment, the following concepts were learned:

* Microsoft Azure Fundamentals
* Resource Group Management
* Azure Storage Account Configuration
* Azure Blob Storage Operations
* Azure Data Factory Development
* Dataset Creation and Configuration
* Metadata Retrieval Using Get Metadata Activity
* Iterative Processing Using ForEach Activity
* Data Movement Using Copy Data Activity
* Pipeline Monitoring and Debugging
* Cloud Data Engineering Fundamentals

---

# 11. Conclusion

This assignment successfully demonstrated the implementation of an end-to-end cloud-based data pipeline using Microsoft Azure services. Azure Storage Account was used for storing source and destination data, while Azure Data Factory was used to orchestrate data movement and processing activities.

The pipeline utilized Get Metadata, ForEach, and Copy Data activities to validate source files, process data, and transfer information between storage locations. Successful execution and monitoring of the pipeline confirmed the effectiveness of the implemented solution.

This project provided valuable hands-on experience with cloud data engineering concepts, data integration workflows, storage management, monitoring, and automation using Microsoft Azure.
