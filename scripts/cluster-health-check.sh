#!/usr/bin/env bash
set -Eeuo pipefail

ES_URL="${ES_URL:-http://localhost:9200}"
ES_USER="${ES_USER:-elastic}"
: "${ES_PASSWORD:?Set ES_PASSWORD in the environment}"
CURL_OPTS=(--silent --show-error --fail)

echo "=================================="
echo " ELASTICSEARCH HEALTH CHECK"
echo "=================================="

curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cluster/health?pretty"
echo
echo "--- Nodes ---"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cat/nodes?v"
echo
echo "--- Indices ---"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_cat/indices?v"
echo
echo "--- Deprecations ---"
curl "${CURL_OPTS[@]}" -u "${ES_USER}:${ES_PASSWORD}"   "${ES_URL}/_migration/deprecations?pretty"
echo
echo "Checks queried successfully. Review output before proceeding."
