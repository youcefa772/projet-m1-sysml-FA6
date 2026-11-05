package interconnexionsAchats {
    doc /* Séance 3 (AMROUCH) : vue des interconnexions de Shopping Assist */
    private import parkingAchats::parts::*;
    private import composantsAchats::parts::*;

    part shoppingAssist : ShoppingAssist {
        part tabletteBoutique : TabletteBoutique {
            inout port reseau;
        }
        part serveur : ServeurShopping {
            inout port reseauBoutiques;
            inout port reseauConsignes;
            out port notification;
        }
        part consigneCasiers : ConsigneCasiers {
            inout port reseau;
            part lecteurCode : LecteurCode {
                out port code;
            }
            part casier : Casier {
                in port ouverture;
            }
        }

        connect tabletteBoutique.reseau to serveur.reseauBoutiques;
        connect serveur.reseauConsignes to consigneCasiers.reseau;
        connect consigneCasiers.lecteurCode.code to consigneCasiers.reseau;
        connect consigneCasiers.reseau to consigneCasiers.casier.ouverture;
    }
}
