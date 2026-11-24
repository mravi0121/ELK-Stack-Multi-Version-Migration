#!/usr/bin/env bash
set -Eeuo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
ES_USER="${ES_USER:-elastic}"
: "${ES_PASSWORD:?Set ES_PASSWORD in the environment}"
CURL_OPTS=(--silent --show-error --fail)

echo "Pre-upgrade validation"
echo "====================="

echo "[1] Elasticsearch API"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/" >/dev/null
echo "[PASS] API responding"

echo "[2] Cluster health"
health="$(curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cluster/health")"
echo "$health"

status="$(printf '%s' "$health" | grep -oE '"status":"(green|yellow|red)"' | cut -d: -f2 | tr -d '"')"
if [[ "$status" == "red" ]]; then
  echo "[FAIL] Cluster is RED. Do not proceed without investigation." >&2
  exit 1
fi
echo "[PASS] Cluster is not RED (yellow still requires review)"

echo "[3] Disk space"
df -h

echo "[4] Service status"
for service in elasticsearch kibana logstash; do
  if systemctl is-active --quiet "$service"; then
    echo "[PASS] $service active"
  else
    echo "[WARN] $service is not active or unavailable"
  fi
done

echo "[5] Deprecation API"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_migration/deprecations?pretty"

echo
echo "Pre-upgrade checks completed. Review warnings and verify snapshots/backups manually."
