pas
=========

Installs a headless PhenixID Authentication Server as a `systemd` service. The server forms a session cluster with other PAS instances if configured to do so.

Role Variables
--------------

``source``
This variable points out a local installation binary on the control machine. Example: ``{  type: "installer", local_path: "~/phxid_server_linux_x64_3_2_0.sh" }``

``pas_home``
Set this variable to use a custom install directory. Default: `/opt/phenixid/pas`

``java_cmd``
Set this variable to use a custom Java runtime. Default: `{{ pas_home }}/jre/bin/java`

``java_heap_size``
Set this variable to change the default Java heap size. Default: `2G`

``log4j2_config_file``
Set this variable to use a custom log4j2 configuration file. Default: `log4j2.xml`
 
``start_script_file``
Set this variable to use a custom start script file. Default: `start-PhenixID.sh`

``license_file``
This variable point out a local license file on the control machine. Required.

``license_password``
License file password. Required.

``encryption_key``
Configuration encryption key. Required.

``config_api_host``
Configuration API listening interface. Required. 

``config_api_port``
Configuration API listening port. Default: `9443`

``db_encryption_key``
Database encryption key. Required.

``db_client_password``
Database user password. Required.

``hazelcast_password``
Hazelcast cluster password. Required.

``hazelcast_interface``
Hazelcast cluster listening interface. Required.

``hazelcast_port``
Hazelcast cluster listening port. Default: 5701

``hazelcast_members``
A list of Hazelcast cluster members. Do not include this server. Required, but may be an empty list.
 
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