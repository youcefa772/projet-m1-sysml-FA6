# Séance 3 – Matrice d'allocation : Réservation, accès et supervision (CHERIF)

Allocation fonctionnelle : chaque action des flux d'actions de la séance 2 est affectée au composant matériel, ou au module du serveur central, qui la réalise. Le code se trouve dans `vues/seance3_cherif_allocation.sysml`. Les composants proviennent de `vues/seance3_cherif.sysml`. La mention « DG· » désigne un équipement du sous-système Détection et guidage (`vues/seance3_akichouh.sysml`).

## reserverPlace

| Action | serveurReservation | barrieresPlace | gestionDelais | modulePaiement | compteFidelite |
| --- | :---: | :---: | :---: | :---: | :---: |
| afficherPlan | X |  |  |  |  |
| verifierDisponibilite | X |  |  |  |  |
| signalerPlaceIndisponible | X |  |  |  |  |
| afficherPlaqueDeclaree | X |  |  |  |  |
| enregistrerReservation | X |  |  |  |  |
| marquerPlaceReservee |  | X |  |  |  |
| envoyerConfirmation | X |  |  |  |  |
| afficherReservation | X |  |  |  |  |
| chargerReservationEnCours | X |  |  |  |  |
| prolongerMaintienPlace |  |  | X |  |  |
| confirmerAnnulation | X |  |  |  |  |
| debiterFraisNonVenue |  |  |  | X |  |
| libererPlace |  | X |  |  |  |
| crediterPointsFidelite |  |  |  |  | X |

## accederAuParking

| Action | serveurReservation | barrieresPlace | DG·lecteursPlaques | distributeursTickets | barrieresEntree | controlesAccesNiveau2 | interphones | lecteursCarte |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| lirePlaqueEntree |  |  | X |  |  |  |  |  |
| imprimerTicketQR |  |  |  | X |  |  |  |  |
| ouvrirBarriereEntree |  |  |  |  | X |  |  |  |
| demanderCodeQR |  |  |  |  |  | X |  |  |
| lireQRApplication |  |  |  |  |  | X |  |  |
| refuserAccesNiveau2 |  |  |  |  |  | X |  |  |
| ouvrirAccesNiveau2 |  |  |  |  |  | X |  |  |
| guiderVersPlace | X |  |  |  |  |  |  |  |
| lirePlaquePlace |  | X |  |  |  |  |  |  |
| maintenirBarriereLevee |  | X |  |  |  |  |  |  |
| abaisserBarrierePlace |  | X |  |  |  |  |  |  |
| signalerArrivee | X |  |  |  |  |  |  |  |
| mettreAJourPlan | X |  |  |  |  |  |  |  |
| proposerAssistance |  |  |  |  |  |  | X |  |
| demanderCarte |  |  |  |  |  |  |  | X |
| lireCartePersonnelle |  |  |  |  |  |  |  | X |
| refuserAccesNiveau3 |  |  |  |  |  |  |  | X |
| ouvrirAccesNiveau3 |  |  |  |  |  |  |  | X |

## superviserExploitation

| Action | interphones | superviseur | posteSupervision | journalIncidents |
| --- | :---: | :---: | :---: | :---: |
| collecterEtat |  | X |  |  |
| afficherTableauBord |  |  | X |  |
| afficherAlerteSaturation |  |  | X |  |
| afficherIncident |  |  | X |  |
| localiserIncident |  | X |  |  |
| mettreEnRelationInterphone | X |  |  |  |
| marquerIncidentPrisEnCompte |  |  | X |  |
| enregistrerTraitement |  |  |  | X |
| couperToutesCharges |  |  | X |  |
| confirmerCoupure |  |  | X |  |
| appliquerParametres |  | X |  |  |

## Clés de lecture

Ces matrices affectent les 43 actions des trois flux (`reserverPlace`, `accederAuParking` et `superviserExploitation`). Une croix signifie que l'action est réalisée par le composant de la colonne. Chaque action est allouée à un seul composant, et aucune n'est restée sans allocation.

Les actions se répartissent selon leur nature :
- **les lectures, ouvertures et commandes physiques** sont réalisées par les équipements du sous-système `reservationAcces` : distributeurs, barrières, contrôles d'accès, lecteurs de carte, interphones ;
- **la lecture de plaque à l'entrée** est réalisée par le lecteur de plaques du sous-système Détection et guidage, ce qui évite de dupliquer l'équipement ;
- **les traitements** (vérification, enregistrement, délais, fidélité, paiement, journal) sont réalisés par les modules du serveur central ;
- **les affichages destinés à l'agent** sont réalisés par le poste de supervision.

Les actions affichées dans l'application des visiteurs (plan, plaque, réservation, guidage) sont allouées au serveur de réservation, qui produit ces informations. Le téléphone, sur lequel elles s'affichent, est un élément extérieur du contexte et ne fait pas partie de la décomposition matérielle.
