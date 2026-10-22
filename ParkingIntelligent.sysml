package parkingIntelligent {
    doc /*
     * Mini-projet SysML - Séance 1 : cadrage
     * Groupe : AMROUCH - AKICHOUH - ZARROUKI - CHERIF
     * Système : parking intelligent de centre commercial, avec quatre
     * innovations issues des deux concepts du groupe :
     *  - SmartFlow (AKICHOUH - AMROUCH) : conseil de zone (Predict) et
     *    dépôt / retrait des achats (Shopping Assist) ;
     *  - FlexPark (CHERIF - ZARROUKI) : réservation par bitonio connecté
     *    sur chaque place et robot de recharge mobile.
     */
    private import ScalarValues::Boolean;

    package parts {
        /* acteurs */
        part def Usager;
        part def Conducteur :> Usager;
        part def ConducteurVE :> Conducteur;
        part def Riverain :> Conducteur;
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
        part def Smartphone;
        part def SystemeBoutique;
        part def SystemePaiement;
        part def ReseauElectrique;
    }

    private import parkingIntelligent::parts::*;

    part def Contexte {
        part conducteur : Conducteur[*];
        part client : ClientCentre[*];
        part riverain : Riverain[*];
        part exploitant : Exploitant;
        part personnelBoutique : PersonnelBoutique[*];
        part personnelRetrait : PersonnelRetrait[*];
        part technicien : Technicien[*];
        part parking : ParkingIntelligent;
        part vehicule : Vehicule[*];
        part smartphone : Smartphone[*];
        part systemeBoutique : SystemeBoutique[*];
        part systemePaiement : SystemePaiement;
        part reseauElectrique : ReseauElectrique;

        flow reserve from conducteur to parking;
        flow consulte from conducteur to parking;
        flow loue from riverain to parking;
        flow deposeEtRetire from client to parking;
        flow enregistreDepot from personnelBoutique to parking;
        flow remetAchats from personnelRetrait to parking;
        flow supervise from exploitant to parking;
        flow entretient from technicien to parking;
        flow identifie from parking to vehicule;
        flow recharge from parking to vehicule;
        flow notifie from parking to smartphone;
        flow commande from systemeBoutique to parking;
        flow debite from parking to systemePaiement;
        flow alimente from reseauElectrique to parking;
        connect conducteur to vehicule;
        connect smartphone to parking;
    }

    package useCases {
        private import parkingIntelligent::parts::*;

        actor usager : Usager;
        actor conducteur : Conducteur :> usager;
        actor conducteurVE : ConducteurVE :> conducteur;
        actor client : ClientCentre :> usager;
        actor exploitant : Exploitant;
        actor personnelBoutique : PersonnelBoutique;
        actor personnelRetrait : PersonnelRetrait;
        actor technicien : Technicien;

        use case reserverPlace {
            doc /* Le conducteur (ou le riverain, la nuit) réserve une place
                 * précise ; le bitonio la protège puis s'abaisse quand la
                 * plaque du véhicule est reconnue. */
            ref actor conducteur;
        }
        use case obtenirConseilStationnement {
            doc /* À l'arrivée, le système recommande une zone et une entrée
                 * selon la prévision d'occupation et le temps total estimé. */
            ref actor conducteur;
        }
        use case demanderRecharge {
            doc /* Le conducteur d'un VE demande une énergie et une heure de
                 * départ ; le robot vient recharger le véhicule sur sa place. */
            ref actor conducteurVE;
        }
        use case retrouverVehicule {
            doc /* Au retour, une borne affiche la place du véhicule et le
                 * chemin piéton après identification du client. */
            ref actor client;
        }
        use case deposerAchats {
            doc /* Le client confie ses achats à une boutique partenaire, qui
                 * les étiquette et les associe à sa commande. */
            ref actor client;
            ref actor personnelBoutique;
        }
        use case retirerAchats {
            doc /* Le client retire en un seul passage les achats regroupés
                 * au point de retrait, avec un code à durée limitée. */
            ref actor client;
            ref actor personnelRetrait;
        }
        use case regrouperAchats {
            doc /* Le personnel regroupe les lots des différentes boutiques
                 * et le système suit le statut de chaque commande. */
            ref actor personnelRetrait;
        }
        use case superviserExploitation {
            doc /* L'exploitant suit occupation, prévisions, réservations,
                 * tournées du robot, retraits et alertes. */
            ref actor exploitant;
        }
        use case configurerAffectationPlaces {
            doc /* L'exploitant définit zones, places réservables, location
                 * de nuit et boutiques partenaires. */
            ref actor exploitant;
        }
        use case maintenirEquipements {
            doc /* Le technicien contrôle capteurs, bitonios, robot, stations
                 * de charge, bornes et point de retrait. */
            ref actor technicien;
        }
    }

    package requirements {
        /* exigences extraites des cas d'utilisation : fonctions de conseil */
        requirement mesureOccupation specializes fonctionsConseil {
            doc /* le système doit détecter l'état libre / occupé des places
                 * dans au moins 98 % des cas et le mettre à jour en 30 s au plus */
        }
        requirement previsionAffluence specializes fonctionsConseil {
            doc /* le système doit prévoir l'occupation par zone sur au moins 2 h,
                 * avec une erreur à 1 h d'au plus 15 % de la capacité */
        }
        requirement recommandationZone specializes fonctionsConseil {
            doc /* le système doit recommander une zone selon le temps total
                 * estimé, sans conseiller une zone prévue à plus de 90 % */
        }
        requirement reductionRecherche specializes fonctionsConseil {
            doc /* le temps moyen de recherche d'une place doit baisser d'au
                 * moins 25 % par rapport à une période comparable */
        }
        requirement localisationVehicule specializes fonctionsConseil {
            doc /* la borne doit afficher place et chemin piéton en 5 s au plus,
                 * avec une localisation correcte dans au moins 99 % des cas */
        }

        /* fonctions de réservation par bitonio */
        requirement blocagePlace specializes fonctionsReservation {
            doc /* chaque place doit être bloquée ou libérée sur commande en 2 s
                 * au plus, avec arrêt du bitonio en présence d'un obstacle */
        }
        requirement reconnaissanceVehicule specializes fonctionsReservation {
            doc /* le bitonio doit s'abaisser en 10 s au plus après reconnaissance
                 * de la plaque, pour au moins 98 % des arrivées */
        }
        requirement reattributionPlace specializes fonctionsReservation {
            doc /* une place réservée non occupée 1 h après l'heure prévue doit
                 * être remise à disposition en 1 min au plus */
        }
        requirement affectationDynamique specializes fonctionsReservation {
            doc /* l'affectation de toutes les places (hors PMR) doit pouvoir
                 * changer selon le profil et l'horaire, en 5 min au plus */
        }
        requirement surveillanceBitonios specializes fonctionsReservation {
            doc /* les bitonios doivent être disponibles 99 % du temps et
                 * signaler un défaut au superviseur en 5 min au plus */
        }

        /* fonctions de recharge mobile */
        requirement planificationRecharge specializes fonctionsRecharge {
            doc /* le système doit prendre en compte une demande en 1 min au plus
                 * et servir au moins 90 % des demandes avant le départ déclaré */
        }
        requirement capaciteRobot specializes fonctionsRecharge {
            doc /* un robot doit réaliser au moins 20 recharges par jour,
                 * de 5 à 15 kWh chacune */
        }
        requirement deplacementRobot specializes fonctionsRecharge {
            doc /* le robot doit rouler à 4,9 km/h au plus et s'arrêter avant
                 * tout contact avec une personne */
        }
        requirement notificationRecharge specializes fonctionsRecharge {
            doc /* l'usager doit être prévenu de la fin de charge en 1 min au plus */
        }

        /* fonctions de dépôt et retrait des achats */
        requirement enregistrementDepot specializes fonctionsAchats {
            doc /* un lot doit être enregistré en 30 s au plus et associé à la
                 * bonne commande dans au moins 99 % des cas */
        }
        requirement regroupementCommandes specializes fonctionsAchats {
            doc /* une commande doit pouvoir regrouper au moins 3 boutiques et
                 * être complète au créneau annoncé dans 95 % des cas */
        }
        requirement notificationCommande specializes fonctionsAchats {
            doc /* le client doit être prévenu en 1 min au plus quand sa
                 * commande est prête */
        }
        requirement remiseBonClient specializes fonctionsAchats {
            doc /* au moins 99,5 % des retraits doivent être remis au bon client,
                 * après une identification de 15 s au plus */
        }
        requirement tracabiliteAchats specializes fonctionsAchats {
            doc /* 100 % des dépôts et retraits doivent être journalisés ; les
                 * pertes ou mélanges doivent rester sous 1 % des commandes */
        }

        /* exigences extraites des interactions avec les éléments de contexte */
        requirement reutilisationExistant specializes interactionsMaterielles {
            doc /* le système doit réutiliser les capteurs, panneaux, lecteurs de
                 * plaques et le superviseur existants, sans travaux lourds */
        }
        requirement connecteursRecharge specializes interactionsMaterielles {
            doc /* le robot doit être compatible Type 2 (AC) et CCS (DC) */
        }
        requirement paiementAutomatique specializes interactionsMaterielles {
            doc /* le stationnement et l'énergie doivent être débités
                 * automatiquement à la sortie */
        }
        requirement notificationSmartphone specializes interactionsMaterielles {
            doc /* l'usager doit pouvoir réserver, suivre sa recharge et sa
                 * commande depuis son smartphone */
        }

        /* contraintes */
        requirement securiteElectrique specializes contraintes {
            doc /* la recharge doit rester sous 22 kVA en zone couverte ; les
                 * stations du robot doivent pouvoir être coupées depuis le poste
                 * d'exploitation et un échauffement détecté en 3 min au plus */
        }
        requirement donneesPersonnelles specializes contraintes {
            doc /* les données doivent être minimisées ; images de plaques
                 * conservées 1 mois au plus ; aucune localisation sans
                 * identification valide */
        }
        requirement accessibilite specializes contraintes {
            doc /* les places PMR, voies de circulation et cheminements piétons
                 * doivent être préservés */
        }
        requirement libreChoix specializes contraintes {
            doc /* tout usager doit pouvoir se garer librement sur une place non
                 * réservée ; la recommandation n'est jamais imposée */
        }
        requirement modeDegrade specializes contraintes {
            doc /* en cas de panne de la prévision, des capteurs ou du robot, le
                 * parking doit rester utilisable */
        }

        /* exigences créées pour regrouper l'ensemble de manière hiérarchique */
        requirement fonctionsConseil specializes fonctions {
            doc /* le système doit conseiller le conducteur à l'arrivée et au retour */
        }
        requirement fonctionsReservation specializes fonctions {
            doc /* le système doit gérer chaque place comme une ressource réservable */
        }
        requirement fonctionsRecharge specializes fonctions {
            doc /* le système doit recharger un VE sur n'importe quelle place */
        }
        requirement fonctionsAchats specializes fonctions {
            doc /* le système doit prendre en charge les achats pendant la visite */
        }
        requirement contraintes specializes specificationsParking {
            doc /* le système doit respecter les contraintes ci-dessous */
        }
        requirement fonctions specializes specificationsParking {
            doc /* le système doit comprendre les fonctions listées ci-dessous */
        }
        requirement interactionsMaterielles specializes specificationsParking {
            doc /* le système doit pouvoir disposer des interactions
                 * matérielles listées */
        }
        requirement specificationsParking {
            doc /* le système répond aux catégories d'exigences listées ci-dessous */
        }
    }
}
