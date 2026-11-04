package parkingIntelligentV2 {
    doc /*
     * Mini-projet SysML - Séance 1 : cadrage, version 2
     * Groupe : AMROUCH - AKICHOUH - ZARROUKI - CHERIF
     * Innovations : SmartFlow Predict et Shopping Assist (dossier V10),
     * garantie d'arrivée et énergie garantie au départ (dossier V4_2).
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
        flow demandeGarantie from conducteur to parking;
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
        use case demanderGarantieArrivee { ref actor conducteur; }
        use case modifierGarantie { ref actor conducteur; }
        use case demanderEnergieGarantie { ref actor conducteurVE; }
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
        requirement fonctionsGarantieArrivee specializes fonctions {
            doc /* garantir au visiteur de pouvoir se garer pendant son créneau */
        }
        requirement fonctionsEnergie specializes fonctions {
            doc /* garantir l'énergie demandée à l'heure de départ annoncée */
        }
        requirement fonctionsAchats specializes fonctions {
            doc /* prendre en charge les achats pendant la visite */
        }

        /* base */
        requirement controleAcces specializes fonctionsBase {
            doc /* contrôler les entrées et sorties par lecture de plaque */
        }
        requirement mesureOccupation specializes fonctionsBase {
            doc /* détecter les places libres dans 98 % des cas, en 30 s */
        }
        requirement niveauEmployes specializes fonctionsBase {
            doc /* réserver un niveau aux employés, exclu des garanties */
        }
        requirement paiementUnique specializes fonctionsBase {
            doc /* payer en une fois stationnement et énergie avant la sortie */
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

        /* garantie d'arrivée */
        requirement verificationCapacite specializes fonctionsGarantieArrivee {
            doc /* n'accorder une garantie que si la capacité du créneau le permet */
        }
        requirement choixProfil specializes fonctionsGarantieArrivee {
            doc /* orienter vers une zone adaptée au profil : voiture, moto, PMR, famille */
        }
        requirement acompteGarantie specializes fonctionsGarantieArrivee {
            doc /* demander un acompte aux heures de pointe, gardé si non-présentation */
        }
        requirement prolongationGarantie specializes fonctionsGarantieArrivee {
            doc /* prolonger ou annuler une garantie avant la fin du créneau */
        }
        requirement liberationGarantie specializes fonctionsGarantieArrivee {
            doc /* libérer une garantie non utilisée à la fin du créneau */
        }

        /* énergie garantie au départ */
        requirement conversionAutonomie specializes fonctionsEnergie {
            doc /* convertir l'autonomie demandée en km en énergie à fournir */
        }
        requirement verificationPuissance specializes fonctionsEnergie {
            doc /* confirmer seulement si la puissance du site le permet, sinon proposer une alternative */
        }
        requirement coutConnuAvance specializes fonctionsEnergie {
            doc /* annoncer le coût de l'énergie avant confirmation */
        }
        requirement planificationRecharge specializes fonctionsEnergie {
            doc /* planifier les recharges sans manipulation, terminées avant la fermeture */
        }
        requirement notificationRecharge specializes fonctionsEnergie {
            doc /* prévenir l'usager de la fin de charge en 1 min */
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
        requirement notificationUsager specializes interactionsMaterielles {
            doc /* notifier par application, SMS ou écran, sans application obligatoire */
        }

        /* contraintes */
        requirement puissanceConstante specializes contraintes {
            doc /* desservir 20 % des places sans augmenter la puissance de raccordement */
        }
        requirement securiteElectrique specializes contraintes {
            doc /* recharge ≤ 22 kVA, coupure depuis le poste d'exploitation en cas d'incendie */
        }
        requirement donneesPersonnelles specializes contraintes {
            doc /* aucune localisation du véhicule sans identification valide */
        }
        requirement accessibilite specializes contraintes {
            doc /* préserver places PMR, bornes, point de retrait et cheminements */
        }
        requirement libreChoix specializes contraintes {
            doc /* venir sans réservation, ignorer le conseil, retirer ses achats en boutique */
        }
        requirement modeDegrade specializes contraintes {
            doc /* rester utilisable en cas de panne, de retard ou de garantie intenable */
        }
    }
}
