# Objectives :
This project is meant to be able to monitor computers/servers, the easiest way.

# Requirements :
Docker engine & compose must be installed.

# Stack :
- Grafana Alloy :
  - configured for remote writing to Grafana cloud
  - configured to scrape node exporter exposed metrics
- Node Exporter :
  - exposing metrics
- Prometheus :
  - configured for remote writing to Grafana cloud
  - disabled by default

# Run it :
Use the following command to run the project :
```bash
docker compose up -d --remove-orphans
```
