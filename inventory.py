#!/usr/bin/env python3

import os
import json

inventory = {
  "homelab": {
    "hosts": [os.environ.get("HOMELAB_IP")],
    "vars": {
			"ansible_port": os.environ.get("HOMELAB_PORT"),
      "ansible_user": os.environ.get("HOMELAB_USER"),
      "ansible_password": os.environ.get("HOMELAB_PASSWORD"),
      "ansible_python_interpreter": "/usr/bin/python",
      "ansible_become_user": os.environ.get("HOMELAB_BECOME_USER"),
      "ansible_become_password": os.environ.get("HOMELAB_BECOME_PASSWORD"),
		},
  },
  "_meta": {
    "hostvars": {},
  },
}

print(json.dumps(inventory))
