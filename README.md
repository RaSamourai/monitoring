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
# GPU monitoring :

To monitor Nvidia GPU, use [this exporter](https://github.com/utkuozdemir/nvidia_gpu_exporter).<br>
Use [this dashboard](https://grafana.com/grafana/dashboards/14574-nvidia-gpu-metrics/).

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install nssm --global
scoop install git
scoop bucket add nvidia_gpu_exporter https://github.com/utkuozdemir/scoop_nvidia_gpu_exporter.git
scoop install nvidia_gpu_exporter/nvidia_gpu_exporter --global
New-NetFirewallRule -DisplayName "Nvidia GPU Exporter" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9835
nssm install nvidia_gpu_exporter "C:\ProgramData\scoop\apps\nvidia_gpu_exporter\current\nvidia_gpu_exporter.exe"
Start-Service nvidia_gpu_exporter
```

> Access via : http://localhost:9835/metrics

# Windows monitoring :

To monitor a Windows machine, use this [Windows exporter](https://github.com/prometheus-community/windows_exporter/releases).<br>
/!\ DOWNLOAD THE .MSI FILE NOT THE .EXE FILE /!\\<br>
<br>
Use [this dashboard](https://grafana.com/grafana/dashboards/15794-windows-exporter-dashboard/).<br>
<br>
Then use  this command in a cmd shell ran as administrator :
```shell
msiexec /i windows_exporter-0.16.0-amd64.msi ENABLED_COLLECTORS="ad,adfs,cache,cpu,cpu_info,cs,container,dfsr,dhcp,dns,fsrmquota,iis,logical_disk,logon,memory,msmq,mssql,netframework_clrexceptions,netframework_clrinterop,netframework_clrjit,netframework_clrloading,netframework_clrlocksandthreads,netframework_clrmemory,netframework_clrremoting,netframework_clrsecurity,net,os,process,remote_fx,service,tcp,time,vmware" TEXTFILE_DIR="C:\custom_metrics" LISTEN_PORT="9182"
```

> Access via : http://localhost:9182/metrics
