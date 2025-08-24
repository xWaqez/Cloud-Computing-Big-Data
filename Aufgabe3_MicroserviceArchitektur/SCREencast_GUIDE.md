# Screencast-Guide – Aufgabe 3 (max. ~4–6 Min.)

1) `kubectl get nodes` (Cluster bereit), `kubectl get pods -A` (System).
2) `kubectl apply -f k8s/manifests/*.yaml` → App v1 läuft; `curl` über Ingress (NodePort 30080).
3) Skalieren: `kubectl scale deploy/immutable-web -n immutable-app --replicas=3` + `kubectl get pods -n immutable-app`.
4) Versionierung: `kubectl -n immutable-app set image deploy/immutable-web web=registry.local:5000/immutable-web:v2` → Rolling Update.
5) Kurzer Wrap-up: Ingress, Skalierung, Rolling Updates.