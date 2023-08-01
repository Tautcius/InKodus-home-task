# isntructions for further steps

Use assume role in provider values 

```bash
role = <output_role_arn>
```


Edit your AWS config file in ~/.aws/config by adding
```bash
[profile <Source_profile_name>-cluster]
region = eu-north-1
source_profile = <Source_profile_name>
role_arn = <output_role_arn>
```

and update kubeconfig file

```bash
aws eks update-kubeconfig \
--name <clustern_name> \
--profile <Source_profile_name>-cluster \
--region eu-north-1
```