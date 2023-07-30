# InKodus-home-task

## Requirements:

1. Create new GitHub project ✅
2. Push any code from any language that you want (it can be hello world) ✅
3. Write multistage DockerFile (reduce docker image size) ✅
4. Write a helm chart for this service. ✅
5. Create ci pipeline (with any system that you preferred) ✅
    - main branch:
        - Manage versioning — bump patch version for each commit. ✅
        - Build and push the docker to any registry (Docker hub, ecr etc.) ✅
        - Update helm chart with the new docker ✅
    - PR (both are optional):
        - Build temporary docker and scan it with Trivy
        - Scan your helm with datree/Polaris
6. Install Argo-cd on k3s/minikube/microk8s/kind/eks etc. ✅
7. Install your helm with Argo-cd (it needs to be managed by git and not Argo-Ul, try app-of-app pattern) ✅
8. Push new commit and verify your CI-CD ✅
9. Install the following application with ApplicationSet : Polaris dashboard , goldilocks ✅

Bonus.
 - Be creative and share/implement something cool that you familiar with it

## Overview:

For CI and automation I used Github Actions, before this I used it only for side projects and not for clients, so it was a new expierence.

Most time took to debug official GH Actiions for Helm chart releases. since they have some bugs and not works as you expect. Personally I prefer Kustomize since it is easier to manage. Helm charts has some limitations and currently I starto looking and CUE language and [Timoni](https://github.com/stefanprodan/timoni)

As for apps creation and deployment I started learning about [Server Side Web Assembly](https://webassembly.org/) and [Spin](https://github.com/fermyon/spin). And I think this is next big thing.


As for ArgoCD part I use it in one porject together with kustomize. That is a perfect case for ApplicationSet from ArgoCD but at that moment when I created it I haven't heard about it.

Everything is deploeyd on my local cluster. I will demonstrate it during call.

