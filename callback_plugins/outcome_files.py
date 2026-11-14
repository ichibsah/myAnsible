from __future__ import annotations

import json
import os
from datetime import datetime, timezone

from ansible.plugins.callback import CallbackBase


DOCUMENTATION = r"""
name: outcome_files
type: aggregate
short_description: Write selected task outcomes to separate JSON Lines files
description:
  - Logs changed, ignored, failed, and skipped task results on the controller.
  - Results marked no_log are redacted.
"""


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = "aggregate"
    CALLBACK_NAME = "outcome_files"
    CALLBACK_NEEDS_ENABLED = True

    def __init__(self):
        super().__init__()
        self._log_directory = os.path.expanduser("~/log/ansible")
        self._play_name = ""

    def v2_playbook_on_play_start(self, play):
        self._play_name = play.get_name().strip()

    def v2_runner_on_ok(self, result):
        if result.is_changed():
            self._write_event("changed", result)

    def v2_runner_on_failed(self, result, ignore_errors=False):
        status = "ignored" if ignore_errors else "failed"
        self._write_event(status, result)

    def v2_runner_on_skipped(self, result):
        self._write_event("skipped", result)

    def v2_runner_on_unreachable(self, result):
        self._write_event("failed", result, status="unreachable")

    def _write_event(self, filename, result, status=None):
        task = result._task
        result_data = result._result or {}
        record = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "outcome": status or filename,
            "host": result._host.get_name(),
            "play": self._play_name,
            "task": task.get_name().strip(),
            "action": task.action,
            "task_path": task.get_path(),
        }

        if result_data.get("_ansible_no_log") or getattr(task, "no_log", False):
            record["message"] = "[redacted: no_log]"
        else:
            message = result_data.get("msg") or result_data.get("skip_reason")
            if message:
                record["message"] = str(message)

        os.makedirs(self._log_directory, mode=0o700, exist_ok=True)
        os.chmod(self._log_directory, 0o700)
        log_path = os.path.join(self._log_directory, f"{filename}.log")
        flags = os.O_WRONLY | os.O_APPEND | os.O_CREAT | getattr(os, "O_NOFOLLOW", 0)
        descriptor = os.open(log_path, flags, 0o600)
        with os.fdopen(descriptor, "a", encoding="utf-8") as log_file:
            os.fchmod(log_file.fileno(), 0o600)
            log_file.write(json.dumps(record, ensure_ascii=False) + "\n")
