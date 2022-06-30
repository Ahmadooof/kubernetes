## react website
Run ingress globally without loadbalancer.

## without DNS - Portforward
To run ingress globally without loadbalancer and without dns, you can apply 
kubectl describe ingress react
get the backend ip and put it in /etc/hosts file as:
backend-ip-of-nginx-controller      localhost

Then we can forward the port of ingress to the localhost because we do not have loadbalancer to expose our ingress port externally.
Creating cronjob after 3 minutes of reboot, to forward the port with kubectl. That will run in background.
crontab -e
@reboot sleep 180 && kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller --address 0.0.0.0 3333:80

note:3333 is optional port, while 80 is our ingress port.

Then we can forward port in router, interal "3333", external "80" preferable for http, or 443 for https.

### With DNS - Portforward
Same as previous but no need to edit /etc/hosts file. All we need is port forward run in background.

### Alternativley With DNS - Nginx-ingress-controller NodePort
When having the nginx controller as NodePort, then we can just forward 80,443 from outside(home router) to interal ips of 
nginx ingress controller.
check for ports by following:
``` 
kubectl get service/ingress-nginx-controller -n ingress-nginx
```

Note all ways not recommended in production, cause we are losing scaling feature from kubernetes..