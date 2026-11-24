#!/usr/bin/env bash
set -Eeuo pipefail

BACKUP_ROOT="${BACKUP_ROOT:-/backup/elk-configs}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
DEST="${BACKUP_ROOT}/${TIMESTAMP}"

declare -A SOURCES=(
  [elasticsearch]="/etc/elasticsearch"
  [kibana]="/etc/kibana"
  [logstash]="/etc/logstash"
)

mkdir -p "$DEST"
echo "Starting configuration backup: $DEST"

for component in "${!SOURCES[@]}"; do
  source_dir="${SOURCES[$component]}"
  if [[ -d "$source_dir" ]]; then
    mkdir -p "$DEST/$component"
    cp -a "$source_dir/." "$DEST/$component/"
    echo "[OK] $component configuration backed up"
  else
    echo "[WARN] $source_dir not found; skipping $component"
  fi
done

if [[ -d "$DEST" ]] && find "$DEST" -mindepth 1 -print -quit | grep -q .; then
  echo "Backup completed. Location: $DEST"
else
  echo "Backup directory is empty; review the result." >&2
  exit 1
fi
