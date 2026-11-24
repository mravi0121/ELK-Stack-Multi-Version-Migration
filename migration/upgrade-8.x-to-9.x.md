# Elasticsearch 8.19.0 to 9.4.2 Migration

## Objective
Upgrade Elasticsearch, Kibana, and Logstash from 8.19.0 to the planned 9.4.2 version.

## 1. Pre-Upgrade Requirements
- Verify cluster health, node status, and index health.
- Review deprecation warnings and compatibility requirements.
- Confirm snapshots and recovery requirements.
- Back up configuration files.
- Verify disk capacity and plugin compatibility.

Set credentials:
```bash
export ES_USER="elastic"
export ES_PASSWORD="your_password"
export ES_URL="http://localhost:9200"
```

## 2. Verify Cluster Health
```bash
curl -u "$ES_USER:$ES_PASSWORD" "$ES_URL/_cluster/health?pretty"
curl -u "$ES_USER:$ES_PASSWORD" "$ES_URL/_cat/nodes?v"
curl -u "$ES_USER:$ES_PASSWORD" "$ES_URL/_cat/indices?v"
curl -u "$ES_USER:$ES_PASSWORD" "$ES_URL/_migration/deprecations?pretty"
```

## 3. Back Up Configuration Files
```bash
sudo mkdir -p /backup/elk-configs/elasticsearch
sudo cp -a /etc/elasticsearch/. /backup/elk-configs/elasticsearch/

sudo mkdir -p /backup/elk-configs/kibana
sudo cp -a /etc/kibana/. /backup/elk-configs/kibana/

sudo mkdir -p /backup/elk-configs/logstash
sudo cp -a /etc/logstash/. /backup/elk-configs/logstash/
```

Verify the backup.

## 4. Prepare Elasticsearch
Review the cluster-specific procedure before changing allocation settings. Commands from the migration notes:

```bash
curl -u "$ES_USER:$ES_PASSWORD" -X PUT "$ES_URL/_cluster/settings" \
-H "Content-Type: application/json" \
-d '{"persistent":{"cluster.routing.allocation.enable":"primaries"}}'

curl -u "$ES_USER:$ES_PASSWORD" -X POST "$ES_URL/_flush?pretty"
```

## 5. Update Elasticsearch Repository
Edit:
```bash
sudo vi /etc/yum.repos.d/elasticsearch.repo
```

Repository configuration:
```ini
[elasticsearch-9.x]
name=Elasticsearch repository for 9.x packages
baseurl=https://artifacts.elastic.co/packages/9.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

## 6. Upgrade Elasticsearch
Review the approved upgrade sequence for your topology. Package commands from the migration notes:

```bash
sudo systemctl stop elasticsearch
sudo yum install elasticsearch-9.4.2
sudo systemctl daemon-reload
```

## 7. Review Elasticsearch Configuration
Edit:
```bash
sudo vi /etc/elasticsearch/elasticsearch.yml
```

Review node roles:
```yaml
node.roles: [ master, data, ingest ]
```

Review `cluster.initial_master_nodes`, discovery, network, and other settings for the target version. Remove initialization settings only where appropriate after successful cluster formation, following Elastic guidance.

## 8. Review S3 Plugin
```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin list
```

If required:
```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin remove repository-s3
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install repository-s3
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin list
```

Review plugin compatibility before installation.

## 9. Start Elasticsearch and Validate
```bash
sudo systemctl start elasticsearch
sudo systemctl status elasticsearch

curl -u "$ES_USER:$ES_PASSWORD" "$ES_URL/"
curl -u "$ES_USER:$ES_PASSWORD" "$ES_URL/_cluster/health?pretty"
```

## 10. Re-enable Shard Allocation
After reviewing cluster readiness:
```bash
curl -u "$ES_USER:$ES_PASSWORD" -X PUT "$ES_URL/_cluster/settings" \
-H "Content-Type: application/json" \
-d '{"persistent":{"cluster.routing.allocation.enable":null}}'
```

## 11. Upgrade Kibana
```bash
sudo systemctl stop kibana
sudo yum install kibana-9.4.2
sudo systemctl start kibana
sudo systemctl status kibana
```
Verify Kibana access and Elasticsearch connectivity.

## 12. Upgrade Logstash
```bash
sudo systemctl status logstash
sudo systemctl stop logstash
sudo yum install logstash-9.4.2
```

Review pipeline files and remove deprecated `document_type` parameters from Elasticsearch output configurations, if present.

## 13. Validate Logstash Configuration
```bash
sudo /usr/share/logstash/bin/logstash --config.test_and_exit -f /etc/logstash/conf.d/
```

## 14. Start Logstash
```bash
sudo systemctl start logstash
sudo systemctl status logstash
```

## 15. Post-Upgrade Checks
- Review Elasticsearch health, nodes, and indices.
- Verify Kibana service and UI.
- Verify Logstash service and pipelines.
- Verify data ingestion and application integrations.
- Review logs and monitoring.

## Safety Note
These commands are a documented procedure, not a universal rolling-upgrade runbook. Review topology, compatibility, snapshots, official upgrade requirements, and maintenance sequencing before executing.
