# AWS CI/CD Pipeline - Jenkins, Terraform, Ansible, Docker

End-to-end delivery pipeline that provisions AWS infrastructure from scratch, builds a Java application on a dedicated build host, and deploys the resulting artifact as a Docker container on a separate staging host.

Built as a certification project for DevOps School (2023), later reworked to production practices: remote state, no hardcoded resource IDs, an isolated VPC and least-privilege security groups.

## What it does

1. `terraform apply` creates a VPC, subnet, internet gateway, security groups and two EC2 instances.
2. `terraform output -json` generates the Ansible inventory at runtime - no IPs are ever committed.
3. `ansible-playbook` runs two plays: the build host installs JDK and Maven, checks out the source and packages the war; the staging host installs Docker, receives the artifact, builds the image and runs the container.

The two hosts are deliberately separate. The build host never runs the application, and the staging host never has a JDK or a source tree on it. Only the artifact crosses between them.

## Design decisions

**Inventory is generated, not committed.** Instances are disposable and their addresses change on every run, so there is no static list of hosts anywhere in the repository.

**No hardcoded AMI, security group or subnet IDs.** The AMI is resolved through a data source filtered on Canonical's Ubuntu 22.04 LTS, so the pipeline keeps working when Amazon retires an image. Everything else is created by Terraform in the same apply.

**Remote state with locking.** State lives in S3 with a DynamoDB lock table, so concurrent Jenkins runs cannot corrupt it. Local state files are gitignored.

**SSH is not open to the world.** `ssh_ingress_cidr` has no default and a validation rule rejects `0.0.0.0/0`, so the pipeline refuses to run until the range is scoped, normally to the Jenkins agent.

**Credentials never touch the repository.** The SSH private key is injected by Jenkins through `withCredentials`; AWS access comes from the instance profile or the agent environment.

## Repository layout

| File | Purpose |
|---|---|
| `Jenkinsfile` | Pipeline: init, validate, plan, apply, inventory, deploy, smoke test |
| `main.tf` | Network, security groups, EC2 instances |
| `variables.tf` | Input variables and validation |
| `outputs.tf` | Instance addresses consumed by the inventory step |
| `backend.tf` | S3 remote state and DynamoDB locking |
| `ansible.cfg` | Ansible defaults for this project |
| `playbook.yml` | Build play and deploy play |
| `Dockerfile` | Tomcat base image with the war deployed as ROOT |
| `src/`, `pom.xml` | Sample Java web application |

## Prerequisites

- Terraform 1.5 or newer, Ansible 2.14 or newer
- An S3 bucket and a DynamoDB table with `LockID` as the partition key, for state
- An EC2 key pair
- A Jenkins credential of type *SSH Username with private key*, ID `ssh-file`

## Running it

Configure the backend once:

```bash
terraform init \
  -backend-config="bucket=<state-bucket>" \
  -backend-config="dynamodb_table=<lock-table>"
```

Locally, without Jenkins:

```bash
terraform apply -var="ssh_ingress_cidr=$(curl -s ifconfig.me)/32"
ansible-playbook -i inventory.ini playbook.yml --private-key ~/.ssh/<key>.pem
```

The application answers on port 8080 of the staging host. Tear down when finished, these are billable instances:

```bash
terraform destroy
```

## Known limitations

This is a teaching project, and it is worth being explicit about where it stops short of production:

- Single availability zone, no autoscaling group and no load balancer in front of the app.
- The staging host builds the image on itself rather than pulling a tagged image from ECR.
- Instances sit in a public subnet. A private subnet reached through SSM Session Manager would remove the SSH ingress rule entirely.

The natural next step is ECR plus an ALB with a target group health check, which also removes the artifact round-trip through the Jenkins workspace.
