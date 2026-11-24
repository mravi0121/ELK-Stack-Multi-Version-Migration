#!/usr/bin/env bash
set -Eeuo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
ES_USER="${ES_USER:-elastic}"
: "${ES_PASSWORD:?Set ES_PASSWORD in the environment}"
CURL_OPTS=(--silent --show-error --fail)

failures=0

check_service() {
  local service="$1"
  if systemctl is-active --quiet "$service"; then
    echo "[PASS] $service active"
  else
    echo "[FAIL] $service inactive"
    failures=$((failures + 1))
  fi
}

echo "Post-upgrade validation"
echo "======================"

echo "[1] Elasticsearch API"
if curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/" >/dev/null; then
  echo "[PASS] Elasticsearch API responding"
else
  echo "[FAIL] Elasticsearch API check failed"
  failures=$((failures + 1))
fi

echo "[2] Cluster health"
if curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cluster/health?pretty"; then
  echo
else
  echo "[FAIL] Cluster health query failed"
  failures=$((failures + 1))
fi

echo "[3] Services"
check_service elasticsearch
check_service kibana
check_service logstash

echo "[4] Elasticsearch nodes"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cat/nodes?v" || failures=$((failures + 1))

echo "[5] Index status"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cat/indices?v" || failures=$((failures + 1))

if (( failures > 0 )); then
  echo "Validation completed with $failures failure(s). Review before accepting migration."
  exit 1
fi

echo "Basic automated checks passed. Complete application, ingestion, and monitoring checks manually."
