# Séance 1 – Description du produit et de son contexte (version 3, 11/11/2026)

Groupe : AMROUCH Youcef – AKICHOUH Mohamed – ZARROUKI Ahmed – CHERIF Ayman
Modèle associé : `ParkingIntelligentV2.sysml` (package `parkingIntelligentV2`)
Sources : dossiers MCI akichouh-amrouch V14 (AA) et cherif-zarrouki V6 (CZ), 05/11/2026.

## 1.1 Description brève du produit envisagé

ParkSys conçoit et commercialise des systèmes de stationnement pour les parkings couverts des grands centres commerciaux. Son produit actuel détecte l'occupation des places et l'affiche, contrôle les entrées et les sorties, réserve un niveau aux employés, calcule et encaisse le stationnement, et permet de superviser l'exploitation depuis un poste central. ParkSys veut maintenant le faire évoluer vers **ParkSys FlexFlow**. Ce nouveau produit accompagne l'usager de la préparation de sa venue jusqu'à son départ, et donne à l'exploitant des moyens d'anticipation.

FlexFlow reprend les fonctions de base et y ajoute quatre innovations, regroupées en modules activables séparément.

- **SmartFlow Predict** conseille une zone et une entrée. Ce conseil repose sur la prévision d'affluence à 2 h et sur le temps total estimé jusqu'à une place. Les recommandations sont réparties entre les zones pour ne pas en saturer une. Au retour, une borne affiche la place du véhicule et le chemin piéton, après lecture du QR code du ticket.
- **Shopping Assist** permet au client de déposer ses achats dans les boutiques partenaires. Les sacs sont regroupés dans un casier proche du parking, et le client les retire avec un code reçu par SMS.
- **La réservation de place « comme au cinéma »** se fait au niveau 2. Le visiteur choisit une place précise sur un plan mis à jour en temps réel. Il entre au niveau par le code QR de l'application, puis la barrière de place s'abaisse devant la plaque qu'il a déclarée. Une place non honorée est libérée 30 minutes après l'heure prévue.
- **La recharge apportée au véhicule** est une option de la réservation. Un robot rejoint la place par un trajet sécurisé isolé du public et se connecte seul. Il délivre au moins 20 kWh en 30 minutes, en puisant dans une réserve d'énergie propre à la ligne de places. La puissance de raccordement du site n'augmente pas.

Le parking est organisé en trois niveaux :

| Niveau | Usage | Équipements |
|---|---|---|
| 1 | Accès libre, conseillé par Predict | Bornes de recharge manuelles |
| 2 | Places réservées | Barrières de place et robots de recharge |
| 3 | Réservé aux employés | Accès par carte personnelle |

FlexFlow est utilisé par les conducteurs et les clients du centre, les employés des enseignes, le personnel des boutiques et du point de retrait, les agents d'exploitation et les techniciens. Il doit respecter la sécurité incendie des parcs couverts, la réglementation des machines mobiles, la protection des données personnelles et l'accessibilité des personnes à mobilité réduite.

## 1.2 Vue générale du contexte – clés de lecture

La vue (`part def Contexte`) place le système étudié, `parking : ParkingIntelligent`, au centre. Autour de lui figurent les éléments extérieurs qui ont une existence physique et qui sont en relation directe avec lui.

- **Les acteurs humains** : conducteurs, dont les conducteurs de véhicules électriques et les employés, clients du centre, personnel des boutiques et du point de retrait, exploitant et technicien.
- **Les éléments du milieu** : véhicules, téléphones et achats.
- **Les systèmes tiers** : système de paiement, réseau électrique et système de sécurité incendie.

Chaque flux porte un verbe, orienté de l'élément qui agit vers celui qui subit l'action :

- le conducteur *consulte*, *réserve* et *paie* ;
- le système *identifie* le véhicule, *recharge* le véhicule électrique et *regroupe* les achats ;
- la sécurité incendie *coupe les recharges*.

Les cardinalités indiquent qu'il y a un seul parking, un seul réseau électrique et un seul système de paiement, mais un nombre quelconque (`[*]`) de conducteurs, de véhicules et d'achats. L'application est considérée comme une partie du système. Le téléphone n'est que son support : il est donc extérieur et reçoit les notifications.

## 1.3 Vue générale des exigences – clés de lecture

Les exigences sont organisées hiérarchiquement par spécialisation (`specializes`), comme dans le corrigé du TD2. Sous `specificationsParking`, on trouve trois catégories :

- **`fonctions`** (exigences fonctionnelles) : base, conseil, réservation, recharge, achats ;
- **`interactionsMaterielles`** : notifications, bornes manuelles, interphone, réutilisation de l'existant ;
- **`contraintes`** : puissance constante, sécurité électrique (regroupant puissance de charge, plafond par compartiment, coupure incendie et stockage), sécurité du robot, prix de la recharge, données personnelles (regroupant localisation protégée et protection des plaques), accessibilité, libre choix, mode dégradé.

Les exigences de haut niveau sont formulées en termes généraux. Les exigences terminales sont chiffrées : ce sont les critères des AFT des deux dossiers. La colonne « Origine » du tableau ci-dessous assure la traçabilité vers chaque dossier : AA pour Akichouh–Amrouch, CZ pour Cherif–Zarrouki.

## 1.4 Vue des cas d'utilisation – clés de lecture

Dix cas d'utilisation de haut niveau, formulés verbe + complément, couvrent les attentes des acteurs.

| Cas d'utilisation | Acteurs | Origine |
|---|---|---|
| consulterConseilStationnement | conducteur | SmartFlow Predict (AA) |
| reserverPlace | conducteur | Réservation de place (CZ) |
| demanderRecharge | conducteurVE | Recharge par robot (CZ) |
| accederAuParking | conducteur | Base (AA + CZ) |
| deposerAchats | client, personnelBoutique, personnelRetrait | Shopping Assist (AA) |
| retirerAchats | client, personnelRetrait | Shopping Assist (AA) |
| retrouverVehicule | conducteur | Borne de retour (AA) + guidage piéton (CZ) |
| payerEtSortir | conducteur | Base |
| superviserExploitation | exploitant | Base |
| maintenirEquipements | technicien | Base |

La généralisation des acteurs (`::>`) se lit ainsi : `conducteurVE` et `employe` héritent des cas du `conducteur`, et `conducteur` et `client` spécialisent `usager`. Seul le conducteur de véhicule électrique peut donc demander une recharge. L'employé, lui, accède au niveau 3 avec sa carte.

## Tableau des exigences (vue en table)

| Exigence | Parent | Niveau | Fonctionnelle | Origine | Doc |
|---|---|---|---|---|---|
| specificationsParking | — | haut | — | groupe | le système répond aux catégories d'exigences ci-dessous |
| fonctions | specificationsParking | haut | oui | groupe | le système doit comprendre les fonctions ci-dessous |
| interactionsMaterielles | specificationsParking | haut | non | groupe | le système doit disposer des interactions matérielles ci-dessous |
| contraintes | specificationsParking | haut | non | groupe | le système doit respecter les contraintes ci-dessous |
| fonctionsBase | fonctions | haut | oui | groupe | le système doit assurer les fonctions du parking de référence |
| fonctionsConseil | fonctions | haut | oui | AA | le système doit conseiller le conducteur avant, à l'arrivée et au retour |
| fonctionsReservation | fonctions | haut | oui | CZ | le visiteur doit pouvoir choisir et réserver une place précise du niveau 2, comme un siège au cinéma |
| fonctionsRecharge | fonctions | haut | oui | CZ | le système doit recharger le véhicule électrique sur sa place réservée, sans intervention de l'usager |
| fonctionsAchats | fonctions | haut | oui | AA | le système doit prendre en charge les achats pendant la visite |
| controleAcces | fonctionsBase | intermédiaire | oui | AA + CZ | le système doit contrôler les entrées et sorties : lecture de plaque et ticket QR de visite à l'entrée, code QR de l'application au niveau 2, carte personnelle au niveau 3 |
| mesureOccupation | fonctionsBase | bas | oui | AA | le système doit détecter les places libres dans 98 % des cas, en 30 s |
| niveauEmployes | fonctionsBase | intermédiaire | oui | CZ | le système doit réserver le niveau 3 aux employés, exclu des réservations |
| tarification | fonctionsBase | bas | oui | CZ | le système doit appliquer la tarification paramétrée par l'exploitant (référence : 15 min gratuites puis payant, même tarif aux niveaux 1 et 2) |
| paiementUnique | fonctionsBase | intermédiaire | oui | AA + CZ | l'usager doit payer en une fois stationnement et recharge : à la caisse, ou par débit automatique de l'application à la sortie du niveau 2 |
| previsionAffluence | fonctionsConseil | bas | oui | AA | le système doit prévoir l'occupation par zone sur 2 h, erreur ≤ 15 % |
| calculTempsTotal | fonctionsConseil | bas | oui | AA | le système doit estimer le temps trajet + recherche, erreur ≤ 20 % |
| recommandationZone | fonctionsConseil | bas | oui | AA | le système doit recommander zone et entrée, sans zone prévue à plus de 90 % |
| alerteSaturation | fonctionsConseil | bas | oui | AA | le système doit alerter le gestionnaire 30 min avant une saturation |
| reductionRecherche | fonctionsConseil | bas | oui | AA | le système doit réduire de 25 % le temps moyen de recherche |
| localisationVehicule | fonctionsConseil | bas | oui | AA | le système doit afficher à la borne la place et le chemin piéton en 5 s, juste dans 99 % des cas |
| planTempsReel | fonctionsReservation | bas | oui | CZ | le système doit afficher sur le plan l'état de chaque place (libre, occupée, réservée, PMR, recharge possible), mis à jour en 3 s, exact dans 99 % des cas |
| declarationPlaque | fonctionsReservation | intermédiaire | oui | CZ | le visiteur doit pouvoir déclarer et modifier à tout moment la plaque du véhicule utilisé |
| accesNiveauReserve | fonctionsReservation | bas | oui | CZ | le système doit ouvrir l'accès au niveau 2 par le code QR de l'application en 10 s au plus |
| protectionPlace | fonctionsReservation | bas | oui | CZ | la barrière de place doit s'abaisser devant la plaque déclarée, lue correctement dans 98 % des cas, et se relever au départ |
| modificationReservation | fonctionsReservation | intermédiaire | oui | CZ | le visiteur doit pouvoir changer de place, annuler, prévenir d'un retard ou prolonger sa réservation à distance |
| liberationPlace | fonctionsReservation | bas | oui | CZ | le système doit libérer une place non honorée 30 min après l'heure prévue et débiter 5 € de frais de non-venue |
| fideliteReservation | fonctionsReservation | bas | oui | CZ | le système doit offrir 1 h de stationnement pour 10 réservations honorées |
| guidagePieton | fonctionsReservation | intermédiaire | oui | CZ | l'application doit guider le visiteur à pied jusqu'à son véhicule |
| acceptationCapacite | fonctionsRecharge | intermédiaire | oui | CZ | le système ne doit accepter l'option recharge que si les robots de la ligne peuvent la satisfaire, et proposer sinon une autre ligne |
| energieDelivree | fonctionsRecharge | bas | oui | CZ | le robot doit délivrer au moins 20 kWh en 30 min au plus par véhicule |
| deplacementRobot | fonctionsRecharge | bas | oui | CZ | le robot doit rejoindre seul la place en 3 min au plus après l'abaissement de la barrière de place, par un trajet sécurisé isolé du public |
| connexionAutomatique | fonctionsRecharge | bas | oui | CZ | le robot doit se connecter sans intervention de l'usager dans 98 % des cas |
| reserveEnergie | fonctionsRecharge | bas | oui | CZ | chaque ligne de 50 places doit disposer d'une réserve d'au moins 200 kWh, rechargée aux heures creuses |
| suiviRecharge | fonctionsRecharge | intermédiaire | oui | CZ | l'application doit afficher l'avancement de la recharge |
| enregistrementDepot | fonctionsAchats | bas | oui | AA | le système doit enregistrer un dépôt en 30 s, associé à la bonne commande dans 99 % des cas |
| regroupementCommandes | fonctionsAchats | bas | oui | AA | le système doit regrouper au moins 3 boutiques, 95 % des commandes complètes au créneau |
| notificationCommande | fonctionsAchats | bas | oui | AA | le système doit prévenir le client en 1 min, statuts exacts à 98 % |
| remiseBonClient | fonctionsAchats | bas | oui | AA | le système doit remettre 99,5 % des achats au bon client, identification en 15 s |
| tracabiliteAchats | fonctionsAchats | bas | oui | AA | le système doit journaliser 100 % des dépôts et retraits, incidents ≤ 1 % |
| reutilisationExistant | interactionsMaterielles | intermédiaire | non | AA | le système doit réutiliser capteurs, panneaux et lecteurs de plaques existants |
| notificationUsager | interactionsMaterielles | intermédiaire | non | AA + CZ | le système doit notifier par application, SMS ou écran ; l'application n'est obligatoire que pour réserver une place |
| bornesManuelles | interactionsMaterielles | intermédiaire | non | CZ | le niveau 1 doit offrir des bornes de recharge à branchement manuel, sans réservation |
| interphone | interactionsMaterielles | intermédiaire | non | CZ | l'usager doit pouvoir joindre le poste d'exploitation par interphone |
| puissanceConstante | contraintes | bas | non | CZ | le système doit desservir 20 % des places du niveau 2 sans augmenter la puissance de raccordement du site |
| securiteElectrique | contraintes | intermédiaire | non | CZ | la recharge et le stockage d'énergie doivent respecter la sécurité incendie des parcs couverts |
| puissanceCharge | securiteElectrique | bas | non | CZ | la charge doit rester ≤ 22 kVA par point ; une puissance supérieure (environ 44 kW) n'est admise que sur le trajet sécurisé des robots, après avis favorable de la commission de sécurité |
| plafondCompartiment | securiteElectrique | bas | non | CZ | au plus 20 points de charge et 150 kVA simultanés par compartiment |
| coupureIncendie | securiteElectrique | intermédiaire | non | CZ | toutes les charges doivent pouvoir être coupées depuis le poste d'exploitation en cas d'incendie |
| stockageEnergie | securiteElectrique | intermédiaire | non | CZ | la réserve d'énergie doit être implantée dans un local technique séparé |
| securiteRobot | contraintes | bas | non | CZ | le robot doit être conforme au règlement Machines (UE) 2023/1230 et à l'EN ISO 3691-4 (zone confinée par protecteurs fixes d'au moins 2,1 m) |
| prixRecharge | contraintes | intermédiaire | non | CZ | le prix de l'option recharge doit être affiché avant confirmation (AFIR) |
| donneesPersonnelles | contraintes | intermédiaire | non | AA + CZ | le système doit protéger les données personnelles des usagers (RGPD) |
| localisationProtegee | donneesPersonnelles | intermédiaire | non | AA | aucune localisation du véhicule ne doit être affichée sans identification valide |
| protectionPlaques | donneesPersonnelles | bas | non | CZ | les plaques ne doivent jamais être stockées en clair (hachage) et être conservées un mois au plus après la sortie |
| accessibilite | contraintes | bas | non | AA + CZ | le système doit préserver au moins 2 % de places PMR de 3,30 m, ainsi que des bornes, un point de retrait et des cheminements accessibles |
| libreChoix | contraintes | intermédiaire | non | AA + CZ | l'usager doit pouvoir venir sans réservation, ignorer le conseil et retirer ses achats en boutique |
| modeDegrade | contraintes | intermédiaire | non | AA | le système doit rester utilisable en cas de panne ou de retard |
