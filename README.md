# Deployment of Mediawiki using Kubernetes with Helm Charts

This automation is to deploy Mediawiki on Kubernetes cluster using Helm Charts.

## Step:1 Doker Image 

Created a custom docker Image to be used for Mediwiki deployment and pushed it to Docker hub registory. Refer below URL.
```
https://hub.docker.com/r/himanshu9193/mediawiki

```

## Step:2 Setup Kubernetes cluster on Azure/AWS/GCP or on local system

I have used minikube tool to run a Kubernetes cluster in a virtual machine on my personal computer. Refer below documentation for Kubernetes for setting up the same.
```
https://kubernetes.io/docs/tasks/tools/install-minikube/

```

## Step:3 Create helm chart for MediaWiki deployment

Created helm charts and packaged it for easy deployment.

## Step:4 Deploy charts to Kubernetes

- Download the helm package and deploy charts to Kubernetes cluster using below command
```
helm install mymediawiki ./mymediawiki-0.1.0.tgz --set service.type=NodePort
```
- Check status of deployment using below command
```
helm status mymediawiki
```
- Get node IP and port and to access the application
```
$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services mymediawiki)

$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")

http://Node_IP:Node_Port
```

## Step:5 Configure Mediawiki

- Follow the steps on the site to configure you first wiki. It will ask you for Database username and password. Provide below values.
  - username = admin
  - password = pass

- Configuration process will prompt you to download a "LocalSettings.php" that must be saved to the parent directory of the new wiki. In our case parent directory is "/var/www/html/"

- Copy the "LocalSettings.php" file to the container in Kubernetes cluster using below command
```
kubectl cp LocalSettings.php <pod-name>:/var/www/html/
```

- Access the URL to access you firt wiki.

## Step:6 Kubernetes Deployment Configuration

- Scaling Deployment
```
kubectl scale deployment mymediawiki --replicas=5
```

- Rolling Updates / BlueGreen Deployment
```
  - Update image

    kubectl set image deployment/mymediawiki mymediawiki=himanshu9193/mediawiki:v2

  - check rollout status

    kubectl rollout status deployment.apps/mymediawiki

  - Rollback updates

    kubectl rollout undo deployment.apps/mymediawiki
```
- Autoscaling deployment 
```
kubectl autoscale deployment mymediawiki --min=2 --max=5 --cpu-percent=80
```

