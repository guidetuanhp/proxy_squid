# 🌐 Azure Proxy Setup Guide (Squid - No Authentication)

This guide walks you through setting up an HTTP proxy server using **Squid** on an **Ubuntu VM** hosted on **Microsoft Azure**.

## ✅ Requirements

* Azure CLI installed and authenticated
* A valid Azure subscription
* Bash terminal 

---

## 🚀 Step-by-Step Installation

### 1. Launch Bash Terminal

Use the Azure Cloud Shell or your local terminal with Azure CLI.

### 2. Copy and Run the Script Below

```bash
#!/bin/bash

# === CONFIGURATION ===
region="eastus"
admin_user="your_username"
admin_pass="Your_password@123"
image="Canonical:UbuntuServer:18.04-LTS:latest"
vm_size="Standard_B1s"

# === AUTO-GENERATED NAMES ===
number=$RANDOM
vmgroup="mygroup${number}0"
vmname="myname${number}0"
public_ip_name="myip${number}0"

# === CREATE RESOURCE GROUP ===
az group create --name $vmgroup --location $region

# === CREATE VM ===
az vm create \
  --resource-group $vmgroup \
  --name $vmname \
  --public-ip-address $public_ip_name \
  --image $image \
  --size $vm_size \
  --admin-username $admin_user \
  --admin-password $admin_pass \
  --authentication-type password \
  --generate-ssh-keys

# === OPEN ALL PORTS (Recommended: Restrict in production) ===
az vm open-port --ids $(az vm list -g $vmgroup --query "[].id" -o tsv) --port '*'

# === INSTALL SQUID PROXY SERVER ===
az vm run-command invoke -g $vmgroup -n $vmname --command-id RunShellScript \
  --scripts "wget https://raw.githubusercontent.com/guidetuanhp/proxy_squid/main/squid3-install.sh && sudo bash squid3-install.sh"

# === GET PUBLIC IP ===
public_ip=$(az vm show -d -g $vmgroup -n $vmname --query publicIps -o tsv)

# === PRINT CONNECTION DETAILS ===
echo "✅ Proxy VPS has been successfully created!"
echo "🌐 Public IP: $public_ip"
echo "🧑 Admin Login: $admin_user / $admin_pass"
echo "➡️ HTTP Proxy (no auth): ${public_ip}:2610"
```

---

## 🔗 Proxy Details

* **Type**: HTTP Proxy (no authentication)
* **Port**: `2610`
* **Usage Format**:

  ```
  http://<public_ip>:2610
  ```

---

## ⚠️ Notes

* **Security Warning**: This proxy has no authentication. Do not use it in production or expose it publicly without access controls.
