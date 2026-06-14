# Azure Data Pipeline — Week 4 Report

**Name:** Kapil Singhal
**Task:** Azure Cloud Fundamentals and Data Pipeline Implementation using ADF

---

## Objective

Build an end-to-end data pipeline on Microsoft Azure that ingests a CSV file from Blob Storage, validates its metadata, and copies it to a destination — using Azure Data Factory as the orchestration engine.

---

## Architecture

```
[Superstore CSV] → [Blob Storage: source-data] → [ADF Pipeline] → [output.csv]
                                                        │
                                              ┌─────────┴──────────┐
                                         Get Metadata         ForEach + Copy Data
                                       (validate file)        (transfer data)
```

---

## What Was Done

### 1. Resource Group
Created `rg-adf-demo` in **Central India** to keep all resources organized under one logical container.

### 2. Storage Account + Blob Container
- Storage Account: `kapiladf` (Standard, LRS)
- Container: `source-data` (Private access)
- Uploaded `Sample - Superstore.csv` (2.19 MiB) as the source dataset

### 3. Azure Data Factory
- Created ADF instance `adf-kapil` under the same resource group
- Launched ADF Studio and explored all three sections: **Author, Monitor, Manage**

### 4. Linked Service
Created `ls_blob_storage` — an Azure Blob Storage linked service connecting ADF to the `kapiladf` storage account. Connection tested successfully ✅

### 5. Datasets
| Dataset | Container | File |
|---|---|---|
| `ds_service_csv` | source-data | Sample - Superstore.csv |
| `ds_output_csv` | source-data | output.csv |

Both datasets use `ls_blob_storage` as their linked service with DelimitedText (CSV) format.

### 6. Pipeline — `pl_copy_with_metadata`

**Activities used:**

**Get Metadata** → Fetches `itemName`, `size`, and `lastModified` from the source file before any copy happens. This validates the file exists and is not empty.

**ForEach** → Iterates over metadata results dynamically.

**Copy Data** → Transfers data from `ds_service_csv` to `ds_output_csv`. Output: `output.csv` (2.19 MiB) successfully written to container.

### 7. Pipeline Execution
- Executed using **Debug** mode
- Monitored via **Monitor → Pipeline Runs**
- All 3 runs: ✅ Succeeded (avg duration: ~25s)

### 8. IAM Role Assignment
Configured access control on the Storage Account:

| Role | Principal | Type |
|---|---|---|
| Reader | Kapil Singhal | User |
| Storage Blob Data Contributor | adf-kapil | Managed Identity |

Using Managed Identity means ADF never needs a storage key — it authenticates securely through Azure AD.

---

## Pipeline Execution Results

| Activity | Status | Type | Duration |
|---|---|---|---|
| Get Metadata1 | ✅ Succeeded | Get Metadata | 16s |
| ForEach1 | ✅ Succeeded | ForEach | 3s |
| Copy data2 | ✅ Succeeded | Copy Data | ~3s |

**Pipeline Status: Succeeded**
**Run ID:** `92d22148-920b-4d3c-99f5-00f1474a4eb3`

---

## Summary

This assignment walked through the full lifecycle of building a cloud data pipeline on Azure. The most important concept was understanding how **Linked Services, Datasets, and Activities** work together — Linked Services handle authentication, Datasets define the data shape and location, and Activities do the actual work.

The **Get Metadata → Copy Data** pattern is a real-world best practice: always validate before moving data. Using **Managed Identity for IAM** instead of access keys is the secure, production-grade approach.

The pipeline ran successfully across 3 debug executions with consistent results, confirming the architecture is stable and repeatable.
