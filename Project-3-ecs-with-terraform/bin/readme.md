## Install the python environment 
```sh 
 source venv/bin/deactivate  
```

## First, install the required dependency:
```sh
pip install deepdiff
```

## Basic comparison
```sh
python script.py terraform.tfstate.old terraform.tfstate
```

## With detailed changes
```sh
python script.py terraform.tfstate.old terraform.tfstate --detailed
```

**Example output:**
```sh
TERRAFORM STATE COMPARISON SUMMARY
====================================================

Total Resources Unchanged: 5
Total Changes Detected: 3

✓ ADDED (1):
  + aws_instance.new_server

✗ REMOVED (1):
  - aws_instance.old_server

⟳ MODIFIED (1):
  ~ aws_security_group.main
    values_changed: instances[0].attributes.instance_type
      Old: t3.micro
      New: t3.small
```
## Checking on cost on script
```sh 
python drift-detector.py terraform.tfstate.old terraform.tfstate --costs --tf-dir ../terraform-aws-ecs-architecture
```
## Checking on cost manually
```sh
infracost breakdown --path .  
```