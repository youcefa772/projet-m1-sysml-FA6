/*
 * Mini-projet SysML - Séance 3 : matrice d'allocation (CHERIF Ayman)
 * Allocation fonctionnelle : chaque action des flux de la séance 2 (reserverPlace,
 * accederAuParking, superviserExploitation) est affectée au composant matériel ou au
 * module du serveur central qui la réalise (vues/seance3_cherif.sysml).
 * Les actions affichées dans l'application des visiteurs sont allouées au serveur de
 * réservation, qui les produit : le téléphone est un élément extérieur du contexte.
 */
package allocationReservationAcces {
    private import seance2Cherif::reserverPlace;
    private import seance2CherifAcces::accederAuParking;
    private import seance2CherifSupervision::superviserExploitation;
    private import materielReservationAcces::parking;

    /* reserverPlace */
    allocate reserverPlace.afficherPlan to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.verifierDisponibilite to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.signalerPlaceIndisponible to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.afficherPlaqueDeclaree to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.enregistrerReservation to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.marquerPlaceReservee to parking.reservationAcces.barrieresPlace;
    allocate reserverPlace.envoyerConfirmation to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.afficherReservation to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.chargerReservationEnCours to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.prolongerMaintienPlace to parking.serveurCentral.gestionDelais;
    allocate reserverPlace.confirmerAnnulation to parking.serveurCentral.serveurReservation;
    allocate reserverPlace.debiterFraisNonVenue to parking.serveurCentral.modulePaiement;
    allocate reserverPlace.libererPlace to parking.reservationAcces.barrieresPlace;
    allocate reserverPlace.crediterPointsFidelite to parking.serveurCentral.compteFidelite;

    /* accederAuParking */
    allocate accederAuParking.lirePlaqueEntree to materielDetectionGuidage::parking.detectionGuidage.lecteursPlaques;
    allocate accederAuParking.imprimerTicketQR to parking.reservationAcces.distributeursTickets;
    allocate accederAuParking.ouvrirBarriereEntree to parking.reservationAcces.barrieresEntree;
    allocate accederAuParking.demanderCodeQR to parking.reservationAcces.controlesAccesNiveau2;
    allocate accederAuParking.lireQRApplication to parking.reservationAcces.controlesAccesNiveau2;
    allocate accederAuParking.refuserAccesNiveau2 to parking.reservationAcces.controlesAccesNiveau2;
    allocate accederAuParking.ouvrirAccesNiveau2 to parking.reservationAcces.controlesAccesNiveau2;
    allocate accederAuParking.guiderVersPlace to parking.serveurCentral.serveurReservation;
    allocate accederAuParking.lirePlaquePlace to parking.reservationAcces.barrieresPlace;
    allocate accederAuParking.maintenirBarriereLevee to parking.reservationAcces.barrieresPlace;
    allocate accederAuParking.abaisserBarrierePlace to parking.reservationAcces.barrieresPlace;
    allocate accederAuParking.signalerArrivee to parking.serveurCentral.serveurReservation;
    allocate accederAuParking.mettreAJourPlan to parking.serveurCentral.serveurReservation;
    allocate accederAuParking.proposerAssistance to parking.reservationAcces.interphones;
    allocate accederAuParking.demanderCarte to parking.reservationAcces.lecteursCarte;
    allocate accederAuParking.lireCartePersonnelle to parking.reservationAcces.lecteursCarte;
    allocate accederAuParking.refuserAccesNiveau3 to parking.reservationAcces.lecteursCarte;
    allocate accederAuParking.ouvrirAccesNiveau3 to parking.reservationAcces.lecteursCarte;

    /* superviserExploitation */
    allocate superviserExploitation.collecterEtat to parking.serveurCentral.superviseur;
    allocate superviserExploitation.afficherTableauBord to parking.posteSupervision;
    allocate superviserExploitation.afficherAlerteSaturation to parking.posteSupervision;
    allocate superviserExploitation.afficherIncident to parking.posteSupervision;
    allocate superviserExploitation.localiserIncident to parking.serveurCentral.superviseur;
    allocate superviserExploitation.mettreEnRelationInterphone to parking.reservationAcces.interphones;
    allocate superviserExploitation.marquerIncidentPrisEnCompte to parking.posteSupervision;
    allocate superviserExploitation.enregistrerTraitement to parking.serveurCentral.journalIncidents;
    allocate superviserExploitation.couperToutesCharges to parking.posteSupervision;
    allocate superviserExploitation.confirmerCoupure to parking.posteSupervision;
    allocate superviserExploitation.appliquerParametres to parking.serveurCentral.superviseur;
}
