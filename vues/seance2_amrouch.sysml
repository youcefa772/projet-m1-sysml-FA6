package parkingAchats {
    doc /*
     * Mini-projet SysML - Séance 2 : travail individuel (AMROUCH)
     * Cas d'utilisation traités (issus de la vue des cas d'utilisation du groupe) :
     *  - deposerAchats
     *  - retirerAchats
     */
    private import ScalarValues::Boolean;

    /* composants découverts lors de l'exploration des scénarios */
    package parts {
        /* lignes de vie */
        part def TabletteBoutique;
        part def LogicielRetrait;
        part def ImprimanteEtiquettes;
        part def ConsigneCasiers;
        part def TelephoneClient;
        part def Message;

        /* payloads des messages */
        part def IdentifiantClient;
        part def Commande;
        part def Lot;
        part def Etiquette;
        part def CodeRetrait;
        part def Casier;
    }

    /* ===================== VUES DES FLUX D'ACTIONS ===================== */
    package actions {

        /* Le client confie ses achats à une boutique partenaire, qui les
         * étiquette et les associe à sa commande.
         * Exigences : enregistrementDepot, regroupementCommandes,
         * tracabiliteAchats. */
        action deposerAchats {
            attribute achatsConfies : Boolean;
            attribute nouvelleCommande : Boolean;
            attribute commandeExistante : Boolean;

            action identifierClient;
            action creerCommande;
            action retrouverCommande;
            action etiqueterLot;
            action enregistrerDepot;
            action confirmerDepot;
            decide decide0;
            merge merge0;

            first start;
            succession start if achatsConfies then identifierClient;
            then decide0;
                if nouvelleCommande then creerCommande;
                if commandeExistante then retrouverCommande;
            succession creerCommande then merge0;
            succession retrouverCommande then merge0;
            succession merge0 then etiqueterLot;
            then enregistrerDepot;
            then confirmerDepot;
            then done;
        }

        /* Le client retire en un seul passage ses achats regroupés au point
         * de retrait, avec un code à durée limitée.
         * Exigences : remiseBonClient, tracabiliteAchats, donneesPersonnelles. */
        action retirerAchats {
            attribute codeSaisi : Boolean;
            attribute codeValide : Boolean;
            attribute codeInvalide : Boolean;

            action verifierCode;
            action afficherRefus;
            action ouvrirCasier;
            action confirmerRemise;
            action journaliserRetrait;
            decide decide0;

            first start;
            succession start if codeSaisi then verifierCode;
            then decide0;
                if codeInvalide then afficherRefus;
                if codeValide then ouvrirCasier;
            succession afficherRefus then done;
            succession ouvrirCasier then confirmerRemise;
            then journaliserRetrait;
            then done;
        }
    }

    /* ======================== VUES DES SÉQUENCES ======================== */
    package sequences {
        private import parkingAchats::parts::*;

        /* deposerAchats - S1 : premier dépôt, nouvelle commande */
        occurrence deposerAchatsS1 {
            part tabletteBoutique : TabletteBoutique;
            part logicielRetrait : LogicielRetrait;
            part imprimanteEtiquettes : ImprimanteEtiquettes;
            part telephoneClient : TelephoneClient;

            message identifier of IdentifiantClient from tabletteBoutique to logicielRetrait;
            message creerCommande from logicielRetrait to logicielRetrait;
            message commande of Commande from logicielRetrait to tabletteBoutique;
            message imprimer of Lot from tabletteBoutique to imprimanteEtiquettes;
            message etiquette of Etiquette from imprimanteEtiquettes to tabletteBoutique;
            message enregistrer of Lot from tabletteBoutique to logicielRetrait;
            message confirmer of Commande from logicielRetrait to telephoneClient;
        }

        /* deposerAchats - S2 : dépôt ajouté à une commande existante */
        occurrence deposerAchatsS2 {
            part tabletteBoutique : TabletteBoutique;
            part logicielRetrait : LogicielRetrait;
            part imprimanteEtiquettes : ImprimanteEtiquettes;
            part telephoneClient : TelephoneClient;

            message identifier of IdentifiantClient from tabletteBoutique to logicielRetrait;
            message commande of Commande from logicielRetrait to tabletteBoutique;
            message imprimer of Lot from tabletteBoutique to imprimanteEtiquettes;
            message etiquette of Etiquette from imprimanteEtiquettes to tabletteBoutique;
            message enregistrer of Lot from tabletteBoutique to logicielRetrait;
            message confirmer of Commande from logicielRetrait to telephoneClient;
        }

        /* retirerAchats - S1 : code invalide ou expiré */
        occurrence retirerAchatsS1 {
            part consigneCasiers : ConsigneCasiers;
            part logicielRetrait : LogicielRetrait;
            part messageRefus : Message;

            message verifier of CodeRetrait from consigneCasiers to logicielRetrait;
            message afficher from logicielRetrait to messageRefus;
            message from messageRefus to logicielRetrait;
            message from logicielRetrait to consigneCasiers;
        }

        /* retirerAchats - S2 : code valide, casier ouvert, remise journalisée */
        occurrence retirerAchatsS2 {
            part consigneCasiers : ConsigneCasiers;
            part logicielRetrait : LogicielRetrait;
            part telephoneClient : TelephoneClient;

            message verifier of CodeRetrait from consigneCasiers to logicielRetrait;
            message ouvrir of Casier from logicielRetrait to consigneCasiers;
            message porteFermee from consigneCasiers to logicielRetrait;
            message journaliser from logicielRetrait to logicielRetrait;
            message confirmerRemise of Commande from logicielRetrait to telephoneClient;
        }
    }
}
