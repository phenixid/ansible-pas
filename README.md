# Signing Workflow (Linux)

**Signing Workflow** consists of two PhenixID products: the *Signing Workflow* server and the *PhenixID Authentication Server configured as a Signing Service*.
This collection contains roles for installing and managing both servers, on Linux hosts running `systemd`.

## Install Ansible 

Create a virtual Python environment

```
python3 -m venv /path/to/env 
source /path/to/env/bin/activate
```

Upgrade pip and install dependencies, using the file [requirements.txt](/examples/digo/requirements.txt):

```
pip install --upgrade pip
pip install -r requirements.txt
```

## Install Ansible role collections

Install required role collections, using the file [requirements.yml](/examples/digo/requirements.yml):

```
$ ansible-galaxy install -r requirements.yml --force
```

Make sure to change the version numbers in `requirements.yml` to match the Workflow Server version.

 | Workflow | Collection |
 |----------|------------|
 | 1.5.3    | 2.3.0      |

## Apply Ansible roles to hosts

Use the [example](/examples/digo) as a starting point. Edit the `hosts` and `vars.yml` files to match your environment

Install Signing Service:

```
ansible-playbook --inventory=hosts --user=<user> --private-key /path/to/key.pem  signing.yml
```

Install Signing Workflow:

```
ansible-playbook --inventory=hosts --user=<user> --private-key /path/to/key.pem  workflow.yml
```