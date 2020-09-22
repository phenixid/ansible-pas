pas_ca
=========

Configures PhenixID Authentication Server as a Certificate Authority.

Role Variables
--------------

``ca_certificate`` 
The certificate file.

``keystore_password``
The certificate file password.

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
        - pas_ca

License
-------

EPL-2.0

Author Information
------------------

https://document.phenixid.net/