# Install RITA on Security Onion
## Intended for Standalone and Sensor nodes.
## NOTE: This is not an officially supported configuration, and there are NO GUARANTEES as to it's proper operation.

# Overview

From https://github.com/activecm/rita: 
> RITA is an open source framework for network traffic analysis.
>
> The framework ingests Zeek Logs in TSV format, and currently supports the following major features:
>
> Beaconing Detection: Search for signs of beaconing behavior in and out of your network
> DNS Tunneling Detection Search for signs of DNS based covert channels
> Blacklist Checking: Query blacklists to search for suspicious domains and hosts

This project automates the setup of RITA log import and `beacon`, `exploded-dns`, and `long-connections` analysis so that resultant log files can be easily consumed by Security Onion.

# Installation
```
git clone https://github.com/weslambert/securityonion-rita
cd securityonion-rita
sudo chmod +x ./install_rita && sudo ./install_rita
```

When installation is complete, RITA will run everyday at 1:01 AM and perform analysis of the past day's Zeek logs.

The following scripts are used in this project:

`so-rita-start|stop|restart` - Start|stop|restart MongoDB, and apply RITA config (RITA only runs at the scheduled cron interval).  
`so-rita-update` - Runs at a set interval in a cron job.  
`so-rita-import` - Is used in `so-rita-update`, and imports the last day's worth of Zeek logs into MongoDB/RITA.   
`so-rita-export` - Is used in `so-rita-update` and runs the `show-*` commands for `beacons`, `exploded-dns`, and `long-connections`, then writes the results to a log.   

To apply the RITA state manually across a single node, run:

`sudo salt-call state.apply rita saltenv=custom queue=True`

To apply the RITA state across all applicable nodes, run:

`sudo salt-call state.highstate saltenv=custom queue=True`


# Logs
By default, logs are written to:

`/nsm/rita/beacons.csv`   
`/nsm/rita/exploded-dns.csv`   
`/nsm/rita/long-connnections.csv`     

To have them picked up by Security Onion, set the following in the `global.sls` or minion pillar file:

```
rita:
  enabled: True
```

Then restart Filebeat on all applicable nodes.

# Configuration
The RITA config file is sourced from `/opt/custom/salt/rita/files/config.yaml` and copied to `/opt/so/conf/rita/` after it is rendered.
The RITA cron job and state information is contained in `/opt/custom/salt/rita/init.sls`.

# Database
The actual MongoDB data exists on disk at `/nsm/rita/db`
