# Séance 3 – Matrice d'allocation : Recharge, paiement et maintenance (ZARROUKI)

Allocation fonctionnelle : chaque action des flux d'actions de la séance 2 est affectée au composant matériel, ou au module du serveur central, qui la réalise. Le code se trouve dans `vues/seance3_zarrouki_allocation.sysml`. Les composants proviennent de `vues/seance3_zarrouki.sysml`. « RA· » désigne un composant du sous-système Réservation et accès (`vues/seance3_cherif.sysml`), et « DG· » un équipement de Détection et guidage (`vues/seance3_akichouh.sysml`).

## demanderRecharge

| Action | gestionRecharge | robotsRecharge | reservesEnergie |
| --- | :---: | :---: | :---: |
| verifierCapaciteLigne | X |  |  |
| proposerAutreLigne | X |  |  |
| calculerPrixOption | X |  |  |
| afficherPrixOption | X |  |  |
| enregistrerOption | X |  |  |
| planifierIntervention | X |  |  |
| envoyerRobot |  | X |  |
| connecterRobot |  | X |  |
| alerterAgent | X |  |  |
| demarrerRecharge |  | X |  |
| afficherAvancement | X |  |  |
| notifierFinRecharge | X |  |  |
| couperRecharge |  |  | X |
| deconnecterRobot |  | X |  |
| ramenerRobotBase |  | X |  |
| rechargerRobot |  |  | X |
| enregistrerEnergieDelivree | X |  |  |

## payerEtSortir

| Action | DG·capteursPlaces | RA·barrieresPlace | RA·serveurReservation | RA·superviseur | DG·lecteursPlaques | RA·modulePaiement | RA·bornesSortie | RA·interphones | RA·barrieresSortie |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| detecterDepart | X |  |  |  |  |  |  |  |  |
| releverBarrierePlace |  | X |  |  |  |  |  |  |  |
| libererPlacePlan |  |  | X |  |  |  |  |  |  |
| mettreAJourOccupation |  |  |  | X |  |  |  |  |  |
| lirePlaqueSortie |  |  |  |  | X |  |  |  |  |
| identifierUsager |  |  |  | X |  |  |  |  |  |
| verifierDroitEmploye |  |  |  | X |  |  |  |  |  |
| calculerMontant |  |  | X |  |  |  |  |  |  |
| debiterApplication |  |  |  |  |  | X |  |  |  |
| envoyerRecu |  |  | X |  |  |  |  |  |  |
| signalerRefusDebit |  |  | X |  |  |  |  |  |  |
| lireTicketQR |  |  |  |  |  |  | X |  |  |
| verifierTicket |  |  |  | X |  |  |  |  |  |
| validerSortie |  |  |  | X |  |  |  |  |  |
| afficherMontantDu |  |  |  |  |  |  | X |  |  |
| encaisserBorne |  |  |  |  |  |  | X |  |  |
| editerRecu |  |  |  |  |  |  | X |  |  |
| mettreEnRelationInterphone |  |  |  |  |  |  |  | X |  |
| ouvrirBarriereSortie |  |  |  |  |  |  |  |  | X |
| enregistrerSortie |  |  |  | X |  |  |  |  |  |

## maintenirEquipements

| Action | gestionRecharge | RA·serveurReservation | terminalMaintenance | accesTrajetSecurise | DG·panneauxLumineux | journalMaintenance |
| --- | :---: | :---: | :---: | :---: | :---: | :---: |
| listerEquipementsADefaut |  |  | X |  |  |  |
| mettreHorsService |  |  | X |  |  |  |
| neutraliserPlaceOuCapacite | X | X |  |  |  |  |
| arreterRobotsLigne | X |  |  |  |  |  |
| autoriserAccesTrajet |  |  |  | X |  |  |
| signalerZoneIntervention |  |  |  |  | X |  |
| lancerTest |  |  | X |  |  |  |
| remettreEnService |  |  | X |  |  |  |
| mettreAJourPlanCapacite | X |  |  |  |  |  |
| enregistrerPanne |  |  |  |  |  | X |
| maintenirHorsService | X |  |  |  |  |  |
| enregistrerIntervention |  |  |  |  |  | X |
| actualiserListe |  |  | X |  |  |  |
| cloturerIntervention |  |  | X |  |  |  |

## Clés de lecture

Ces matrices affectent les 51 actions des trois flux : `demanderRecharge`, `payerEtSortir` et `maintenirEquipements`. Une croix signifie que l'action est réalisée par le composant de la colonne. Aucune action n'est restée sans allocation.

Une seule action est allouée à deux composants : `neutraliserPlaceOuCapacite`. Selon l'équipement en maintenance, elle neutralise une place sur le plan (serveur de réservation) ou réduit la capacité d'une ligne de recharge (gestion de la recharge). Toutes les autres actions sont allouées à un seul composant.

**Recharge.** Les déplacements, la connexion et la recharge du véhicule sont réalisés par les robots. La coupure et la recharge des robots à leur base sont réalisées par la réserve d'énergie. Les décisions (capacité, prix, planification, alertes, énergie enregistrée) sont prises par le module de gestion de la recharge du serveur central.

**Paiement et sortie.** Ce cas s'appuie sur les composants des deux autres sous-systèmes :
- les capteurs de places et le lecteur de plaques de Détection et guidage ;
- les barrières, la borne de sortie, le serveur de réservation et le module de paiement de Réservation et accès.

**Maintenance.** Les actions du technicien sont réalisées par le terminal de maintenance. L'accès au trajet des robots est réalisé par la grille d'accès sécurisée. La signalisation de la zone d'intervention est réalisée par les panneaux lumineux existants.
