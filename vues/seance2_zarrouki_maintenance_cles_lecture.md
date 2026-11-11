# Séance 2 – ZARROUKI Ahmed – cas d'utilisation « maintenirEquipements »

Modèle : `vues/seance2_zarrouki_maintenance.sysml` (package `seance2ZarroukiMaintenance`)

## 2.1 Flux d'actions – clés de lecture

La vue décrit, du point de vue du système, une intervention de maintenance. Elle peut être périodique, hors des heures de pointe, ou faire suite à une alerte de la supervision.

**Ouverture.** Le système affiche les équipements en défaut ou à contrôler. Il les repère notamment en comparant capteurs et caméras, selon la redondance A/B d'AKICHOUH–AMROUCH.

**Mise hors service.** Pour l'équipement choisi, le système le met hors service, puis neutralise la place sur le plan ou réduit la capacité de la ligne (`planTempsReel`). Selon l'équipement (`decide0`) :
- **robot** : le système arrête les robots de la ligne avant d'autoriser l'accès au trajet sécurisé. Ce trajet est une zone confinée réservée au personnel autorisé (`securiteRobot`, EN ISO 3691-4) ;
- **équipement fixe** : le système signale la zone d'intervention aux usagers.

**Test.** Le système lance le test (`decide1`) :
- si le test réussit, il remet l'équipement en service et met à jour le plan ou la capacité ;
- s'il échoue, il enregistre la panne et maintient l'équipement hors service. Le parking reste alors utilisable en mode dégradé (`modeDegrade`).

**Clôture.** Le système enregistre l'intervention. S'il reste un autre équipement à traiter, il actualise la liste et revient au choix (`merge0`). Sinon, il clôture l'intervention.

## Scénarios de cas d'utilisation

| Scénario | Chemin dans le flux |
|---|---|
| S1 – Capteur remis en service | liste → hors service → zone signalée → test réussi → remise en service → intervention enregistrée → clôture |
| S2 – Robot remis en service | liste → hors service → robots arrêtés → accès au trajet autorisé → test réussi → remise en service → clôture |
| S3 – Test échoué | … test échoué → panne enregistrée → maintien hors service → clôture |
| S4 – Plusieurs équipements | … intervention enregistrée → liste actualisée → nouvel équipement → … |

## 2.2 Vues des séquences – clés de lecture

Seuls S2 et S3 sont tracés : S1 et S4 n'utilisent aucun composant supplémentaire. La première ligne de vie est le **terminal de maintenance** du technicien.

**S2 – Robot** (`maintenirEquipementsS2`)
1. Le **superviseur** fournit la liste des défauts.
2. La **gestion de la recharge** réduit la capacité de la ligne, arrête les **robots** et déverrouille l'**accès au trajet sécurisé**.
3. Après un test réussi, le robot est remis en service et la capacité de la ligne est rétablie.
4. L'intervention est enregistrée dans le **journal de maintenance**.

**S3 – Test échoué sur un capteur** (`maintenirEquipementsS3`)
1. Le **serveur de réservation** neutralise la place sur le plan.
2. Le test du **capteur de place** échoue.
3. La panne est enregistrée dans le journal de maintenance.

**Composants découverts**
- TerminalMaintenance, AccesTrajetSecurise et JournalMaintenance ;
- les données ListeEquipements, Equipement, ResultatTest et Intervention.

Ils sont déclarés dans `seance2ZarroukiMaintenance::composants`.
