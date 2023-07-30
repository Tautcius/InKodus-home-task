# InKodus-home-task

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