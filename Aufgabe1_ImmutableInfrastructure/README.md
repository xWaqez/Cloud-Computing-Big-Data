# Aufgabe 1 – Immutable Infrastructure

**Technologieauswahl:** Terraform (IaC) + Packer (Image-Build) + Docker (Laufzeit). Die App wird als *unveränderliches* Container-Image gebaut; Deployments ersetzen Container statt sie in-place zu verändern.

## Struktur
- `packer/` – Packer-Template (`webserver.pkr.hcl`) + Web-Content für `v1` und `v2`
- `terraform/` – Docker-Provider startet den Container aus dem Packer-Image
- `scripts/` – Hilfsskripte zum Bauen/Deployen/Updaten

## Quickstart
1) Voraussetzungen: Docker, Terraform, Packer installiert.
2) `scripts/build_and_deploy_v1.sh` ausführen → baut Image **local/immutable-web:v1** und startet Container auf Port 8080.
3) **Immutable Update** auf v2: `scripts/immutable_update_to_v2.sh` → neues Image wird gebaut; Terraform ersetzt den Container (Rebuild & Replace).
4) Aufräumen: `scripts/destroy.sh`

## Unveränderlichkeit
- Konfiguration und Web-Inhalt sind *Teil des Images* (keine Volumes).
- Updates erfolgen ausschließlich über Neubau (Packer) und Redeploy (Terraform).
- Die laufende Instanz wird nicht manuell verändert.
 