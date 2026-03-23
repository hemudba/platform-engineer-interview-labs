# Argo CD and Argo Rollouts for GitOps: The Definitive Guide

This repository contains the code and materials for the **Argo CD** section of my **Argo CD & Argo Rollouts** course.

If you are looking for the **Argo Rollouts** materials, please check the [Argo Rollouts Repository](https://github.com/lm-academy/argo-rollouts-course).

### ➡️ Course link (with a big discount 🙂): [https://www.lauromueller.com/courses/argo-cd-rollouts](https://www.lauromueller.com/courses/argo-cd-rollouts)

### Check my other courses:

- 👉 [Prompt Engineering for Developers: The Definitive Guide](https://www.lauromueller.com/courses/prompt-engineering)
- 👉 [Python for DevOps: Mastering Real-World Automation](https://www.lauromueller.com/courses/python-devops)
- 👉 [The Complete Docker and Kubernetes Course: From Zero to Hero](https://www.lauromueller.com/courses/docker-kubernetes)
- 👉 [The Definitive Helm Course: From Beginner to Master](https://www.lauromueller.com/courses/definitive-helm-course)
- 👉 [Mastering Terraform: From Beginner to Expert](https://www.lauromueller.com/courses/mastering-terraform)
- 👉 [Mastering GitHub Actions: From Beginner to Expert](https://www.lauromueller.com/courses/mastering-github-actions)
- 👉 [Write better code: 20 code smells and how to get rid of them](https://www.lauromueller.com/courses/writing-clean-code)

## Welcome!

I'm thrilled to have you here! This repository contains all the code, examples, and supplementary materials for the GitOps portion of the course. My goal is to provide you with practical, real-world examples that will help you master Argo CD on Kubernetes.

### 🔗 Further Course Materials

- [Argo CD Example Apps](https://github.com/lm-academy/argocd-example-apps)
- [Argo CD Example Apps Labs](https://github.com/lm-academy/argocd-example-apps-labs)
- [Argo Rollouts Repository (Course Companion)](https://github.com/lm-academy/argo-rollouts-course)

## 🚀 Getting Started

To run the code examples, you'll need a Kubernetes cluster and some command-line tools installed.

### Prerequisites

1.  **Kubernetes Cluster**: You can use a local cluster like [Minikube](https://minikube.sigs.k8s.io/docs/start/), [Kind](https://kind.sigs.k8s.io/), or [Docker Desktop](https://docs.docker.com/desktop/kubernetes/).
2.  **kubectl**: The Kubernetes command-line tool. [Installation guide](https://kubernetes.io/docs/tasks/tools/).
3.  **Helm**: The package manager for Kubernetes. [Installation guide](https://helm.sh/docs/intro/install/).
4.  **Argo CD CLI**: Command-line interface for Argo CD. [Installation guide](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

### Repository Setup

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/lm-academy/argocd-code.git
    cd argocd-code
    ```

## 📚 Repository Structure

This repository covers the following topics:

- **installing-argocd**: Getting Started with Argo CD. Covers installing Argo CD via Helm and setting up the namespace.
- **access-argocd**: Accessing the Argo CD Web UI and CLI, including retrieving the initial admin password.
- **deploy-first-application**: Core Argo CD Concepts. Deploying your first "Guestbook" application and understanding the Application CRD.
- **sync-process**: Understanding the Sync Process, Configuration Drift, and Application Health status.
- **intro-helm-charts**: Working with Helm Charts. Learn how Argo CD integrates with Helm as a template engine.
- **public-helm-charts**: Deploying Public Helm Charts from external repositories.
- **setting-chart-values**: Customizing Helm Values & Precedence using `values.yaml` and parameters.
- **automated-sync-pruning**: Advanced Sync & Automation. Configuring automated syncing and pruning of orphaned resources.
- **self-healing**: Implementing Self-Healing to automatically correct configuration drift.
- **private-repo-https**: Access Management. Connecting to private Git repositories using HTTPS and Personal Access Tokens.
- **private-repo-ssh**: Access Management. Connecting to private Git repositories using SSH and Deploy Keys.
- **projects**: Organizing & Orchestrating Applications. Using Argo CD Projects for multi-tenancy and access control.
- **sync-phases-hooks**: Using Sync Phases and Hooks to run custom logic during the deployment lifecycle.
- **sync-waves**: Orchestrating complex deployments using Sync Waves to define precise deployment order.

I'm looking forward to seeing you in the course!
