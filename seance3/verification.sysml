package verificationAchats {
    doc /* Séance 3 (AMROUCH) : satisfaction et vérification des exigences de Shopping Assist */
    private import parkingIntelligentV2::requirements::*;
    private import composantsAchats::*;
    private import composantsAchats::parts::*;

    /* composants qui satisfont les exigences */
    satisfy enregistrementDepot by shoppingAssist.tabletteBoutique;
    satisfy regroupementCommandes by shoppingAssist.serveur.logicielRetrait;
    satisfy notificationCommande by shoppingAssist.serveur.moduleNotification;
    satisfy notificationUsager by shoppingAssist.serveur.moduleNotification;
    satisfy remiseBonClient by shoppingAssist.consigneCasiers.lecteurCode;
    satisfy tracabiliteAchats by shoppingAssist.serveur.journalRetraits;
    satisfy accessibilite by shoppingAssist.consigneCasiers;

    /* cas qui vérifient les exigences */
    verification def TestDepot {
        subject sa : ShoppingAssist;
        objective {
            verify enregistrementDepot;
            verify regroupementCommandes;
        }
    }
    verification def TestNotification {
        subject sa : ShoppingAssist;
        objective {
            verify notificationCommande;
            verify notificationUsager;
        }
    }
    verification def TestRetrait {
        subject sa : ShoppingAssist;
        objective {
            verify remiseBonClient;
            verify tracabiliteAchats;
        }
    }
    verification def InspectionAccessibilite {
        subject sa : ShoppingAssist;
        objective {
            verify accessibilite;
        }
    }
}
