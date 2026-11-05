package allocationAchats {
    doc /* Séance 3 (AMROUCH) : allocation des actions de la séance 2 aux composants */
    private import parkingAchats::actions::*;
    private import composantsAchats::*;

    /* deposerAchats */
    allocate deposerAchats.identifierClient to shoppingAssist.tabletteBoutique;
    allocate deposerAchats.creerCommande to shoppingAssist.serveur.logicielRetrait;
    allocate deposerAchats.retrouverCommande to shoppingAssist.serveur.logicielRetrait;
    allocate deposerAchats.etiqueterLot to shoppingAssist.tabletteBoutique;
    allocate deposerAchats.enregistrerDepot to shoppingAssist.serveur.logicielRetrait;
    allocate deposerAchats.confirmerDepot to shoppingAssist.serveur.moduleNotification;

    /* retirerAchats */
    allocate retirerAchats.verifierCode to shoppingAssist.serveur.logicielRetrait;
    allocate retirerAchats.afficherRefus to shoppingAssist.consigneCasiers.ecran;
    allocate retirerAchats.ouvrirCasier to shoppingAssist.consigneCasiers.casier;
    allocate retirerAchats.confirmerRemise to shoppingAssist.serveur.moduleNotification;
    allocate retirerAchats.journaliserRetrait to shoppingAssist.serveur.journalRetraits;
}
