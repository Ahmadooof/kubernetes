### Creating dashboard
We can apply this to create dashboard:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
```

For ingress we can apply:
```
kubectl apply -f kubernetes-ingress.yaml
```

First create ServiceAccount, and cluster binding by:
```
kubectl apply -f dashboard-adminuser.yaml

```
To create token:
```
kubectl -n kubernetes-dashboard create token admin-user
```

#### Note
To make dashboard works with HTTPS, we have added:
```
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
```
cluster-issuer is an issuer run on the entier cluster.
Also configure subdomain by the domain provider, both have same IP


### Official Links:
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#command-line-proxy

https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md



