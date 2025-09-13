Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).


# url_monitor

Ansible role that creates a cron job to HTTP GET a URL every hour, log the result to a daily log file, and send a Microsoft Teams alert if the status code is not 200.

## Variables

| Variable | Default | Description |
|---|---|---|
| `url_monitor_target_url` | `https://example.com/health` | URL to check |
| `url_monitor_log_dir` | `/var/log/url-check` | Directory for daily logs (`YYYY-MM-DD.log`) |
| `url_monitor_script_path` | `/usr/local/bin/url_check.sh` | Wrapper script location |
| `url_monitor_env_file` | `/etc/url-check.env` | Root-only env file to store webhook |
| `url_monitor_cron_user` | `root` | Crontab owner |
| `url_monitor_http_timeout` | `30` | Curl timeout seconds |
| `url_monitor_enable_teams_alerts` | `true` | Enable Teams alerts |
| `url_monitor_webhook_url` | `""` | Teams Incoming Webhook URL (required if alerts enabled) |
| `url_monitor_cron_special_time` | `hourly` | Use `hourly`, `daily`, etc., or set `""` |
| `url_monitor_cron_minute` | `0` | Cron minute (used if `special_time` is empty) |
| `url_monitor_cron_hour` | `*` | Cron hour |
| `url_monitor_cron_day` | `*` | Cron day of month |
| `url_monitor_cron_month` | `*` | Cron month |
| `url_monitor_cron_weekday` | `*` | Cron weekday |
| `url_monitor_require_curl` | `true` | Install `curl` if missing |
| `url_monitor_enable_lock` | `false` | Use `flock` to avoid overlaps |
| `url_monitor_lock_file` | `/var/lock/url_check.lock` | Lock file path if locking enabled |

## Example Playbook

```yaml
- hosts: url-checkers
  become: true
  roles:
    - role: url_monitor
      vars:
        url_monitor_target_url: "https://your-service.example.com/health"
        url_monitor_enable_teams_alerts: true
        url_monitor_webhook_url: "https://<your-teams-webhook>"
