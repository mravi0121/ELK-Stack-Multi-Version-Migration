# Post-Upgrade Validation

Perform these checks after each migration stage, not only after the final upgrade.

## Elasticsearch
- [ ] Service is active.
- [ ] API responds successfully.
- [ ] Cluster health reviewed.
- [ ] Nodes and versions reviewed.
- [ ] Indices and shard allocation reviewed.
- [ ] Plugins verified.
- [ ] Logs reviewed for errors.

## Kibana
- [ ] Service is active.
- [ ] Web interface is accessible.
- [ ] Login and key dashboards verified.
- [ ] Elasticsearch connection confirmed.

## Logstash
- [ ] Service is active.
- [ ] Pipeline configuration validation passed.
- [ ] Pipelines are running.
- [ ] Input and output flow verified.
- [ ] Logs reviewed for errors.

## Application and Monitoring
- [ ] Data ingestion verified.
- [ ] Expected indices are receiving data.
- [ ] Applications using the stack are validated.
- [ ] Monitoring and alerts reviewed.

## Completion
- [ ] Validation results recorded.
- [ ] Stakeholders informed.
- [ ] Migration stage approved for completion.
