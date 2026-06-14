# Week 4 — Azure Data Pipeline using Azure Data Factory

> **End-to-end data pipeline built on Microsoft Azure: Blob Storage → ADF → Destination**

---

## What I Built

A fully functional cloud data pipeline that automatically picks up a CSV file from Azure Blob Storage, validates its metadata, and copies it to a destination — all orchestrated through Azure Data Factory.

**Pipeline Flow:**
```
Sample-Superstore.csv
        │
        ▼
  [source-data container]   ← Azure Blob Storage
        │
        ▼
  Get Metadata Activity     ← validates file exists, size, last modified
        │
        ▼
  ForEach + Copy Data       ← copies file to destination
        │
        ▼
   output.csv               ← destination (same storage, different path)
```

---

## Azure Resources Used

| Resource | Name | Purpose |
|---|---|---|
| Resource Group | `rg-adf-demo` | Organizes all resources |
| Storage Account | `kapiladf` | Hosts source and output data |
| Blob Container | `source-data` | Stores input CSV + output CSV |
| Data Factory V2 | `adf-kapil` | Pipeline orchestration engine |
| Linked Service | `ls_blob_storage` | ADF ↔ Blob Storage connection |
| Dataset (Source) | `ds_service_csv` | Points to Superstore CSV |
| Dataset (Destination) | `ds_output_csv` | Points to output.csv |
| Pipeline | `pl_copy_with_metadata` | Full pipeline with all activities |

---

## Pipeline Activities

### 1. Get Metadata
Fetches file properties before any data movement begins:
- `itemName` — confirms the correct file is present
- `size` — validates file is not empty
- `lastModified` — tracks when data was last updated

### 2. ForEach + Copy Data
Iterates over the metadata result and executes Copy Data to transfer the file from source to destination with 2.19 MiB transferred successfully.

---

## IAM Roles Configured

| Role | Assigned To | Scope |
|---|---|---|
| Owner | Kapil Singhal | Subscription (Inherited) |
| Reader | Kapil Singhal | This resource |
| Storage Blob Data Contributor | `adf-kapil` (Managed Identity) | This resource |

The `Storage Blob Data Contributor` role gives ADF permission to read from and write to Blob Storage without exposing any account keys.

---

## Screenshots

| # | Screenshot | Description |
|---|---|---|
| 1 | `screenshots/01_resource_group.png` | Resource Group with ADF + Storage |
| 2 | `screenshots/02_storage_account.png` | Storage Account overview |
| 3 | `screenshots/03_adf_instance.png` | ADF resource page |
| 4 | `screenshots/04_blob_container.png` | source-data container listing |
| 5 | `screenshots/05_linked_service.png` | ls_blob_storage — connection successful |
| 6 | `screenshots/06_datasets.png` | Source + Destination datasets |
| 7 | `screenshots/07_pipeline_canvas.png` | Pipeline with Get Metadata + ForEach + Copy Data |
| 8 | `screenshots/08_monitor_runs.png` | Monitor tab — 3 successful runs |
| 9 | `screenshots/09_iam_roles.png` | IAM role assignments |
| 10 | `screenshots/10_output_file.png` | output.csv in container after pipeline run |

---

## Key Learnings

- **Linked Services** are the authentication bridge between ADF and any external data store — without them, nothing connects.
- **Get Metadata before Copy** is a best practice: never blindly copy data without first validating the source file exists.
- **Managed Identity for IAM** is more secure than using storage account keys — ADF gets its own identity and only the permissions it needs.
- **ForEach activity** makes the pipeline dynamic — it can handle multiple files, not just one.
- **Debug vs Trigger** — Debug runs are for testing (free, instant); Triggers are for scheduling production runs.

---

## Repo Structure

```
week4-azure-adf-pipeline/
│
├── README.md
├── report.md                     ← Full written report
├── pipeline/
│   └── pipeline_export.json      ← ADF pipeline ARM/JSON definition
└── screenshots/
    ├── 01_resource_group.png
    ├── 02_storage_account.png
    ├── 03_adf_instance.png
    ├── 04_blob_container.png
    ├── 05_linked_service.png
    ├── 06_datasets.png
    ├── 07_pipeline_canvas.png
    ├── 08_monitor_runs.png
    ├── 09_iam_roles.png
    └── 10_output_file.png
```

---

## Dataset

**Superstore Sales Dataset** — [Kaggle Source](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

Used as the source CSV file uploaded to Azure Blob Storage to simulate a real-world data ingestion scenario.
