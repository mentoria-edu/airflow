#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
INIT_FLAG="${SCRIPT_DIR}/.airflow_initialized"

echo "Creating necessary directories..."
mkdir -p ${SCRIPT_DIR}/dags ${SCRIPT_DIR}/logs ${SCRIPT_DIR}/plugins ${SCRIPT_DIR}/config

echo "Configuring AIRFLOW_UID..."
if [ ! -f ${SCRIPT_DIR}/.env ]; then
  echo -e "AIRFLOW_UID=$(id -u)" > ${SCRIPT_DIR}/.env
  echo ".env file created with AIRFLOW_UID=$(id -u)"
else
  echo ".env file already exists, skipping creation"
fi

if [ -f "$INIT_FLAG" ]; then
  echo ""
  echo "Airflow already initialized (flag file found: $INIT_FLAG)"
  echo "Skipping initialization and starting services..."
  echo ""
  docker compose -f ${SCRIPT_DIR}/docker-compose.yaml up -d
  exit 0
fi

echo "Initializing Airflow database and creating admin user..."
docker compose -f ${SCRIPT_DIR}/docker-compose.yaml up airflow-init

if [ $? -eq 0 ]; then
  touch "$INIT_FLAG"
  echo ""
  echo "Airflow initialization completed successfully!"
  echo "Flag file created: $INIT_FLAG"
  echo ""
  echo "Starting Airflow services..."
  docker compose -f ${SCRIPT_DIR}/docker-compose.yaml up -d
  
  echo ""
  echo "================================================"
  echo "Airflow is now running!"
  echo "Web UI: http://localhost:8080"
  echo "================================================"
else
  echo ""
  echo "Airflow initialization failed!"
  exit 1
fi