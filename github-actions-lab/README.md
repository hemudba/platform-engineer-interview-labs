# GitHub Actions Lab

Create a CI workflow that validates infrastructure and deployment assets.

## Goal
Understand what belongs in CI before GitOps takes over.

## Files
- `.github/workflows/ci.yaml`

## Workflow Scope
Include checks such as:
- terraform fmt
- terraform validate
- helm lint
- optional manifest validation

## Commands
Use GitHub Actions UI plus local validation where possible.

## What I Must Be Able to Explain
- what CI should validate
- where GitHub Actions stops
- why artifacts and approvals matter
- how secrets should be handled
- how this differs from ArgoCD

## Deliverables
- readable workflow YAML
- comments on job structure
- notes on CI responsibilities

## Completion Check
- workflow syntax is clean
- steps are ordered logically
- I can explain CI vs GitOps without mixing responsibilities
