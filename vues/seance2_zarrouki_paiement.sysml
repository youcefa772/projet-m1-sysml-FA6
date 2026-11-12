/*
 * Mini-projet SysML - Séance 2 : flux d'actions et séquences (ZARROUKI Ahmed)
 * Cas d'utilisation : payerEtSortir (package parkingIntelligentV2::useCases)
 * Exigences détaillées : tarification, paiementUnique, fideliteReservation,
 * protectionPlace, planTempsReel, niveauEmployes, interphone
 * Point de vue : celui du système ; les gardes sont des attributs booléens.
 * Une action sépare toujours deux nœuds de contrôle (decide / merge), comme dans le corrigé.
 * Séquences : un scénario par cheminement du flux, S1 à S7 ; les lignes de vie sont des composants du système, sans acteur.
 * Réutilise CapteursPlaces, LecteurPlaques et Superviseur (parkingConseil, AKICHOUH),
 * les composants de seance2Cherif et TicketQR (seance2CherifAcces).
 */
package seance2ZarroukiPaiement {
    private import ScalarValues::Boolean;

    action payerEtSortir {
        attribute vehiculeParti : Boolean;
        attribute placeReservee : Boolean;
        attribute placeNonReservee : Boolean;
        attribute vehiculeEnSortie : Boolean;
        attribute usagerEmploye : Boolean;
        attribute usagerReservation : Boolean;
        attribute usagerNiveau1 : Boolean;
        attribute debitAccepte : Boolean;
        attribute debitRefuse : Boolean;
        attribute sortieAutorisee : Boolean;
        attribute paiementRequis : Boolean;
        attribute paiementValide : Boolean;
        attribute paiementEchoue : Boolean;

        action detecterDepart;
        action releverBarrierePlace;
        action libererPlacePlan;
        action mettreAJourOccupation;
        action lirePlaqueSortie;
        action identifierUsager;
        action verifierDroitEmploye;
        action calculerMontant;
        action debiterApplication;
        action envoyerRecu;
        action signalerRefusDebit;
        action lireTicketQR;
        action verifierTicket;
        action validerSortie;
        action afficherMontantDu;
        action encaisserBorne;
        action editerRecu;
        action mettreEnRelationInterphone;
        action ouvrirBarriereSortie;
        action enregistrerSortie;
        merge merge0;
        merge merge1;
        merge merge2;
        decide decide0;
        decide decide1;
        decide decide2;
        decide decide3;
        decide decide4;

        first start;
        succession start if vehiculeParti then detecterDepart;
        then decide0;
            if placeReservee then releverBarrierePlace;
            if placeNonReservee then mettreAJourOccupation;
        succession releverBarrierePlace then libererPlacePlan;
        succession libererPlacePlan then merge0;
        succession mettreAJourOccupation then merge0;
        succession merge0 if vehiculeEnSortie then lirePlaqueSortie;
        succession lirePlaqueSortie then identifierUsager;
        then decide1;
            if usagerEmploye then verifierDroitEmploye;
            if usagerReservation then calculerMontant;
            if usagerNiveau1 then lireTicketQR;
        succession verifierDroitEmploye then merge1;
        succession calculerMontant then debiterApplication;
        then decide2;
            if debitAccepte then envoyerRecu;
            if debitRefuse then signalerRefusDebit;
        succession envoyerRecu then merge1;
        succession signalerRefusDebit then merge2;
        succession lireTicketQR then verifierTicket;
        then decide3;
            if sortieAutorisee then validerSortie;
            if paiementRequis then afficherMontantDu;
        succession validerSortie then merge1;
        succession afficherMontantDu then merge2;
        succession merge2 then encaisserBorne;
        then decide4;
            if paiementValide then editerRecu;
            if paiementEchoue then mettreEnRelationInterphone;
        succession editerRecu then merge1;
        succession mettreEnRelationInterphone then done;
        succession merge1 then ouvrirBarriereSortie;
        succession ouvrirBarriereSortie then enregistrerSortie;
        succession enregistrerSortie then done;
    }

    /* composants découverts lors de l'exploration des scénarios (corrigé TD4) */
    package composants {
        part def BarriereSortie;
        part def BorneSortie;

        /* données échangées (payloads des messages) */
        part def MontantDu;
    }

    package sequences {
        private import parkingConseil::parts::CapteursPlaces;
        private import parkingConseil::parts::LecteurPlaques;
        private import parkingConseil::parts::Superviseur;
        private import seance2Cherif::composants::*;
        private import seance2CherifAcces::composants::TicketQR;
        private import seance2ZarroukiPaiement::composants::*;
        private import seance2CherifAcces::composants::Interphone;
        private import seance2Zarrouki::composants::PosteSupervision;

        /* S1 : niveau 2, débit automatique par l'application */
        occurrence payerEtSortirS1 {
            part capteursPlaces : CapteursPlaces;
            part serveurReservation : ServeurReservation;
            part barrierePlace : BarrierePlace;
            part appReservation : AppReservation;
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part modulePaiement : ModulePaiement;
            part barriereSortie : BarriereSortie;

            message departDetecte of Place from capteursPlaces to serveurReservation;
            message releverBarriere from serveurReservation to barrierePlace;
            message libererPlace of EtatPlaces from serveurReservation to appReservation;
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message identifierReservation of Plaque from superviseur to serveurReservation;
            message debiter of MontantDu from serveurReservation to modulePaiement;
            message debitAccepte of MontantDu from modulePaiement to serveurReservation;
            message envoyerRecu of Notification from serveurReservation to appReservation;
            message sortieAutorisee from serveurReservation to superviseur;
            message ouvrirSortie from superviseur to barriereSortie;
            message from barriereSortie to superviseur;
        }

        /* S2 : niveau 2, débit refusé, paiement à la borne de sortie */
        occurrence payerEtSortirS2 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part modulePaiement : ModulePaiement;
            part appReservation : AppReservation;
            part borneSortie : BorneSortie;
            part barriereSortie : BarriereSortie;
            /* départ de la place : identique à S1, non répété */
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message identifierReservation of Plaque from superviseur to serveurReservation;
            message debiter of MontantDu from serveurReservation to modulePaiement;
            message debitRefuse of MontantDu from modulePaiement to serveurReservation;
            message signalerRefus of Notification from serveurReservation to appReservation;
            message paiementRequis of MontantDu from serveurReservation to superviseur;
            message afficherMontant of MontantDu from superviseur to borneSortie;
            message payer of MontantDu from borneSortie to modulePaiement;
            message paiementValide of MontantDu from modulePaiement to superviseur;
            message editerRecu from superviseur to borneSortie;
            message ouvrirSortie from superviseur to barriereSortie;
            message from barriereSortie to superviseur;
        }
        /* S3 : niveau 1, séjour de 15 min au plus, sortie gratuite */
        occurrence payerEtSortirS3 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part borneSortie : BorneSortie;
            part barriereSortie : BarriereSortie;
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message lireTicket of TicketQR from borneSortie to superviseur;
            message sortieGratuite from superviseur to borneSortie;
            message ouvrirSortie from superviseur to barriereSortie;
            message from barriereSortie to superviseur;
        }
        /* S4 : niveau 1, ticket déjà payé à la caisse automatique */
        occurrence payerEtSortirS4 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part borneSortie : BorneSortie;
            part modulePaiement : ModulePaiement;
            part barriereSortie : BarriereSortie;
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message lireTicket of TicketQR from borneSortie to superviseur;
            message verifierPaiement of TicketQR from superviseur to modulePaiement;
            message ticketPaye of TicketQR from modulePaiement to superviseur;
            message ouvrirSortie from superviseur to barriereSortie;
            message from barriereSortie to superviseur;
        }
        /* S5 : niveau 1, ticket non payé, paiement à la borne de sortie */
        occurrence payerEtSortirS5 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part borneSortie : BorneSortie;
            part modulePaiement : ModulePaiement;
            part barriereSortie : BarriereSortie;

            /* départ de la place : identique à S1 (place non réservée), non répété */
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message lireTicket of TicketQR from borneSortie to superviseur;
            message afficherMontant of MontantDu from superviseur to borneSortie;
            message payer of MontantDu from borneSortie to modulePaiement;
            message paiementValide of MontantDu from modulePaiement to superviseur;
            message editerRecu from superviseur to borneSortie;
            message ouvrirSortie from superviseur to barriereSortie;
            message from barriereSortie to superviseur;
        }
        /* S6 : employé, droit de sortie gratuite vérifié */
        occurrence payerEtSortirS6 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part barriereSortie : BarriereSortie;
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message identifierUsager of Plaque from superviseur to serveurReservation;
            message usagerEmploye of Plaque from serveurReservation to superviseur;
            message ouvrirSortie from superviseur to barriereSortie;
            message from barriereSortie to superviseur;
        }
        /* S7 : échec du paiement à la borne, mise en relation par interphone */
        occurrence payerEtSortirS7 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part borneSortie : BorneSortie;
            part modulePaiement : ModulePaiement;
            part interphone : Interphone;
            part posteSupervision : PosteSupervision;
            message vehiculeEnSortie of Plaque from lecteurPlaques to superviseur;
            message lireTicket of TicketQR from borneSortie to superviseur;
            message afficherMontant of MontantDu from superviseur to borneSortie;
            message payer of MontantDu from borneSortie to modulePaiement;
            message paiementEchoue of MontantDu from modulePaiement to superviseur;
            message mettreEnRelation from superviseur to interphone;
            message appelAgent from interphone to posteSupervision;
            message from posteSupervision to interphone;
        }
    }
}
