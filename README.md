# Deploying a web app to Kubernetes with SSL using Let's Encrypt via cert-manager and nginx-ingress

### Deploy nginx-ingress
```sh
helm install stable/nginx-ingress --namespace kube-system --name ingress --set rbac.create=true
```


### Deploy cert-manager

###### Download from: https://github.com/jetstack/cert-manager/releases/tag/v0.15.2
Get the latest version if needed in the future
- CRD
- Cert-manager deployment
```sh
kubectl apply -f cert-manager-deployment/cert-manager.crds.yaml
kubectl apply -f cert-manager-deployment/cert-manager.yaml
```

### Deploy Application with ingress resources
```sh
kubectl apply -f application/app-deployment.yaml
kubectl apply -f application/cert-issuers.yaml
```

### Register free domain app.baohuyh.tk
Visit below website and point app.baohuynh.tk -> LoadBalance IP in GKE
```sh
https://my.freenom.com/clientarea.php?action=domaindetails&id=1095616933
```

### Checking Flow for cert-manager
- ###### Create ClusterIssuer / Issuer (CRD from cert-manager)
  
  Act as bridge between ACME server <--> client in the process of getting SSL certificate
   ```sh
   apiVersion: cert-manager.io/v1alpha2
   kind: ClusterIssuer
   metadata:
     name: letsencrypt-prod
   spec:
     acme:
       server: https://acme-v02.api.letsencrypt.org/directory
       email: huynhthaibao07@gmail.com
       privateKeySecretRef:
         name: letsencrypt-prod
       #http01: {}
       solvers:
       - http01:
           ingress:
             class: nginx
   ```   
- "Cluster-issuer" then generate "certificate", which indicate the status of getting SSL cert from letsencrypt server
  NOTE: if real SSL is stored in secret "foobar" (describe the cerificate to get the Message)
- ###### "Ingress" consume the SSL cert for domain (store in secret foobar)

  ```sh
  ...................
    tls:
  - hosts:
    - app.baohuynh.tk
    secretName: foobar
  ```


### Reference
- https://gist.github.com/snormore/c7c2935d746531ed0d75064a6ad6058e
- https://itnext.io/automated-tls-with-cert-manager-and-letsencrypt-for-kubernetes-7daaa5e0cae4
