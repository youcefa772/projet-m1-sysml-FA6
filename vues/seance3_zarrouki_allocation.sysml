/*
 * Mini-projet SysML - Séance 3 : matrice d'allocation (ZARROUKI Ahmed)
 * Allocation fonctionnelle : chaque action des flux de la séance 2 (demanderRecharge,
 * payerEtSortir, maintenirEquipements) est affectée au composant matériel ou au module
 * du serveur central qui la réalise. Les composants viennent de vues/seance3_zarrouki.sysml
 * et, pour l'accès, la sortie et la détection, de vues/seance3_cherif.sysml et
 * vues/seance3_akichouh.sysml (noms qualifiés).
 * Les actions affichées dans l'application des visiteurs sont allouées au module qui les
 * produit : le téléphone est un élément extérieur du contexte.
 */
package allocationRechargeMaintenance {
    private import seance2Zarrouki::demanderRecharge;
    private import seance2ZarroukiPaiement::payerEtSortir;
    private import seance2ZarroukiMaintenance::maintenirEquipements;
    private import materielRechargeMaintenance::parking;

    /* demanderRecharge */
    allocate demanderRecharge.verifierCapaciteLigne to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.proposerAutreLigne to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.calculerPrixOption to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.afficherPrixOption to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.enregistrerOption to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.planifierIntervention to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.envoyerRobot to parking.recharge.robotsRecharge;
    allocate demanderRecharge.connecterRobot to parking.recharge.robotsRecharge;
    allocate demanderRecharge.alerterAgent to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.demarrerRecharge to parking.recharge.robotsRecharge;
    allocate demanderRecharge.afficherAvancement to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.notifierFinRecharge to parking.serveurCentral.gestionRecharge;
    allocate demanderRecharge.couperRecharge to parking.recharge.reservesEnergie;
    allocate demanderRecharge.deconnecterRobot to parking.recharge.robotsRecharge;
    allocate demanderRecharge.ramenerRobotBase to parking.recharge.robotsRecharge;
    allocate demanderRecharge.rechargerRobot to parking.recharge.reservesEnergie;
    allocate demanderRecharge.enregistrerEnergieDelivree to parking.serveurCentral.gestionRecharge;

    /* payerEtSortir */
    allocate payerEtSortir.detecterDepart to materielDetectionGuidage::parking.detectionGuidage.capteursPlaces;
    allocate payerEtSortir.releverBarrierePlace to materielReservationAcces::parking.reservationAcces.barrieresPlace;
    allocate payerEtSortir.libererPlacePlan to materielReservationAcces::parking.serveurCentral.serveurReservation;
    allocate payerEtSortir.mettreAJourOccupation to materielReservationAcces::parking.serveurCentral.superviseur;
    allocate payerEtSortir.lirePlaqueSortie to materielDetectionGuidage::parking.detectionGuidage.lecteursPlaques;
    allocate payerEtSortir.identifierUsager to materielReservationAcces::parking.serveurCentral.superviseur;
    allocate payerEtSortir.verifierDroitEmploye to materielReservationAcces::parking.serveurCentral.superviseur;
    allocate payerEtSortir.calculerMontant to materielReservationAcces::parking.serveurCentral.serveurReservation;
    allocate payerEtSortir.debiterApplication to materielReservationAcces::parking.serveurCentral.modulePaiement;
    allocate payerEtSortir.envoyerRecu to materielReservationAcces::parking.serveurCentral.serveurReservation;
    allocate payerEtSortir.signalerRefusDebit to materielReservationAcces::parking.serveurCentral.serveurReservation;
    allocate payerEtSortir.lireTicketQR to materielReservationAcces::parking.reservationAcces.bornesSortie;
    allocate payerEtSortir.verifierTicket to materielReservationAcces::parking.serveurCentral.superviseur;
    allocate payerEtSortir.validerSortie to materielReservationAcces::parking.serveurCentral.superviseur;
    allocate payerEtSortir.afficherMontantDu to materielReservationAcces::parking.reservationAcces.bornesSortie;
    allocate payerEtSortir.encaisserBorne to materielReservationAcces::parking.reservationAcces.bornesSortie;
    allocate payerEtSortir.editerRecu to materielReservationAcces::parking.reservationAcces.bornesSortie;
    allocate payerEtSortir.mettreEnRelationInterphone to materielReservationAcces::parking.reservationAcces.interphones;
    allocate payerEtSortir.ouvrirBarriereSortie to materielReservationAcces::parking.reservationAcces.barrieresSortie;
    allocate payerEtSortir.enregistrerSortie to materielReservationAcces::parking.serveurCentral.superviseur;

    /* maintenirEquipements */
    allocate maintenirEquipements.listerEquipementsADefaut to parking.terminalMaintenance;
    allocate maintenirEquipements.mettreHorsService to parking.terminalMaintenance;
    // une place neutralisée (équipement fixe) ou une capacité réduite (robot) : deux composants
    allocate maintenirEquipements.neutraliserPlaceOuCapacite to materielReservationAcces::parking.serveurCentral.serveurReservation;
    allocate maintenirEquipements.neutraliserPlaceOuCapacite to parking.serveurCentral.gestionRecharge;
    allocate maintenirEquipements.arreterRobotsLigne to parking.serveurCentral.gestionRecharge;
    allocate maintenirEquipements.autoriserAccesTrajet to parking.recharge.accesTrajetSecurise;
    allocate maintenirEquipements.signalerZoneIntervention to materielDetectionGuidage::parking.detectionGuidage.panneauxLumineux;
    allocate maintenirEquipements.lancerTest to parking.terminalMaintenance;
    allocate maintenirEquipements.remettreEnService to parking.terminalMaintenance;
    allocate maintenirEquipements.mettreAJourPlanCapacite to parking.serveurCentral.gestionRecharge;
    allocate maintenirEquipements.enregistrerPanne to parking.serveurCentral.journalMaintenance;
    allocate maintenirEquipements.maintenirHorsService to parking.serveurCentral.gestionRecharge;
    allocate maintenirEquipements.enregistrerIntervention to parking.serveurCentral.journalMaintenance;
    allocate maintenirEquipements.actualiserListe to parking.terminalMaintenance;
    allocate maintenirEquipements.cloturerIntervention to parking.terminalMaintenance;
}
