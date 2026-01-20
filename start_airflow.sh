#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

echo "Creating necessary directories..."
mkdir -p ${SCRIPT_DIR}/dags ${SCRIPT_DIR}/logs ${SCRIPT_DIR}/plugins ${SCRIPT_DIR}/config

echo "Configuring AIRFLOW_UID..."
if [ ! -f ${SCRIPT_DIR}/.env ]; then
  echo ".env file created with AIRFLOW_UID=$(id -u)"
else
  echo ".env file already exists, skipping creation"
fi

echo ""
echo "Setting up SSH keys for Airflow..."
SSH_DIR="${SCRIPT_DIR}/ssh"
SSH_KEY="${SSH_DIR}/id_rsa_airflow"

if [ ! -d "${SSH_DIR}" ]; then
  echo "Creating SSH directory: ${SSH_DIR}"
  mkdir -p ${SSH_DIR}
  chmod 700 ${SSH_DIR}
else
  echo "Directory SSH already exists, skipping creation"
fi

if [ ! -f "${SSH_KEY}" ]; then
  echo "Generating SSH key pair..."
  ssh-keygen -t rsa -b 4096 -f ${SSH_KEY} -N ""
  chmod 600 ${SSH_KEY}
  chmod 644 ${SSH_KEY}.pub
  echo "SSH Key Generated Successfully!"
  echo "IMPORTANT: Copy the public key to your client node!!"
else
  echo "SSH Key already exists, skipping creation"
fi

echo ""
echo "Initializing Airflow database and creating admin user..."
docker compose -f ${SCRIPT_DIR}/docker-compose.yaml up airflow-init

if [ $? -eq 0 ]; then
  echo ""
  echo "Airflow initialization completed successfully!"
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