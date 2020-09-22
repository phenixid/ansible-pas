pas_sp
=========

Configures PhenixID Authentication Server as SAML Service Provider.

Role Variables
--------------

``idp_id`` Required

``idp_metadata`` Required

``idp_sso_url`` Required

``sp_id`` Required

``sp_metadata`` Required

``sp_acs_url`` Required, provided by role `pas_federated_signing`

``sp_acs_pipe_id`` Required, provided by role `pas_federated_signing`

``sp_success_url`` Required, provided by role `pas_federated_signing`

Example Playbook
----------------

This example playbook will wait for the config API to become available, apply the role, then trigger a configuration reload on the target server:

    - hosts: servers
      pre_tasks:
        - name: "Waiting for config API to become available..."
          wait_for:
            host: "{{ config_api_host }}"
            port: "{{ config_api_port }}"
          delegate_to: 127.0.0.1
      post_tasks:
        - name: "Trigger STORE_UPDATED event"
          uri:
            method: POST
            url: "{{ config_api_url }}/state"
            body_format: json
          delegate_to: 127.0.0.1
      roles:
        - pas_idp

License
-------

EPL-2.0

Author Information
------------------

https://document.phenixid.net/