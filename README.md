# Serverless To-Do List App

Welcome to the **Serverless To-Do List App**!  
This project is a modern, scalable, and cost-effective To-Do list application built with the Serverless framework, AWS Lambda, and API Gateway. All Lambda functions are implemented in **Python**.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Main Features](#main-features)
- [Tech Stack](#tech-stack)

---

## Overview

The **Serverless To-Do List App** is designed to help users manage their daily tasks efficiently. It leverages AWS Lambda (Python) for computation and API Gateway for exposing RESTful APIs, ensuring high availability and low operational costs.

---

## Architecture

```
Client (Web or Mobile)
        |
        v
API Gateway (REST API)
        |
        v
AWS Lambda Functions (Python)
        |
        v
Database (e.g., DynamoDB)
```

- **API Gateway**: Routes HTTP requests to the right Lambda functions.
- **AWS Lambda (Python)**: Handles all business logic for CRUD operations.
- **DynamoDB (or another DB)**: Stores tasks data.
- **IAM Roles**: Securely manages permissions for serverless resources.
- **Serverless Framework**: Manages deployment and infrastructure as code.

---

## Main Features

- Add, view, update, and delete to-do items
- All backend logic is written in Python
- Serverless architecture with pay-per-use billing
- RESTful API endpoints
- Easy deployment and scaling
- Minimal operational overhead

---

## Tech Stack

- **Backend:** AWS Lambda (Python), API Gateway
- **Database:** DynamoDB 
- **Infrastructure as Code:** Terraform
- **Language:** Python (Lambda runtime)

---
