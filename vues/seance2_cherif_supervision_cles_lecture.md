# Séance 2 – CHERIF Ayman – cas d'utilisation « superviserExploitation »

Modèle : `vues/seance2_cherif_supervision.sysml` (package `seance2CherifSupervision`)

## 2.1 Flux d'actions – clés de lecture

La vue décrit, du point de vue du système, la supervision du parking depuis le poste d'exploitation. Le cas commence quand l'agent ouvre sa session (`sessionOuverte`). Le système collecte alors l'état du parking et affiche le tableau de bord, commun aux deux binômes :
- l'occupation par niveau et par zone ;
- les réservations à venir ;
- l'état des robots et la puissance consommée ;
- les dépôts et retraits de Shopping Assist ;
- les incidents.

Le système réagit ensuite à cinq événements (`decide0`) :
- **Alerte de saturation.** Une zone est prévue au-delà de 90 % dans 30 minutes : le système affiche l'alerte (`alerteSaturation`).
- **Incident.** Le système affiche l'incident et le localise. Il met l'agent en relation par l'interphone si un usager appelle (`interphone`), ou marque l'incident comme pris en compte. Dans les deux cas, il enregistre le traitement.
- **Alarme incendie.** Le système coupe toutes les charges depuis le poste et confirme la coupure (`coupureIncendie`).
- **Modification de paramètres.** Le système applique les nouveaux réglages, comme la tarification ou les quotas de conseil (`tarification`).
- **Fin de session.** Le cas se termine.

Après chaque événement, à l'exception de la fin de session, le flux revient au point de convergence `merge0` : le système collecte de nouveau l'état et met à jour le tableau de bord. C'est la boucle de supervision.

## Scénarios de cas d'utilisation

| Scénario | Chemin dans le flux |
|---|---|
| S1 – Alerte de saturation | tableau de bord → alerte affichée → tableau de bord |
| S2 – Incident traité par interphone | tableau de bord → incident affiché et localisé → interphone → traitement enregistré → tableau de bord |
| S3 – Alarme incendie | tableau de bord → charges coupées → coupure confirmée → tableau de bord |
| S4 – Modification de la tarification | tableau de bord → paramètres appliqués → tableau de bord |
| S5 – Fin de session | tableau de bord → fin |

## 2.2 Vues des séquences – clés de lecture

Seuls S2 et S3 sont tracés : S1, S4 et S5 n'utilisent aucun composant supplémentaire. La première ligne de vie est le **poste de supervision**, sur lequel agit l'agent.

**S2 – Incident** (`superviserExploitationS2`)
1. Le poste demande le tableau de bord au **superviseur**, qui collecte l'état des places auprès du **serveur de réservation**.
2. La **gestion de la recharge** signale une alerte au poste, par exemple un échec de connexion d'un robot.
3. L'agent est mis en relation par l'**interphone**.
4. Le traitement est enregistré dans le **journal des incidents**.

**S3 – Alarme incendie** (`superviserExploitationS3`)
1. Le poste transmet l'alarme à la gestion de la recharge, qui coupe la **réserve d'énergie**.
2. Le poste coupe aussi les **bornes de recharge manuelles** du niveau 1.

Ce scénario est cohérent avec le scénario S5 de `demanderRecharge`.

**Composants découverts** :
- JournalIncidents et BorneRechargeManuelle ;
- les données TableauBord et Incident.

Ils sont déclarés dans `seance2CherifSupervision::composants`.
