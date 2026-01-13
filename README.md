#!/usr/bin/env bash
#
# ============================================================
# CS TRADER APP — FULL DOCUMENTATION 
# ============================================================
#
# This file documents how the CS Trader application works
# and how to run it locally using:
#
# - Docker
# - Kubernetes (Minikube)
# - Makefile automation
#
# Everything is written in Bash-style comments and commands
# so it can serve as both documentation and reference.
#
# ============================================================
# APPLICATION OVERVIEW
# ============================================================
#
# The application consists of three main components:
#
# 1. Frontend
#    - Nginx-based web frontend
#    - Docker image: mynginx
#
# 2. Backend (API)
#    - Python API
#    - Uses Poetry for dependency management
#    - Uses Alembic for database migrations
#    - Docker image: cstrader
#
# 3. Database
#    - PostgreSQL
#
# The entire stack runs inside a local Kubernetes cluster
# managed by Minikube.
#
# ============================================================
# EXPECTED PROJECT STRUCTURE
# ============================================================
#
# .
# ├── backend/
# │   ├── alembic.ini
# │   └── ops/Dockerfile
# ├── frontend/
# │   └── Dockerfile
# ├── infra/
# │   ├── api/
# │   ├── database/
# │   └── frontend/
# ├── .env
# ├── Makefile
# └── README.md
#
# ============================================================
# ENVIRONMENT VARIABLES (.env)
# ============================================================
#
# The application uses a .env file to store database credentials.
# These variables are converted into a Kubernetes Secret.
#
# Example .env file:
#
# POSTGRES_USER=postgres
# POSTGRES_PASSWORD=postgres
# POSTGRES_DB=cstrader
# POSTGRES_HOST=postgres
# POSTGRES_PORT=5432
#
# The secret created in Kubernetes will be called:
#
# database-credentials
#
# ============================================================
# REQUIREMENTS
# ============================================================
#
# You must have the following tools installed:
#
# - docker
# - minikube
# - kubectl
# - make
#
# Verify installations:
#
# docker --version
# minikube version
# kubectl version --client
# make --version
#
# ============================================================
# HOW THE MAKEFILE WORKS
# ============================================================
#
# The Makefile automates the full lifecycle of the application:
#
# - Start Kubernetes cluster
# - Build Docker images
# - Deploy Kubernetes manifests
# - Create secrets from .env
# - Run database migrations
# - Run a basic API test
# - Expose the frontend locally
#
# ============================================================
# STEP 1 — START MINIKUBE CLUSTER
# ============================================================
#
# Starts Minikube and enables required addons.
#
make start-cluster
#
# What this does internally:
# - minikube start
# - enables registry addon
# - enables ingress addon
#
# ============================================================
# STEP 2 — BUILD DOCKER IMAGES
# ============================================================
#
# Builds frontend and backend Docker images
# and loads them into Minikube cache.
#
make build
#
# Images built:
# - mynginx   (frontend)
# - cstrader  (backend)
#
# ============================================================
# STEP 3 — DEPLOY TO KUBERNETES
# ============================================================
#
# Applies all Kubernetes manifests and creates secrets.
#
make deploy
#
# This step:
# - Creates the "database-credentials" secret from .env (if missing)
# - Deploys database resources
# - Deploys backend API
# - Deploys frontend
# - Waits for ingress controller to be ready
#
# ============================================================
# STEP 4 — RUN DATABASE MIGRATIONS
# ============================================================
#
# Executes Alembic migrations inside the backend pod.
#
make migrations
#
# Internally:
# - Waits for PostgreSQL pod
# - Waits for backend pod
# - Runs:
#
# poetry run alembic upgrade head
#
# ============================================================
# STEP 5 — TEST THE APPLICATION
# ============================================================
#
# Registers a test user via the backend API
# and exposes the frontend locally.
#
make test
#
# Test user created:
#
# Name:     Teste
# Email:    testa@test.com
# Password: Secure1!
#
# Frontend available at:
#
# http://localhost:8080
#
# ============================================================
# FULL AUTOMATED RUN (RECOMMENDED)
# ============================================================
#
# Runs everything from start to finish:
#
# 1. start-cluster
# 2. build
# 3. deploy
# 4. migrations
# 5. test
#
make run
#
# After this command, the application is fully running.
#
# ============================================================
# CLEANUP — REMOVE EVERYTHING
# ============================================================
#
# Deletes all Kubernetes resources and stops Minikube.
#
make cleanup
#
# This will:
# - Delete all manifests
# - Delete the database secret
# - Destroy the Minikube cluster
#
# ============================================================
# FINAL RESULT
# ============================================================
#
# After running `make run`:
#
# - Kubernetes cluster is running
# - Frontend and backend are deployed
# - Database is migrated
# - Test user is created
# - Application is accessible locally
#
# ============================================================
# END OF FILE
# ============================================================
