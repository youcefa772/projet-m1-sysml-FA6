package composantsAchats {
    doc /*
     * Séance 3 (AMROUCH) : dépôt et retrait des achats (Shopping Assist)
     * Vue générale : décomposition hiérarchique des composants
     */
    private import parkingAchats::parts::*;

    package parts {
        part def ShoppingAssist;
        part def ServeurShopping;
        part def LecteurCode;
        part def EcranConsigne;
    }

    private import composantsAchats::parts::*;

    part shoppingAssist : ShoppingAssist {
        part tabletteBoutique : TabletteBoutique [*];
        part serveur : ServeurShopping {
            part logicielRetrait : LogicielRetrait;
            part journalRetraits : JournalRetraits;
            part moduleNotification : ModuleNotification;
        }
        part consigneCasiers : ConsigneCasiers [3] {
            part casier : Casier [*];
            part lecteurCode : LecteurCode;
            part ecran : EcranConsigne;
        }
    }
}
