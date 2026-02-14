# Architecture

This project creates the same AWS environment through either CloudFormation or Terraform.

## High-level diagram

```text
                          Internet
                              |
                       +--------------+
                       | Internet GW  |
                       +--------------+
                              |
+----------------------------------------------------------------+
| VPC: 10.0.0.0/16                                                |
|                                                                |
|  Public Subnet: 10.0.2.0/24 (AZ variable)                     |
|  +---------------------------+                                  |
|  | EC2 Public Instance       |                                  |
|  | - nginx user-data         |                                  |
|  | - public SG: allow 80/tcp |                                  |
|  +---------------------------+                                  |
|              |                                                  |
|              v                                                  |
|       +---------------+                                         |
|       | NAT Gateway   |                                         |
|       +---------------+                                         |
|              |                                                  |
|              v                                                  |
|  Private Subnet: 10.0.1.0/24 (AZ variable)                     |
|  +---------------------------+                                  |
|  | EC2 Private Instance      |                                  |
|  | - private SG: allow HTTP  |                                  |
|  |   + ICMP from public SG   |                                  |
|  +---------------------------+                                  |
|                                                                |
+----------------------------------------------------------------+
```

## Route flow

- Public subnet route table sends `0.0.0.0/0` to the Internet Gateway.
- Private subnet route table sends `0.0.0.0/0` to the NAT Gateway.
- Private instance can reach outbound internet through NAT.

## Access model

- Public instance serves HTTP (`80/tcp`) to the internet for demo verification.
- No SSH ingress rule is configured.
- Private instance is not directly internet-reachable.

## IAM model

Both EC2 instances use an instance profile with `AmazonSSMManagedInstanceCore`.
This enables Systems Manager connectivity and management without opening SSH.

## Why both IaC versions exist

- CloudFormation version demonstrates native AWS stack deployment.
- Terraform version demonstrates provider-agnostic IaC workflow with plan/apply/state.
- Architecture and resource intent are equivalent across both implementations.
