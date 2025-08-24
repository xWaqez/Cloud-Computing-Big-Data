# Aufgabe 3 – Microservice-Architektur (Kubernetes auf OpenStack)

Ziel: Multi-Node-Kubernetes via `kubeadm` auf OpenStack bereitstellen, App als Container deployen, extern via Ingress erreichbar machen und skalieren.

## Teil A – OpenStack-Cluster
- Terraform-Skelett: `openstack/` (Variablen in `variables.tf`, Ressourcendefinitionen in `main.tf`).
- Cloud-Init:
  - `cloud-init/master.yaml` initialisiert Control-Plane (containerd, kubeadm init, Flannel CNI).
  - `cloud-init/worker.yaml` installiert Runtime + kubeadm; beitreten via Join-Command.

**Ablauf (vereinfacht):**
1) `cd openstack && terraform init && terraform apply`
2) Per SSH auf Master: `cat /join.sh` → auf den Worker-VMs ausführen.
3) `kubectl get nodes` zeigt Master + Worker.

## Teil B – Private Registry (optional, empfohlen)
- Lokale Registry bereitstellen: `cd registry && docker compose up -d`
- App-Image bauen & pushen (z.B. von Entwicklerrechner):
  ```bash
  cd app
  docker build --build-arg APP_VERSION=v1 -t registry.local:5000/immutable-web:v1 .
  docker push registry.local:5000/immutable-web:v1
  ```
- K8s-Nodes müssen `registry.local` (oder IP) auflösen und erreichen.

## Teil C – App-Deployment & Skalierung
```bash
kubectl apply -f k8s/manifests/namespace.yaml
kubectl apply -f k8s/manifests/deployment.yaml
kubectl apply -f k8s/manifests/service.yaml
```
- Skalierung: `kubectl scale deploy/immutable-web -n immutable-app --replicas=3`

## Teil D – Ingress
- Ingress-Controller installieren:
  ```bash
  kubectl apply -f k8s/ingress-nginx/ingress-nginx.yaml
  ```
- Ingress-Resource anwenden:
  ```bash
  kubectl apply -f k8s/manifests/ingress.yaml
  ```
- Test: `curl http://<node-ip>:30080` (NodePort des Controllers) oder Hostname `immutable.local` via /etc/hosts.

## Versionierung im Cluster
- Neues Image `v2` bauen und pushen, dann Deployment aktualisieren:
  ```bash
  docker build --build-arg APP_VERSION=v2 -t registry.local:5000/immutable-web:v2 .
  docker push registry.local:5000/immutable-web:v2
  kubectl -n immutable-app set image deploy/immutable-web web=registry.local:5000/immutable-web:v2
  ```

## Hinweis
Die Manifeste sind minimal gehalten (Demo-Zweck). Für Produktion: RBAC härten, TLS aktivieren, Replikate für Controller, etc.
