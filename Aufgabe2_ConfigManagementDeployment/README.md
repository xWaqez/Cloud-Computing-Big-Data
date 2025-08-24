# Aufgabe 2 – Configuration Management & Deployment

Ziel: Die Immutable-Infrastruktur aus Aufgabe 1 wird um Anwendungsinstallation, Versionierung und Rollback erweitert.
Die Anwendung wird in das Image integriert (Packer). Terraform steuert die Bereitstellung und den Versionswechsel.

## Versionierung der Anwendung
- Code-/Inhaltsversionen: `v1`, `v2` (siehe `packer/content/...`).
- Image-Tags spiegeln Versionsstände wider: `local/immutable-web:v1`, `:v2`.

## Infrastruktur-Versionierung & Rollback
- Infrastruktur-Code (Terraform) kann per Git versioniert werden (Tags/Branches).
- Rollback erfolgt durch Wechsel des Image-Tags und erneutes `terraform apply`.

## Befehle
- Deploy v1: `scripts/deploy.sh v1`
- Update auf v2: `scripts/deploy.sh v2`
- Rollback auf v1: `scripts/rollback.sh v1`

Alle Schritte sind vollständig automatisiert und reproduzierbar (keine manuelle Nachkonfiguration).
