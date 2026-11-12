# Séance 3 – Vue d'interconnexion du système complet (groupe)

Modèle : `vues/seance3_groupe_interconnexion.sysml` (package `interconnexionFlexFlow`)

## Vue d'interconnexion (IV) – clés de lecture

Cette vue complète la vue générale hiérarchique : elle montre comment les sous-systèmes de **ParkSys FlexFlow** sont reliés entre eux et avec les éléments extérieurs du contexte de la séance 1. Chaque sous-système y est un bloc, avec un port par famille d'échanges identifiée dans les séquences de la séance 2. Le détail des composants et de leurs ports est donné dans les vues d'interconnexion de chaque sous-système.

**Une architecture en étoile autour du serveur central.** Les cinq blocs techniques échangent tous avec le serveur central, qui héberge les modules logiciels communs :

| Connexion | Échanges portés (séquences de la séance 2) |
|---|---|
| `detectionGuidage.detection` ↔ `serveurCentral.detection` | occupation des places, plaques lues, localisation, affichage des panneaux et des bornes client |
| `reservationAcces.acces` ↔ `serveurCentral.acces` | tickets et codes QR, cartes des employés, commandes des barrières, plaques attendues, paiement à la borne |
| `recharge.commande` ↔ `serveurCentral.recharge` | missions et état des robots, réserve d'énergie, coupure des charges, accès au trajet sécurisé |
| `posteSupervision.supervision` ↔ `serveurCentral.supervision` | tableau de bord, alertes, incidents, paramètres de tarification |
| `terminalMaintenance.maintenance` ↔ `serveurCentral.maintenance` | liste des défauts, mise hors service, tests, remise en service |

**Deux exceptions justifiées.**
- Les **interphones** du sous-système Réservation sont reliés directement au poste de supervision (`audio`) : la conversation avec l'agent ne passe pas par le serveur (`accederAuParkingS3`, `payerEtSortirS7`).
- **Shopping Assist** dispose de son propre serveur, comme l'a modélisé AMROUCH : il n'est pas relié au serveur central et envoie directement le code de retrait au téléphone du client (`sms`).

**Liaisons avec les éléments extérieurs du contexte.**
- le téléphone des visiteurs échange avec le serveur central par l'application (réservation, recharge, paiement) ;
- le serveur central échange avec le système de paiement extérieur (`prestatairePaiement`) ;
- le réseau électrique alimente le sous-système de recharge, qui délivre l'énergie au véhicule électrique ;
- le système de sécurité incendie transmet l'alarme au poste de supervision, d'où l'agent coupe toutes les charges (`coupureIncendie`).

Les sens des ports reprennent ceux des messages : `out` pour un bloc qui émet seulement (alimentation, alarme, notification), `in` pour un bloc qui reçoit seulement, `inout` pour un échange dans les deux sens.
