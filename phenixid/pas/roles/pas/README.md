pas
=========

Installs a headless PhenixID Authentication Server as a `systemd` service. The server forms a session cluster with other PAS instances if configured to do so.

Role Variables
--------------
 
Example Playbook
----------------

This example playbook will try to stop the service, apply the role, then start the service:

    - hosts: servers
      pre_tasks:
        - name: "Stop pas service"
          systemd:
            state: stopped
            name: pas
          become: yes
          ignore_errors: yes
      post_tasks:
        - name: "Start pas service"
          systemd:
            state: restarted
            daemon_reload: yes
            name: pas
          become: yes
      roles:
         - { role: phenixid.pas.pas }

License
-------

EPL-2.0

Author Information
------------------

https://document.phenixid.net/