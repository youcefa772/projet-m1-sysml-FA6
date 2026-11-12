# Séance 3 – Table des exigences et vérification (groupe)

Cette table regroupe les **46 exigences terminales** du modèle de la séance 1 (`parkingIntelligentV2::requirements`). Pour chacune, elle indique le composant qui la satisfait (`satisfy`) et la procédure de test qui la vérifie (`verify`), comme le demande le point 2.5 du sujet.

Elle s'appuie sur trois fichiers de modèle :
- `vues/seance3_groupe_verification.sysml` (groupe) : 34 exigences ;
- `vues/seance3_akichouh_verification.sysml` (AKICHOUH) : 5 exigences ;
- `seance3/verification.sysml` (AMROUCH) : 7 exigences.

| # | Exigence | Parent | Doc | Satisfaite par | Vérifiée par | Fichier |
|---|---|---|---|---|---|---|
| 1 | controleAcces | fonctionsBase | le système doit contrôler les entrées et sorties : lecture de plaque et ticket QR de visite à l'entrée, code QR de l'application au niveau 2, carte personnelle au niveau 3 | flexFlow.reservationAcces | TestControleAcces | groupe |
| 2 | mesureOccupation | fonctionsBase | le système doit détecter les places libres dans 98 % des cas, en 30 s | detectionGuidage.capteursPlaces | TestDetection | AKICHOUH |
| 3 | niveauEmployes | fonctionsBase | le système doit réserver le niveau 3 aux employés, exclu des réservations | flexFlow.reservationAcces.lecteursCarte | TestControleAcces | groupe |
| 4 | tarification | fonctionsBase | le système doit appliquer la tarification paramétrée par l'exploitant (référence : 15 min gratuites puis payant, même tarif aux niveaux 1 et 2) | flexFlow.serveurCentral.modulePaiement | TestTarificationPaiement | groupe |
| 5 | paiementUnique | fonctionsBase | l'usager doit payer en une fois stationnement et recharge : à la caisse, ou par débit automatique de l'application à la sortie du niveau 2 | flexFlow.serveurCentral.modulePaiement | TestTarificationPaiement | groupe |
| 6 | previsionAffluence | fonctionsConseil | le système doit prévoir l'occupation par zone sur 2 h, erreur ≤ 15 % | serveurCentral.modulePrevision | TestPrevision | AKICHOUH |
| 7 | calculTempsTotal | fonctionsConseil | le système doit estimer le temps trajet + recherche, erreur ≤ 20 % | flexFlow.serveurCentral.moduleRecommandation | TestConseilComplementaire | groupe |
| 8 | recommandationZone | fonctionsConseil | le système doit recommander zone et entrée, sans zone prévue à plus de 90 % | serveurCentral.moduleRecommandation | TestRecommandation | AKICHOUH |
| 9 | alerteSaturation | fonctionsConseil | le système doit alerter le gestionnaire 30 min avant une saturation | flexFlow.serveurCentral.modulePrevision | TestConseilComplementaire | groupe |
| 10 | reductionRecherche | fonctionsConseil | le système doit réduire de 25 % le temps moyen de recherche | detectionGuidage | MesureTempsRecherche | AKICHOUH |
| 11 | localisationVehicule | fonctionsConseil | le système doit afficher à la borne la place et le chemin piéton en 5 s, juste dans 99 % des cas | detectionGuidage.camerasZone | TestLocalisation | AKICHOUH |
| 12 | planTempsReel | fonctionsReservation | le système doit afficher sur le plan l'état de chaque place (libre, occupée, réservée, PMR, recharge possible), mis à jour en 3 s, exact dans 99 % des cas | flexFlow.serveurCentral.serveurReservation | TestPlanReservation | groupe |
| 13 | declarationPlaque | fonctionsReservation | le visiteur doit pouvoir déclarer et modifier à tout moment la plaque du véhicule utilisé | flexFlow.serveurCentral.serveurReservation | TestPlanReservation | groupe |
| 14 | accesNiveauReserve | fonctionsReservation | le système doit ouvrir l'accès au niveau 2 par le code QR de l'application en 10 s au plus | flexFlow.reservationAcces.controlesAccesNiveau2 | TestControleAcces | groupe |
| 15 | protectionPlace | fonctionsReservation | la barrière de place doit s'abaisser devant la plaque déclarée, lue correctement dans 98 % des cas, et se relever au départ | flexFlow.reservationAcces.barrieresPlace | TestProtectionPlace | groupe |
| 16 | modificationReservation | fonctionsReservation | le visiteur doit pouvoir changer de place, annuler, prévenir d'un retard ou prolonger sa réservation à distance | flexFlow.serveurCentral.serveurReservation | TestPlanReservation | groupe |
| 17 | liberationPlace | fonctionsReservation | le système doit libérer une place non honorée 30 min après l'heure prévue et débiter 5 € de frais de non-venue | flexFlow.serveurCentral.gestionDelais | TestProtectionPlace | groupe |
| 18 | fideliteReservation | fonctionsReservation | le système doit offrir 1 h de stationnement pour 10 réservations honorées | flexFlow.serveurCentral.compteFidelite | TestTarificationPaiement | groupe |
| 19 | guidagePieton | fonctionsReservation | l'application doit guider le visiteur à pied jusqu'à son véhicule | flexFlow.serveurCentral.serveurReservation | TestPlanReservation | groupe |
| 20 | acceptationCapacite | fonctionsRecharge | le système ne doit accepter l'option recharge que si les robots de la ligne peuvent la satisfaire, et proposer sinon une autre ligne | flexFlow.serveurCentral.gestionRecharge | TestRechargeRobot | groupe |
| 21 | energieDelivree | fonctionsRecharge | le robot doit délivrer au moins 20 kWh en 30 min au plus par véhicule | flexFlow.recharge.robotsRecharge | TestRechargeRobot | groupe |
| 22 | deplacementRobot | fonctionsRecharge | le robot doit rejoindre seul la place en 3 min au plus après l'abaissement de la barrière de place, par un trajet sécurisé isolé du public | flexFlow.recharge.robotsRecharge | TestRechargeRobot | groupe |
| 23 | connexionAutomatique | fonctionsRecharge | le robot doit se connecter sans intervention de l'usager dans 98 % des cas | flexFlow.recharge.robotsRecharge | TestRechargeRobot | groupe |
| 24 | reserveEnergie | fonctionsRecharge | chaque ligne de 50 places doit disposer d'une réserve d'au moins 200 kWh, rechargée aux heures creuses | flexFlow.recharge.reservesEnergie | EssaiEnergieSite | groupe |
| 25 | suiviRecharge | fonctionsRecharge | l'application doit afficher l'avancement de la recharge | flexFlow.serveurCentral.gestionRecharge | TestRechargeRobot | groupe |
| 26 | enregistrementDepot | fonctionsAchats | le système doit enregistrer un dépôt en 30 s, associé à la bonne commande dans 99 % des cas | shoppingAssist.tabletteBoutique | TestDepot | AMROUCH |
| 27 | regroupementCommandes | fonctionsAchats | le système doit regrouper au moins 3 boutiques, 95 % des commandes complètes au créneau | shoppingAssist.serveur.logicielRetrait | TestDepot | AMROUCH |
| 28 | notificationCommande | fonctionsAchats | le système doit prévenir le client en 1 min, statuts exacts à 98 % | shoppingAssist.serveur.moduleNotification | TestNotification | AMROUCH |
| 29 | remiseBonClient | fonctionsAchats | le système doit remettre 99,5 % des achats au bon client, identification en 15 s | shoppingAssist.consigneCasiers.lecteurCode | TestRetrait | AMROUCH |
| 30 | tracabiliteAchats | fonctionsAchats | le système doit journaliser 100 % des dépôts et retraits, incidents ≤ 1 % | shoppingAssist.serveur.journalRetraits | TestRetrait | AMROUCH |
| 31 | reutilisationExistant | interactionsMaterielles | le système doit réutiliser capteurs, panneaux et lecteurs de plaques existants | flexFlow.detectionGuidage | InspectionInteractions | groupe |
| 32 | notificationUsager | interactionsMaterielles | le système doit notifier par application, SMS ou écran ; l'application n'est obligatoire que pour réserver une place | shoppingAssist.serveur.moduleNotification | TestNotification | AMROUCH |
| 33 | bornesManuelles | interactionsMaterielles | le niveau 1 doit offrir des bornes de recharge à branchement manuel, sans réservation | flexFlow.recharge.bornesManuelles | InspectionInteractions | groupe |
| 34 | interphone | interactionsMaterielles | l'usager doit pouvoir joindre le poste d'exploitation par interphone | flexFlow.reservationAcces.interphones | InspectionInteractions | groupe |
| 35 | puissanceConstante | contraintes | le système doit desservir 20 % des places du niveau 2 sans augmenter la puissance de raccordement du site | flexFlow.recharge.reservesEnergie | EssaiEnergieSite | groupe |
| 36 | puissanceCharge | securiteElectrique | la charge doit rester ≤ 22 kVA par point ; une puissance supérieure (environ 44 kW) n'est admise que sur le trajet sécurisé des robots, après avis favorable de la commission de sécurité | flexFlow.recharge.accesTrajetSecurise | InspectionSecuriteIncendie | groupe |
| 37 | plafondCompartiment | securiteElectrique | au plus 20 points de charge et 150 kVA simultanés par compartiment | flexFlow.serveurCentral.gestionRecharge | EssaiEnergieSite | groupe |
| 38 | coupureIncendie | securiteElectrique | toutes les charges doivent pouvoir être coupées depuis le poste d'exploitation en cas d'incendie | flexFlow.posteSupervision | InspectionSecuriteIncendie | groupe |
| 39 | stockageEnergie | securiteElectrique | la réserve d'énergie doit être implantée dans un local technique séparé | flexFlow.recharge.reservesEnergie | InspectionSecuriteIncendie | groupe |
| 40 | securiteRobot | contraintes | le robot doit être conforme au règlement Machines (UE) 2023/1230 et à l'EN ISO 3691-4 (zone confinée par protecteurs fixes d'au moins 2,1 m) | flexFlow.recharge.accesTrajetSecurise | InspectionSecuriteRobot | groupe |
| 41 | prixRecharge | contraintes | le prix de l'option recharge doit être affiché avant confirmation (AFIR) | flexFlow.serveurCentral.gestionRecharge | TestTarificationPaiement | groupe |
| 42 | localisationProtegee | donneesPersonnelles | aucune localisation du véhicule ne doit être affichée sans identification valide | flexFlow.detectionGuidage.bornesClient | AuditDonneesPersonnelles | groupe |
| 43 | protectionPlaques | donneesPersonnelles | les plaques ne doivent jamais être stockées en clair (hachage) et être conservées un mois au plus après la sortie | flexFlow.serveurCentral.serveurReservation | AuditDonneesPersonnelles | groupe |
| 44 | accessibilite | contraintes | le système doit préserver au moins 2 % de places PMR de 3,30 m, ainsi que des bornes, un point de retrait et des cheminements accessibles | shoppingAssist.consigneCasiers | InspectionAccessibilite | AMROUCH |
| 45 | libreChoix | contraintes | l'usager doit pouvoir venir sans réservation, ignorer le conseil et retirer ses achats en boutique | — (vérifiée uniquement par test) | TestLibreChoix | groupe |
| 46 | modeDegrade | contraintes | le système doit rester utilisable en cas de panne ou de retard | flexFlow.detectionGuidage | TestModeDegrade | groupe |

## Clés de lecture

La table couvre toutes les exigences terminales, c'est-à-dire celles auxquelles aucune autre exigence n'est rattachée (TD5). Les 11 exigences de regroupement (`specificationsParking`, `fonctions`, `fonctionsBase`, `securiteElectrique`, `donneesPersonnelles`, etc.) n'ont pas à être satisfaites directement : elles le sont à travers leurs exigences terminales.

**45 exigences sur 46 sont satisfaites par un composant** de la vue générale `flexFlow`, et toutes sont vérifiées par au moins une procédure de test. Les composants proviennent de la vue générale du groupe ou des sous-systèmes d'AKICHOUH et d'AMROUCH.

L'exigence `libreChoix` est la seule à n'être satisfaite par aucun bloc. Elle décrit une liberté laissée à l'usager : venir sans réservation, ignorer le conseil, retirer ses achats en boutique. Elle ne peut donc qu'être vérifiée par une procédure de test, ce que le sujet admet explicitement (« satisfaites soit par des blocs, soit vérifiables par le biais de procédures de test »).

Les procédures de test reprennent les valeurs chiffrées des exigences. Elles sont de trois natures :
- **des essais sur le site pilote ou sur un banc** : chronométrages, taux de réussite, mesures d'énergie et de puissance ;
- **des inspections réglementaires** : sécurité incendie, sécurité du robot, accessibilité ;
- **des audits** : protection des données personnelles.

Deux exigences dépendent d'un organisme extérieur :
- `puissanceCharge` : la puissance supérieure à 22 kVA sur le trajet sécurisé suppose l'avis favorable de la commission de sécurité ;
- `securiteRobot` : le robot doit être déclaré conforme au règlement Machines.
Leur vérification passe donc par une inspection et non par un simple essai.
