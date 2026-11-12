/*
 * Mini-projet SysML - Séance 2 : flux d'actions et séquences (ZARROUKI Ahmed)
 * Cas d'utilisation : maintenirEquipements (package parkingIntelligentV2::useCases)
 * Exigences détaillées : securiteRobot, modeDegrade, mesureOccupation,
 * reserveEnergie, planTempsReel
 * Point de vue : celui du système ; les gardes sont des attributs booléens.
 * Une action sépare toujours deux nœuds de contrôle (decide / merge), comme dans le corrigé.
 * Séquences : un scénario par cheminement du flux, S1 à S4 ;
 * les lignes de vie sont des composants du système, sans acteur.
 * Réutilise CapteursPlaces et Superviseur (parkingConseil, AKICHOUH),
 * les composants de seance2Cherif et de seance2Zarrouki.
 */
package seance2ZarroukiMaintenance {
    private import ScalarValues::Boolean;

    action maintenirEquipements {
        attribute interventionOuverte : Boolean;
        attribute equipementChoisi : Boolean;
        attribute equipementRobot : Boolean;
        attribute equipementFixe : Boolean;
        attribute testReussi : Boolean;
        attribute testEchoue : Boolean;
        attribute autreEquipement : Boolean;
        attribute finIntervention : Boolean;

        action listerEquipementsADefaut;
        action mettreHorsService;
        action neutraliserPlaceOuCapacite;
        action arreterRobotsLigne;
        action autoriserAccesTrajet;
        action signalerZoneIntervention;
        action lancerTest;
        action remettreEnService;
        action mettreAJourPlanCapacite;
        action enregistrerPanne;
        action maintenirHorsService;
        action enregistrerIntervention;
        action actualiserListe;
        action cloturerIntervention;
        merge merge0;
        merge merge1;
        merge merge2;
        decide decide0;
        decide decide1;
        decide decide2;

        first start;
        succession start if interventionOuverte then listerEquipementsADefaut;
        succession listerEquipementsADefaut then merge0;
        succession merge0 if equipementChoisi then mettreHorsService;
        succession mettreHorsService then neutraliserPlaceOuCapacite;
        then decide0;
            if equipementRobot then arreterRobotsLigne;
            if equipementFixe then signalerZoneIntervention;
        succession arreterRobotsLigne then autoriserAccesTrajet;
        succession autoriserAccesTrajet then merge1;
        succession signalerZoneIntervention then merge1;
        succession merge1 then lancerTest;
        then decide1;
            if testReussi then remettreEnService;
            if testEchoue then enregistrerPanne;
        succession remettreEnService then mettreAJourPlanCapacite;
        succession mettreAJourPlanCapacite then merge2;
        succession enregistrerPanne then maintenirHorsService;
        succession maintenirHorsService then merge2;
        succession merge2 then enregistrerIntervention;
        then decide2;
            if autreEquipement then actualiserListe;
            if finIntervention then cloturerIntervention;
        succession actualiserListe then merge0;
        succession cloturerIntervention then done;
    }

    /* composants découverts lors de l'exploration des scénarios */
    package composants {
        part def TerminalMaintenance;
        part def AccesTrajetSecurise;
        part def JournalMaintenance;

        /* données échangées (payloads des messages) */
        part def ListeEquipements;
        part def Equipement;
        part def ResultatTest;
        part def Intervention;
    }

    package sequences {
        private import parkingConseil::parts::CapteursPlaces;
        private import parkingConseil::parts::Superviseur;
        private import parkingConseil::parts::PanneauAffichage;
        private import seance2Cherif::composants::*;
        private import seance2Zarrouki::composants::*;
        private import seance2ZarroukiMaintenance::composants::*;

        /* S1 : capteur de place remis en service après un test réussi */
        occurrence maintenirEquipementsS1 {
            part terminalMaintenance : TerminalMaintenance;
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part panneauAffichage : PanneauAffichage;
            part capteursPlaces : CapteursPlaces;
            part journalMaintenance : JournalMaintenance;
            message ouvrirIntervention from terminalMaintenance to superviseur;
            message listeDefauts of ListeEquipements from superviseur to terminalMaintenance;
            message mettreHorsService of Equipement from terminalMaintenance to superviseur;
            message neutraliserPlace of Place from superviseur to serveurReservation;
            message signalerZone of Place from superviseur to panneauAffichage;
            message lancerTest of Equipement from terminalMaintenance to capteursPlaces;
            message resultatTest of ResultatTest from capteursPlaces to terminalMaintenance;
            message remettreEnService of Equipement from terminalMaintenance to superviseur;
            message retablirPlace of Place from superviseur to serveurReservation;
            message enregistrerIntervention of Intervention from terminalMaintenance to journalMaintenance;
            message from journalMaintenance to terminalMaintenance;
        }
        /* S2 : maintenance d'un robot, accès au trajet sécurisé, test réussi */
        occurrence maintenirEquipementsS2 {
            part terminalMaintenance : TerminalMaintenance;
            part superviseur : Superviseur;
            part gestionRecharge : GestionRecharge;
            part robotRecharge : RobotRecharge;
            part accesTrajetSecurise : AccesTrajetSecurise;
            part journalMaintenance : JournalMaintenance;

            message ouvrirIntervention from terminalMaintenance to superviseur;
            message listeDefauts of ListeEquipements from superviseur to terminalMaintenance;
            message mettreHorsService of Equipement from terminalMaintenance to superviseur;
            message reduireCapacite of Equipement from superviseur to gestionRecharge;
            message arreterRobots from gestionRecharge to robotRecharge;
            message robotsArretes from robotRecharge to gestionRecharge;
            message deverrouillerAcces from gestionRecharge to accesTrajetSecurise;
            message from accesTrajetSecurise to gestionRecharge;
            message lancerTest of Equipement from terminalMaintenance to robotRecharge;
            message resultatTest of ResultatTest from robotRecharge to terminalMaintenance;
            message remettreEnService of Equipement from terminalMaintenance to gestionRecharge;
            message capaciteRetablie from gestionRecharge to superviseur;
            message enregistrerIntervention of Intervention from terminalMaintenance to journalMaintenance;
            message from journalMaintenance to terminalMaintenance;
        }

        /* S3 : test échoué sur un capteur de place, équipement laissé hors service */
        occurrence maintenirEquipementsS3 {
            part terminalMaintenance : TerminalMaintenance;
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part capteursPlaces : CapteursPlaces;
            part journalMaintenance : JournalMaintenance;

            message ouvrirIntervention from terminalMaintenance to superviseur;
            message listeDefauts of ListeEquipements from superviseur to terminalMaintenance;
            message mettreHorsService of Equipement from terminalMaintenance to superviseur;
            message neutraliserPlace of Place from superviseur to serveurReservation;
            message lancerTest of Equipement from terminalMaintenance to capteursPlaces;
            message resultatTest of ResultatTest from capteursPlaces to terminalMaintenance;
            message enregistrerPanne of Intervention from terminalMaintenance to journalMaintenance;
            message from journalMaintenance to terminalMaintenance;
        }
        /* S4 : plusieurs équipements traités dans la même intervention */
        occurrence maintenirEquipementsS4 {
            part terminalMaintenance : TerminalMaintenance;
            part superviseur : Superviseur;
            part journalMaintenance : JournalMaintenance;
            /* traitement de chaque équipement : identique à S1 ou S2, non répété */
            message enregistrerIntervention of Intervention from terminalMaintenance to journalMaintenance;
            message from journalMaintenance to terminalMaintenance;
            message actualiserListe from terminalMaintenance to superviseur;
            message listeDefauts of ListeEquipements from superviseur to terminalMaintenance;
            message mettreHorsService of Equipement from terminalMaintenance to superviseur;
            message cloturerIntervention of Intervention from terminalMaintenance to journalMaintenance;
            message from journalMaintenance to terminalMaintenance;
        }
    }
}
