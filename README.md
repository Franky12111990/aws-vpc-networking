# AWS VPC Networking

Hands-on AWS networking lab covering VPC design, public and private subnets, routing, Internet Gateway, NAT Gateway, Security Groups, EC2 networking, bastion hosts and SSH ProxyJump.

## Architecture

```text
VPC: 10.10.0.0/16

├── public-a     10.10.1.0/24
├── public-b     10.10.2.0/24
├── private-a    10.10.11.0/24
└── private-b    10.10.12.0/24
```

The VPC contains two public and two private subnets.

Public subnets are connected to the Internet through an Internet Gateway.

Private subnets do not have direct Internet access.

## Public Route Table

The public subnets use a route table with the following routes:

```text
10.10.0.0/16  -> local
0.0.0.0/0     -> Internet Gateway
```

Associated subnets:

```text
public-a
public-b
```

## Private Route Table

The private subnets use a separate route table.

Without a NAT Gateway:

```text
10.10.0.0/16  -> local
```

Associated subnets:

```text
private-a
private-b
```

This means that instances in private subnets can communicate with resources inside the VPC but cannot access the Internet directly.

## Public EC2 Instance

A public EC2 instance was deployed in:

```text
public-a
10.10.1.0/24
```

Configuration:

- Ubuntu Server
- Public IPv4 enabled
- Nginx installed
- SSH access restricted to administrator public IP
- HTTP port 80 available from the Internet

Security Group rules:

```text
SSH   TCP/22  -> Administrator public IP /32
HTTP  TCP/80  -> 0.0.0.0/0
```

Internet access was verified using:

```bash
curl -4 ifconfig.me
curl -I https://example.com
```

Nginx was verified from an external browser using the EC2 public IPv4 address.

## Private EC2 Instance

A private EC2 instance was deployed in:

```text
private-a
10.10.11.0/24
```

Configuration:

- No public IPv4 address
- SSH is not exposed directly to the Internet
- SSH access is allowed only from the Security Group of the public EC2 instance

Security Group rule:

```text
SSH TCP/22 -> Public EC2 Security Group
```

## Bastion Host and SSH ProxyJump

The public EC2 instance acts as a bastion host for accessing the private EC2 instance.

Example:

```bash
ssh -J ubuntu@BASTION_PUBLIC_IP ubuntu@PRIVATE_IP
```

SSH configuration can also be used:

```text
Host bastion
    HostName BASTION_PUBLIC_IP
    User ubuntu
    IdentityFile ~/.ssh/alex-devops-key.pem
    IdentitiesOnly yes

Host private-ec2
    HostName PRIVATE_IP
    User ubuntu
    IdentityFile ~/.ssh/alex-devops-key.pem
    IdentitiesOnly yes
    ProxyJump bastion
```

Then the private instance can be accessed with:

```bash
ssh private-ec2
```

The private SSH key is stored only on the local administration machine and is not copied to the bastion host.

## NAT Gateway Test

Initially, the private EC2 instance had no Internet access.

Test:

```bash
curl -4 --connect-timeout 5 ifconfig.me
```

Result:

```text
Connection timed out
```

A public NAT Gateway was then created in the `public-a` subnet with an Elastic IP address.

The private route table was temporarily updated to:

```text
10.10.0.0/16  -> local
0.0.0.0/0     -> NAT Gateway
```

After adding the NAT Gateway, outbound Internet access from the private EC2 instance worked successfully.

Verification:

```bash
curl -4 ifconfig.me
sudo apt update
curl -I https://example.com
```

The external IP returned by `curl -4 ifconfig.me` was the Elastic IP of the NAT Gateway.

The private EC2 instance still had no public IPv4 address and remained inaccessible directly from the Internet.

## Traffic Flow

Public EC2 Internet access:

```text
Public EC2
    |
    v
Public Route Table
    |
    v
Internet Gateway
    |
    v
Internet
```

Private EC2 Internet access through NAT:

```text
Private EC2
    |
    v
Private Route Table
    |
    v
NAT Gateway
    |
    v
Public Subnet
    |
    v
Internet Gateway
    |
    v
Internet
```

SSH access to the private EC2 instance:

```text
Administrator
    |
    | SSH
    v
Public EC2 / Bastion Host
    |
    | SSH
    v
Private EC2
```

## Key Concepts Practiced

- AWS VPC
- CIDR notation
- IPv4 private address ranges
- Public and private subnets
- Availability Zones
- Route tables
- Internet Gateway
- NAT Gateway
- Elastic IP
- EC2 networking
- Security Groups
- Security Group references
- Bastion hosts
- SSH ProxyJump
- Linux routing with `ip route`
- Public vs private IPv4 addresses
- Outbound vs inbound connectivity
- Network troubleshooting with `curl`
- SSH key permissions

## Security Notes

Private keys and credentials must never be committed to Git.

Recommended `.gitignore` entries:

```gitignore
*.pem
*.key
.env
.aws/
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
```

SSH private key permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/alex-devops-key.pem
chmod 600 ~/.ssh/config
```

## Next Steps

The next stage of this project is to recreate the infrastructure using Terraform.

Planned resources:

- VPC
- Public and private subnets
- Internet Gateway
- Public and private route tables
- Security Groups
- EC2 instances
- NAT Gateway
- Elastic IP
- Terraform variables and outputs

The goal is to move from manual AWS Console configuration to reproducible Infrastructure as Code.
