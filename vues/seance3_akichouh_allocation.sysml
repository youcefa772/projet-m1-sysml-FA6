package allocationConseil {
    doc /* Séance 3 (AKICHOUH) : allocation des actions de la séance 2 aux composants */
    private import parkingConseil::actions::*;
    private import materielDetectionGuidage::*;

    /* obtenirConseilStationnement */
    allocate obtenirConseilStationnement.mesurerOccupation to parking.detectionGuidage.capteursPlaces;
    allocate obtenirConseilStationnement.prevoirOccupation to parking.serveurCentral.modulePrevision;
    allocate obtenirConseilStationnement.calculerTempsTotalParZone to parking.serveurCentral.moduleRecommandation;
    allocate obtenirConseilStationnement.recommanderZoneEtEntree to parking.serveurCentral.moduleRecommandation;
    allocate obtenirConseilStationnement.afficherRecommandation to parking.detectionGuidage.panneauxLumineux;

    /* retrouverVehicule */
    allocate retrouverVehicule.verifierQRCode to parking.serveurCentral.superviseur;
    allocate retrouverVehicule.localiserVehicule to parking.detectionGuidage.camerasZone;
    // afficherRefus et afficherPlaceEtChemin sont réalisées par la borne client,
    // qui appartient au sous-système Bornes et retrait (AMROUCH) : à allouer avec lui
}