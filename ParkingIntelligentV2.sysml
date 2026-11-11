package parkingIntelligentV2 {
    doc /*
     * Mini-projet SysML - Séance 1 : cadrage, version 3 (11/11/2026)
     * Produit : ParkSys FlexFlow, parking intelligent pour grand centre commercial
     * Groupe : AMROUCH - AKICHOUH - ZARROUKI - CHERIF
     * Innovations : SmartFlow Predict et Shopping Assist (dossier akichouh-amrouch),
     * choix de place comme au cinéma et recharge apportée par robot
     * (dossier cherif-zarrouki).
     * Version 3 : contexte avec cardinalités, 10 cas d'utilisation,
     * innovations cherif-zarrouki mises à jour de V4_2 vers V6 ;
     * securiteElectrique et donneesPersonnelles deviennent des exigences intermédiaires.
     */

    package parts {
        /* acteurs */
        part def Usager;
        part def Conducteur :> Usager;
        part def ConducteurVE :> Conducteur;
        part def Employe :> Conducteur;
        part def ClientCentre :> Usager;
        part def Personnel;
        part def Exploitant :> Personnel;
        part def PersonnelBoutique :> Personnel;
        part def PersonnelRetrait :> Personnel;
        part def Technicien :> Personnel;

        /* contexte */
        part def ParkingIntelligent {
            doc /* système étudié : ParkSys FlexFlow */
        }
        part def Vehicule;
        part def VehiculeElectrique :> Vehicule;
        part def Telephone;
        part def Achats;
        part def SystemePaiement;
        part def ReseauElectrique;
        part def SystemeSecuriteIncendie;
    }

    private import parkingIntelligentV2::parts::*;

    part def Contexte {
        part conducteur : Conducteur[*];
        part conducteurVE : ConducteurVE[*];
        part employe : Employe[*];
        part client : ClientCentre[*];
        part exploitant : Exploitant[1..*];
        part personnelBoutique : PersonnelBoutique[*];
        part personnelRetrait : PersonnelRetrait[1..*];
        part technicien : Technicien[1..*];
        part parking : ParkingIntelligent;
        part vehicule : Vehicule[*];
        part vehiculeElectrique : VehiculeElectrique[*];
        part telephone : Telephone[*];
        part achats : Achats[*];
        part systemePaiement : SystemePaiement;
        part reseauElectrique : ReseauElectrique;
        part systemeSecuriteIncendie : SystemeSecuriteIncendie;

        flow consulte from conducteur to parking;
        flow reserve from conducteur to parking;
        flow paie from conducteur to parking;
        flow demandeRecharge from conducteurVE to parking;
        flow accede from employe to parking;
        flow deposeEtRetire from client to parking;
        flow enregistreDepot from personnelBoutique to parking;
        flow remetAchats from personnelRetrait to parking;
        flow supervise from exploitant to parking;
        flow entretient from technicien to parking;
        flow identifie from parking to vehicule;
        flow recharge from parking to vehiculeElectrique;
        flow notifie from parking to telephone;
        flow regroupe from parking to achats;
        flow encaisse from parking to systemePaiement;
        flow alimente from reseauElectrique to parking;
        flow coupeRecharges from systemeSecuriteIncendie to parking;
        connect conducteur to vehicule;
        connect conducteurVE to vehiculeElectrique;
    }

    package useCases {
        private import parkingIntelligentV2::parts::*;

        actor usager : Usager;
        actor conducteur : Conducteur ::> usager;
        actor conducteurVE : ConducteurVE ::> conducteur;
        actor employe : Employe ::> conducteur;
        actor client : ClientCentre ::> usager;
        actor exploitant : Exploitant;
        actor personnelBoutique : PersonnelBoutique;
        actor personnelRetrait : PersonnelRetrait;
        actor technicien : Technicien;

        use case consulterConseilStationnement {
            doc /* SmartFlow Predict : zone et entrée conseillées avant et à l'arrivée */
            ref actor conducteur;
        }
        use case reserverPlace {
            doc /* choisir, modifier, prolonger ou annuler une place précise du niveau 2 */
            ref actor conducteur;
        }
        use case demanderRecharge {
            doc /* option recharge : un robot recharge le véhicule sur sa place réservée */
            ref actor conducteurVE;
        }
        use case accederAuParking {
            doc /* entrer et rejoindre sa place : plaque et ticket QR, code QR du niveau 2,
                   carte employé au niveau 3, barrière de place */
            ref actor conducteur;
        }
        use case deposerAchats {
            doc /* Shopping Assist : dépôt en boutique et regroupement vers un casier */
            ref actor client;
            ref actor personnelBoutique;
            ref actor personnelRetrait;
        }
        use case retirerAchats {
            doc /* Shopping Assist : retrait de la commande regroupée avec un code */
            ref actor client;
            ref actor personnelRetrait;
        }
        use case retrouverVehicule {
            doc /* borne de retour (QR du ticket) ou guidage piéton par l'application */
            ref actor conducteur;
        }
        use case payerEtSortir {
            ref actor conducteur;
        }
        use case superviserExploitation {
            ref actor exploitant;
        }
        use case maintenirEquipements {
            ref actor technicien;
        }
    }

    package requirements {
        requirement specificationsParking {
            doc /* le système répond aux catégories d'exigences ci-dessous */
        }
        requirement fonctions specializes specificationsParking {
            doc /* le système doit comprendre les fonctions ci-dessous */
        }
        requirement interactionsMaterielles specializes specificationsParking {
            doc /* le système doit disposer des interactions matérielles ci-dessous */
        }
        requirement contraintes specializes specificationsParking {
            doc /* le système doit respecter les contraintes ci-dessous */
        }

        /* fonctions */
        requirement fonctionsBase specializes fonctions {
            doc /* le système doit assurer les fonctions du parking de référence */
        }
        requirement fonctionsConseil specializes fonctions {
            doc /* le système doit conseiller le conducteur avant, à l'arrivée et au retour */
        }
        requirement fonctionsReservation specializes fonctions {
            doc /* le visiteur doit pouvoir choisir et réserver une place précise
                   du niveau 2, comme un siège au cinéma */
        }
        requirement fonctionsRecharge specializes fonctions {
            doc /* le système doit recharger le véhicule électrique sur sa place réservée,
                   sans intervention de l'usager */
        }
        requirement fonctionsAchats specializes fonctions {
            doc /* le système doit prendre en charge les achats pendant la visite */
        }

        /* base */
        requirement controleAcces specializes fonctionsBase {
            doc /* le système doit contrôler les entrées et sorties : lecture de plaque
                   et ticket QR de visite à l'entrée, code QR de l'application au niveau 2,
                   carte personnelle au niveau 3 */
        }
        requirement mesureOccupation specializes fonctionsBase {
            doc /* le système doit détecter les places libres dans 98 % des cas, en 30 s */
        }
        requirement niveauEmployes specializes fonctionsBase {
            doc /* le système doit réserver le niveau 3 aux employés, exclu des réservations */
        }
        requirement tarification specializes fonctionsBase {
            doc /* le système doit appliquer la tarification paramétrée par l'exploitant
                   (référence : 15 min gratuites puis payant, même tarif aux niveaux 1 et 2) */
        }
        requirement paiementUnique specializes fonctionsBase {
            doc /* l'usager doit payer en une fois stationnement et recharge : à la caisse,
                   ou par débit automatique de l'application à la sortie du niveau 2 */
        }

        /* conseil (SmartFlow Predict) */
        requirement previsionAffluence specializes fonctionsConseil {
            doc /* le système doit prévoir l'occupation par zone sur 2 h, erreur ≤ 15 % */
        }
        requirement calculTempsTotal specializes fonctionsConseil {
            doc /* le système doit estimer le temps trajet + recherche, erreur ≤ 20 % */
        }
        requirement recommandationZone specializes fonctionsConseil {
            doc /* le système doit recommander zone et entrée, sans zone prévue à plus de 90 % */
        }
        requirement alerteSaturation specializes fonctionsConseil {
            doc /* le système doit alerter le gestionnaire 30 min avant une saturation */
        }
        requirement reductionRecherche specializes fonctionsConseil {
            doc /* le système doit réduire de 25 % le temps moyen de recherche */
        }
        requirement localisationVehicule specializes fonctionsConseil {
            doc /* le système doit afficher à la borne la place et le chemin piéton
                   en 5 s, juste dans 99 % des cas */
        }

        /* réservation de place (choix comme au cinéma) */
        requirement planTempsReel specializes fonctionsReservation {
            doc /* le système doit afficher sur le plan l'état de chaque place (libre, occupée,
                   réservée, PMR, recharge possible), mis à jour en 3 s, exact dans 99 % des cas */
        }
        requirement declarationPlaque specializes fonctionsReservation {
            doc /* le visiteur doit pouvoir déclarer et modifier à tout moment
                   la plaque du véhicule utilisé */
        }
        requirement accesNiveauReserve specializes fonctionsReservation {
            doc /* le système doit ouvrir l'accès au niveau 2 par le code QR de l'application
                   en 10 s au plus */
        }
        requirement protectionPlace specializes fonctionsReservation {
            doc /* la barrière de place doit s'abaisser devant la plaque déclarée,
                   lue correctement dans 98 % des cas, et se relever au départ */
        }
        requirement modificationReservation specializes fonctionsReservation {
            doc /* le visiteur doit pouvoir changer de place, annuler, prévenir d'un retard
                   ou prolonger sa réservation à distance */
        }
        requirement liberationPlace specializes fonctionsReservation {
            doc /* le système doit libérer une place non honorée 30 min après l'heure prévue
                   et débiter 5 € de frais de non-venue */
        }
        requirement fideliteReservation specializes fonctionsReservation {
            doc /* le système doit offrir 1 h de stationnement pour 10 réservations honorées */
        }
        requirement guidagePieton specializes fonctionsReservation {
            doc /* l'application doit guider le visiteur à pied jusqu'à son véhicule */
        }

        /* recharge apportée par robot */
        requirement acceptationCapacite specializes fonctionsRecharge {
            doc /* le système ne doit accepter l'option recharge que si les robots de la ligne
                   peuvent la satisfaire, et proposer sinon une autre ligne */
        }
        requirement energieDelivree specializes fonctionsRecharge {
            doc /* le robot doit délivrer au moins 20 kWh en 30 min au plus par véhicule */
        }
        requirement deplacementRobot specializes fonctionsRecharge {
            doc /* le robot doit rejoindre seul la place en 3 min au plus après l'abaissement
                   de la barrière de place, par un trajet sécurisé isolé du public */
        }
        requirement connexionAutomatique specializes fonctionsRecharge {
            doc /* le robot doit se connecter sans intervention de l'usager dans 98 % des cas */
        }
        requirement reserveEnergie specializes fonctionsRecharge {
            doc /* chaque ligne de 50 places doit disposer d'une réserve d'au moins 200 kWh,
                   rechargée aux heures creuses */
        }
        requirement suiviRecharge specializes fonctionsRecharge {
            doc /* l'application doit afficher l'avancement de la recharge */
        }

        /* achats (Shopping Assist) */
        requirement enregistrementDepot specializes fonctionsAchats {
            doc /* le système doit enregistrer un dépôt en 30 s, associé à la bonne commande
                   dans 99 % des cas */
        }
        requirement regroupementCommandes specializes fonctionsAchats {
            doc /* le système doit regrouper au moins 3 boutiques, 95 % des commandes
                   complètes au créneau */
        }
        requirement notificationCommande specializes fonctionsAchats {
            doc /* le système doit prévenir le client en 1 min, statuts exacts à 98 % */
        }
        requirement remiseBonClient specializes fonctionsAchats {
            doc /* le système doit remettre 99,5 % des achats au bon client,
                   identification en 15 s */
        }
        requirement tracabiliteAchats specializes fonctionsAchats {
            doc /* le système doit journaliser 100 % des dépôts et retraits, incidents ≤ 1 % */
        }

        /* interactions matérielles */
        requirement reutilisationExistant specializes interactionsMaterielles {
            doc /* le système doit réutiliser capteurs, panneaux et lecteurs de plaques existants */
        }
        requirement notificationUsager specializes interactionsMaterielles {
            doc /* le système doit notifier par application, SMS ou écran ; l'application
                   n'est obligatoire que pour réserver une place */
        }
        requirement bornesManuelles specializes interactionsMaterielles {
            doc /* le niveau 1 doit offrir des bornes de recharge à branchement manuel,
                   sans réservation */
        }
        requirement interphone specializes interactionsMaterielles {
            doc /* l'usager doit pouvoir joindre le poste d'exploitation par interphone */
        }

        /* contraintes */
        requirement puissanceConstante specializes contraintes {
            doc /* le système doit desservir 20 % des places du niveau 2 sans augmenter
                   la puissance de raccordement du site */
        }
        requirement securiteElectrique specializes contraintes {
            doc /* la recharge et le stockage d'énergie doivent respecter
                   la sécurité incendie des parcs couverts */
        }
        requirement puissanceCharge specializes securiteElectrique {
            doc /* la charge doit rester ≤ 22 kVA par point ; une puissance supérieure
                   (environ 44 kW) n'est admise que sur le trajet sécurisé des robots,
                   après avis favorable de la commission de sécurité */
        }
        requirement plafondCompartiment specializes securiteElectrique {
            doc /* au plus 20 points de charge et 150 kVA simultanés par compartiment */
        }
        requirement coupureIncendie specializes securiteElectrique {
            doc /* toutes les charges doivent pouvoir être coupées depuis le poste
                   d'exploitation en cas d'incendie */
        }
        requirement stockageEnergie specializes securiteElectrique {
            doc /* la réserve d'énergie doit être implantée dans un local technique séparé */
        }
        requirement securiteRobot specializes contraintes {
            doc /* le robot doit être conforme au règlement Machines (UE) 2023/1230 et à
                   l'EN ISO 3691-4 (zone confinée par protecteurs fixes d'au moins 2,1 m) */
        }
        requirement prixRecharge specializes contraintes {
            doc /* le prix de l'option recharge doit être affiché avant confirmation (AFIR) */
        }
        requirement donneesPersonnelles specializes contraintes {
            doc /* le système doit protéger les données personnelles des usagers (RGPD) */
        }
        requirement localisationProtegee specializes donneesPersonnelles {
            doc /* aucune localisation du véhicule ne doit être affichée sans identification valide */
        }
        requirement protectionPlaques specializes donneesPersonnelles {
            doc /* les plaques ne doivent jamais être stockées en clair (hachage)
                   et être conservées un mois au plus après la sortie */
        }
        requirement accessibilite specializes contraintes {
            doc /* le système doit préserver au moins 2 % de places PMR de 3,30 m,
                   ainsi que des bornes, un point de retrait et des cheminements accessibles */
        }
        requirement libreChoix specializes contraintes {
            doc /* l'usager doit pouvoir venir sans réservation, ignorer le conseil
                   et retirer ses achats en boutique */
        }
        requirement modeDegrade specializes contraintes {
            doc /* le système doit rester utilisable en cas de panne ou de retard */
        }
    }
}
