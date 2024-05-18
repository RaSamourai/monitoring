# Objectives :
This project is meant to be able to monitor computers/servers, the easiest way.<br>

# Stack :
- Grafana Alloy :
  - configured for remote writing to Grafana cloud
  - configurer to scrape node exporter exposed metrics
- Node Exporter :
  - exposing metrics
- Prometheus :
  - configured for remote writing to Grafana cloud
  - disable by default

# Run it :
Use the following command to run the project :
```bash
docker compose up -d --remove-orphans
```
