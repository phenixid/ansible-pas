pas_ca
=========

Configures PhenixID Authentication Server for federated signing of PDF files.

Role Variables
--------------

``allowed_logout_target`` Required

``certificate_directory`` Required

``jwt_certificate`` Required

``subject_key_parameter`` Required

``signing_authenticators_url`` Default: `{{ signing_public_url }}/pdf_sign/authenticate`

``signing_authenticator_alias`` Default: `pdf_sign_auth_00`

``signing_authenticator_url`` Default: `{{ signing_authenticators_url }}/{{ signing_authenticator_alias }}`

``sp_authenticator_alias`` Default: `pdf_sign_auth_01`

``sp_acs_url`` Default: `{{ signing_authenticators_url }}/{{ sp_authenticator_alias }}`

``sp_acs_pipe_id`` Default: `signing_assertion_consumer`

``sp_success_url`` Default: `/pdf_sign/sign/api/sign`

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
        - pas_federated_signing

License
-------

EPL-2.0

Author Information
------------------

https://document.phenixid.net/