## TLS with nginx ingress
cert-manager is a powerful and extensible X.509 certificate controller for Kubernetes and OpenShift workloads. It will obtain certificates from a variety of Issuers, both popular public Issuers as well as private Issuers, and ensure the certificates are valid and up-to-date, and will attempt to renew certificates at a configured time before expiry.

### for installation:
https://cert-manager.io/docs/installation/#default-static-install

OR use:
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml
```
### for configration:
Follow the docs for adding TLS.
https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#issuers