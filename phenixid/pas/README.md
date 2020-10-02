# PhenixID Authentication Services

## Requirements

 - One **control machine** with 
 
    - `python3` 
   
   This machine will execute the Ansible playbooks.
 
 - One or more **target machines** with 
 
    - `python3` 
    - `systemd`
   
   These machines will be provisioned with a PAS installation and configured for various services. The service will be managed by `systemd`.
 
 - The target machines must allow incoming SSH traffic from the control machine
 
 - The target machines must allow incoming TCP traffic on port 9443 (the config API port) from the control machine
 
 - The target machines must allow incoming TCP traffic on port 5702 (Hazelcast session cluster) from all other target machines

## Set up Ansible 

The following steps are executed on the **control machine** only.

#### Create virtual environment

```
python3 -m venv env
source env/bin/activate
```

#### Upgrade pip and install dependencies
```
pip install --upgrade pip
pip install -r requirements.txt
```

#### Install roles
Install latest released version:
```
ansible-galaxy collection install phenixid.pas
```

Install development version from GitHub repo:
```
ansible-galaxy collection install -f git+https://github.com/phenixid/ansible-pas.git#phenixid/pas
```

Install development version from local git repo:
```
ansible-galaxy collection install -f git+file:///path/to/repo/.git#phenixid/pas
```

## PAS Services

### Signing Service

#### Preparations

The following steps are executed on the **control machine** only.
 
1. Fetch a PAS installer (e.g. `phxid_server_linux_x64_3_2_0.sh`) and a valid license.

1. Fetch or create SAML metadata files:
     - metadata for the Signing Service Provider 
     - metadata for the Identity Provider
     
     Put the files in the `files` directory. Example files are included.

1. Fetch or create certificates:
     - a certificate for JWT signing 
     - a PKCS12 certificate store for the internal Certificate Authority

     Put the certificates in the `files` directory. Example files are included.
     
1. Open the `hosts` file and add IP addresses or DNS names of all target machines to the group `[sign]`
     
1. Open the playbook `sign.yml` and ensure that the variables are correctly configured.

#### Run playbook

Ensure ssh connectivity:
```
ansible --inventory=hosts --user=<user> all -m ping
```

Run playbook to install PAS and configure for Signing Service:
```
ansible-playbook --user=<user> --inventory=hosts sign.yml
```

#### Verify installation of Signing Service

If there are problems, here are some steps to verify the installation.
Suggestion: install `jq` for convenient handling of json data on the command line.

 - On **target machines**:
    - Verify service is running: `sudo journalctl -f -u pas`
    - Check server logs in directory `/opt/phenixid/pas/logs`
    - Ensure that the Hazelcast cluster `phenixid-sessions` is set up between all the target machines by examining the logs
 
 - From the **control machine**: 
    - Check server configurations: `curl http://<ip-to-target-machine>:9443/config | jq '.'`
    - Verify that the Health Check is ok: `curl http://<ip-to-target-machine>:8444/pipes/phenix/health` (don't mind the error message for now, only the status code 200 is important)
    - Verify Service Provider Meta data: `curl http://<ip-to-target-machine>:80/pdf_sign/authenticate/pdf_sign_auth_01?getSPMeta`