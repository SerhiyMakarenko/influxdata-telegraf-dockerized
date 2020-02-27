# General
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/SerhiyMakarenko/influxdata-telegraf-dockerized/blob/influxdata-telegraf-dockerized/stable/LICENSE)

Telegraf is an open source agent written in Go for collecting metrics and data on the system it's running on or from other services. Telegraf writes data it collects to InfluxDB in the correct format.

This container provides the customized version of the official InfluxData Telegraf image. Customization is required to add missing functionality in the official image.

For ARM CPU I have add the following tools:
 - [vcgencmd](https://elinux.org/RPI_vcgencmd_usage).

For x86_64 CPU I have added the following tools:
 - [smartmontools](https://www.smartmontools.org/).


# Details
Currently, the image supports the following CPU architectures:
 - x86_64 (amd64);
 - armhf (arm32v6);
 - armel (arm32v5);
 - arm64 (arm64v8).

This means that the image can be used on regular PC's with Intel CPU as well as on single-board computers like Raspberry Pi with ARM CPU.

# Usage
Unfortunately, there is no way to get SATA/ATA drives access without `CAP_SYS_RAWIO` permissions, so the container should be run with privileged mode. To run container you need to execute command listed below:
```
docker run -d --name influxdata-telegraf-agent --net=host \
    -v /path/to/telegraf.conf:/etc/telegraf/telegraf.conf \
    --privileged \
    serhiymakarenko/influxdata-telegraf-agent:latest
```

# Related
- [Telegraf reference on Github](https://github.com/docker-library/docs/tree/master/telegraf);
- [smartctl running like other user different from root](https://www.smartmontools.org/ticket/61);
- [Why smartctl could not be run without root](https://medium.com/opsops/why-smartctl-could-not-be-run-without-root-7ea0583b1323).
