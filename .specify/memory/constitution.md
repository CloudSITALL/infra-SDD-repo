# Infrastructure & Observability Constitution

## 1. Core IaC & Modularity Principles
- **Declarative Standard**: All cloud infrastructure MUST be provisioned using Terraform (`>= 1.9`).
- **Strict Modularity**: Environment directories (`terraform/environments/*`) MUST only instantiate modules from `terraform/modules/*`. No raw cloud resources directly in environment roots.
- **State Security**: Remote state backends MUST enforce encryption at rest and state locking.

## 2. Zero-Trust Security & SAST Mandates
- **Least Privilege**: IAM policies and roles MUST NOT contain wildcard actions (`*`) or wildcard resources (`*`).
- **Network Isolation**: Ingress from `0.0.0.0/0` is strictly forbidden except on HTTPS (`443`) via an approved load balancer/WAF.
- **Encryption Everywhere**: All storage buckets, managed disks, queues, and databases MUST enforce KMS/CMK encryption at rest and TLS 1.3 in transit.
- **Gate Compliance**: No task is complete until `terraform validate`, `checkov`, and `conftest` pass with zero MEDIUM, HIGH, or CRITICAL findings. Inline skip comments (`#checkov:skip`) are forbidden unless explicitly justified in `plan.md`.

## 3. Mandatory Observability-by-Spec
- **No Unmonitored Services**: Every infrastructure module or workload deployed in `terraform/` MUST have:
  1. An accompanying Sloth SLO specification in `observability/slos/<service>.slo.yaml`.
  2. A synthetic endpoint/health check in `observability/synthetic/endpoints.yaml`.
- **Mandatory Resource Tags**: Every taggable Terraform resource MUST include:
  - `Environment` (`dev` | `prod`)
  - `Service`
  - `ManagedBy` (`Terraform-SDD`)
  - `SecurityTier` (`public` | `internal` | `restricted`)
