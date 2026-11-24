# Pre-Upgrade Checklist

## Planning
- [ ] Migration scope and target versions confirmed.
- [ ] Maintenance window approved.
- [ ] Stakeholders notified.
- [ ] Upgrade path verified against Elastic documentation.

## Elasticsearch
- [ ] Cluster health reviewed.
- [ ] Nodes responding and status recorded.
- [ ] Indices and shard allocation reviewed.
- [ ] Deprecation API reviewed.
- [ ] Disk capacity reviewed.
- [ ] Snapshot completed and restore requirements understood.
- [ ] Plugin inventory and compatibility reviewed.
- [ ] Configuration backup completed.

## Kibana
- [ ] Configuration backed up.
- [ ] Integrations and dashboards reviewed.
- [ ] Target-version compatibility confirmed.

## Logstash
- [ ] Configuration backed up.
- [ ] Pipeline configuration reviewed.
- [ ] Deprecated parameters identified.
- [ ] Pipeline validation completed.
- [ ] Plugin compatibility reviewed.

## Readiness
- [ ] Recovery procedure reviewed.
- [ ] Monitoring access confirmed.
- [ ] Upgrade execution steps reviewed.
- [ ] Proceed/stop decision recorded.
