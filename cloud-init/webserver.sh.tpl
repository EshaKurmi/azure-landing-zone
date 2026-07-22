#!/bin/bash
# Cloud-init script: runs automatically on first boot.
# Installs Nginx and serves a simple page identifying this environment -
# so after `terraform apply` you have something real to open in a browser
# (via Bastion tunnel / curl) instead of an empty VM.

set -e

apt-get update -y
apt-get install -y nginx

cat > /var/www/html/index.html << HTML
<!DOCTYPE html>
<html>
<head>
  <title>Azure Landing Zone - ${environment}</title>
  <style>
    body { font-family: Arial, sans-serif; background:#0b1d33; color:#fff; text-align:center; padding-top:80px; }
    h1 { color:#3ddc97; }
    .badge { display:inline-block; padding:6px 16px; border-radius:20px; background:#3ddc97; color:#0b1d33; font-weight:bold; margin-top:10px; }
  </style>
</head>
<body>
  <h1>Deployed via Terraform</h1>
  <p>This VM lives in the <b>${environment}</b> spoke of the Azure Landing Zone.</p>
  <span class="badge">Environment: ${environment}</span>
  <p style="margin-top:40px; color:#888;">Provisioned by cloud-init on first boot — no public IP, accessed only via Azure Bastion.</p>
</body>
</html>
HTML

systemctl enable nginx
systemctl restart nginx
