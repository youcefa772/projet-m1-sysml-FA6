package parkingIntelligentV2 {
    doc /*
     * Mini-projet SysML - Séance 1 : cadrage, version 2
     * Groupe : AMROUCH - AKICHOUH - ZARROUKI - CHERIF
     * Innovations : SmartFlow Predict et Shopping Assist (dossier V10),
     * recharge apportée au véhicule et choix de la place comme au cinéma
     * (concept Réserv'Station du binôme CHERIF - ZARROUKI).
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
        part def ParkingIntelligent;
        part def Vehicule;
        part def VehiculeElectrique :> Vehicule;
        part def Telephone;
        part def SystemePaiement;
        part def ReseauElectrique;
    }

    private import parkingIntelligentV2::parts::*;

    part def Contexte {
        part conducteur : Conducteur;
        part employe : Employe;
        part client : ClientCentre;
        part exploitant : Exploitant;
        part personnelBoutique : PersonnelBoutique;
        part personnelRetrait : PersonnelRetrait;
        part technicien : Technicien;
        part parking : ParkingIntelligent;
        part vehicule : Vehicule;
        part telephone : Telephone;
        part systemePaiement : SystemePaiement;
        part reseauElectrique : ReseauElectrique;

        flow consulte from conducteur to parking;
        flow reserve from conducteur to parking;
        flow paie from conducteur to parking;
        flow accede from employe to parking;
        flow deposeEtRetire from client to parking;
        flow enregistreDepot from personnelBoutique to parking;
        flow remetAchats from personnelRetrait to parking;
        flow supervise from exploitant to parking;
        flow entretient from technicien to parking;
        flow identifie from parking to vehicule;
        flow recharge from parking to vehicule;
        flow notifie from parking to telephone;
        flow encaisse from parking to systemePaiement;
        flow alimente from reseauElectrique to parking;
        connect conducteur to vehicule;
    }

    package useCases {
        private import parkingIntelligentV2::parts::*;

        actor usager : Usager;
        actor conducteur : Conducteur :> usager;
        actor conducteurVE : ConducteurVE :> conducteur;
        actor employe : Employe :> conducteur;
        actor client : ClientCentre :> usager;
        actor exploitant : Exploitant;
        actor personnelBoutique : PersonnelBoutique;
        actor personnelRetrait : PersonnelRetrait;
        actor technicien : Technicien;

        use case preparerVenue { ref actor conducteur; }
        use case reserverPlace { ref actor conducteur; }
        use case modifierReservation { ref actor conducteur; }
        use case demanderRecharge { ref actor conducteurVE; }
        use case utiliserBorneManuelle { ref actor conducteurVE; }
        use case obtenirConseilStationnement { ref actor conducteur; }
        use case stationnerNiveauReserve { ref actor employe; }
        use case deposerAchats { ref actor client; ref actor personnelBoutique; }
        use case regrouperAchats { ref actor personnelRetrait; }
        use case retirerAchats { ref actor client; ref actor personnelRetrait; }
        use case retrouverVehicule { ref actor client; }
        use case payerEtSortir { ref actor conducteur; }
        use case superviserExploitation { ref actor exploitant; }
        use case maintenirEquipements { ref actor technicien; }
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
            doc /* assurer les fonctions du parking de référence */
        }
        requirement fonctionsConseil specializes fonctions {
            doc /* conseiller le conducteur avant, à l'arrivée et au retour */
        }
        requirement fonctionsReservation specializes fonctions {
            doc /* choisir à l'avance une place précise du niveau 2 et la trouver protégée */
        }
        requirement fonctionsRecharge specializes fonctions {
            doc /* recharger le véhicule sur sa place, sans intervention du conducteur */
        }
        requirement fonctionsAchats specializes fonctions {
            doc /* prendre en charge les achats pendant la visite */
        }

        /* base */
        requirement controleAcces specializes fonctionsBase {
            doc /* contrôler l'accès : ticket au niveau 1, code QR au niveau 2, carte au niveau 3 */
        }
        requirement mesureOccupation specializes fonctionsBase {
            doc /* détecter les places libres dans 98 % des cas, en 30 s */
        }
        requirement niveauEmployes specializes fonctionsBase {
            doc /* réserver le niveau 3 aux employés */
        }
        requirement tarification specializes fonctionsBase {
            doc /* 15 min gratuites, même tarif aux niveaux 1 et 2, recharge facturée à la sortie */
        }
        requirement paiementApplication specializes fonctionsBase {
            doc /* encaisser automatiquement par l'application à la sortie du niveau 2 */
        }
        requirement bornesManuelles specializes fonctionsBase {
            doc /* recharger en libre-service aux bornes du niveau 1, sans réservation */
        }
        requirement interphone specializes fonctionsBase {
            doc /* mettre l'usager en relation avec le poste d'exploitation */
        }

        /* conseil (SmartFlow Predict) */
        requirement previsionAffluence specializes fonctionsConseil {
            doc /* prévoir l'occupation par zone sur 2 h, erreur ≤ 15 % */
        }
        requirement calculTempsTotal specializes fonctionsConseil {
            doc /* estimer le temps trajet + recherche, erreur ≤ 20 % */
        }
        requirement recommandationZone specializes fonctionsConseil {
            doc /* recommander zone et entrée, sans zone prévue à plus de 90 % */
        }
        requirement alerteSaturation specializes fonctionsConseil {
            doc /* alerter le gestionnaire 30 min avant une saturation */
        }
        requirement reductionRecherche specializes fonctionsConseil {
            doc /* réduire de 25 % le temps moyen de recherche */
        }
        requirement localisationVehicule specializes fonctionsConseil {
            doc /* afficher à la borne la place et le chemin piéton en 5 s, 99 % justes */
        }

        /* réservation : je choisis ma place comme au cinéma */
        requirement choixPlacePlan specializes fonctionsReservation {
            doc /* afficher le plan : places libres, occupées, réservées, PMR et recharge possible */
        }
        requirement placeSelonDestination specializes fonctionsReservation {
            doc /* proposer les places les plus proches de la destination déclarée */
        }
        requirement plaqueDeclaree specializes fonctionsReservation {
            doc /* déclarer la plaque du véhicule, modifiable à tout moment */
        }
        requirement protectionPlace specializes fonctionsReservation {
            doc /* protéger la place jusqu'à l'arrivée du véhicule à la plaque déclarée */
        }
        requirement delaiGrace specializes fonctionsReservation {
            doc /* garder la place 30 min après l'heure prévue, puis la libérer avec 5 € de frais de non-venue */
        }
        requirement prolongationReservation specializes fonctionsReservation {
            doc /* prolonger la réservation à distance */
        }
        requirement fideliteReservation specializes fonctionsReservation {
            doc /* offrir 1 h de stationnement pour 10 réservations honorées */
        }

        /* recharge : la recharge vient au véhicule */
        requirement acceptationRecharge specializes fonctionsRecharge {
            doc /* accepter l'option seulement si les 2 moyens de recharge de la ligne peuvent la faire, sinon proposer une autre ligne */
        }
        requirement dureeRecharge specializes fonctionsRecharge {
            doc /* délivrer la recharge maximale possible en 30 min au plus par véhicule */
        }
        requirement reserveEnergie specializes fonctionsRecharge {
            doc /* puiser l'énergie dans une réserve fixe par ligne, rechargée aux heures creuses */
        }
        requirement suiviRecharge specializes fonctionsRecharge {
            doc /* suivre l'avancement de la recharge dans l'application */
        }

        /* achats (Shopping Assist) */
        requirement enregistrementDepot specializes fonctionsAchats {
            doc /* enregistrer un dépôt en 30 s, associé à la bonne commande dans 99 % des cas */
        }
        requirement regroupementCommandes specializes fonctionsAchats {
            doc /* regrouper au moins 3 boutiques, 95 % complètes au créneau */
        }
        requirement notificationCommande specializes fonctionsAchats {
            doc /* prévenir le client en 1 min, statuts exacts à 98 % */
        }
        requirement remiseBonClient specializes fonctionsAchats {
            doc /* remettre 99,5 % des achats au bon client, identification en 15 s */
        }
        requirement tracabiliteAchats specializes fonctionsAchats {
            doc /* journaliser 100 % des dépôts et retraits, incidents ≤ 1 % */
        }

        /* interactions matérielles */
        requirement reutilisationExistant specializes interactionsMaterielles {
            doc /* réutiliser capteurs, panneaux et lecteurs de plaques existants */
        }
        requirement applicationUnique specializes interactionsMaterielles {
            doc /* réserver, suivre la recharge et payer dans une seule application */
        }
        requirement notificationAchats specializes interactionsMaterielles {
            doc /* notifier les achats par application, SMS ou écran */
        }

        /* contraintes */
        requirement puissanceConstante specializes contraintes {
            doc /* desservir 20 % des places de chaque ligne sans augmenter la puissance de raccordement */
        }
        requirement securiteElectrique specializes contraintes {
            doc /* recharge ≤ 22 kVA, 150 kVA simultanés par compartiment, coupure en cas d'incendie */
        }
        requirement securiteCirculation specializes contraintes {
            doc /* le moyen de recharge ne gêne ni ne met en danger véhicules et piétons */
        }
        requirement donneesPersonnelles specializes contraintes {
            doc /* aucune localisation du véhicule sans identification valide */
        }
        requirement accessibilite specializes contraintes {
            doc /* préserver places PMR, bornes, point de retrait et cheminements */
        }
        requirement libreChoix specializes contraintes {
            doc /* venir sans réserver au niveau 1, ignorer le conseil, retirer ses achats en boutique */
        }
        requirement modeDegrade specializes contraintes {
            doc /* rester utilisable en cas de panne, de retard ou de recharge impossible */
        }
    }
}
