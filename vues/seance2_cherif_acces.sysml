/*
 * Mini-projet SysML - Séance 2 : flux d'actions et séquences (CHERIF Ayman)
 * Cas d'utilisation : accederAuParking (package parkingIntelligentV2::useCases)
 * Exigences détaillées : controleAcces, accesNiveauReserve, protectionPlace,
 * niveauEmployes, planTempsReel, interphone
 * Point de vue : celui du système ; les gardes sont des attributs booléens.
 * Une action sépare toujours deux nœuds de contrôle (decide / merge), comme dans le corrigé.
 * Séquences : un scénario par cheminement du flux, S1 à S6 ; les lignes de vie sont des composants du système, sans acteur.
 * Réutilise LecteurPlaques et Superviseur (parkingConseil, AKICHOUH), les composants
 * de seance2Cherif et PosteSupervision (seance2Zarrouki).
 */
package seance2CherifAcces {
    private import ScalarValues::Boolean;

    action accederAuParking {
        attribute vehiculePresente : Boolean;
        attribute versNiveau1 : Boolean;
        attribute versNiveau2 : Boolean;
        attribute versNiveau3 : Boolean;
        attribute qrPresente : Boolean;
        attribute qrValide : Boolean;
        attribute qrInvalide : Boolean;
        attribute vehiculeSurPlace : Boolean;
        attribute plaqueAttendue : Boolean;
        attribute plaqueNonReconnue : Boolean;
        attribute cartePresentee : Boolean;
        attribute carteValide : Boolean;
        attribute carteInvalide : Boolean;

        action lirePlaqueEntree;
        action imprimerTicketQR;
        action ouvrirBarriereEntree;
        action demanderCodeQR;
        action lireQRApplication;
        action refuserAccesNiveau2;
        action ouvrirAccesNiveau2;
        action guiderVersPlace;
        action lirePlaquePlace;
        action maintenirBarriereLevee;
        action abaisserBarrierePlace;
        action signalerArrivee;
        action mettreAJourPlan;
        action proposerAssistance;
        action demanderCarte;
        action lireCartePersonnelle;
        action refuserAccesNiveau3;
        action ouvrirAccesNiveau3;
        merge merge0;
        decide decide0;
        decide decide1;
        decide decide2;
        decide decide3;

        first start;
        succession start if vehiculePresente then lirePlaqueEntree;
        succession lirePlaqueEntree then imprimerTicketQR;
        succession imprimerTicketQR then ouvrirBarriereEntree;
        then decide0;
            if versNiveau1 then done;
            if versNiveau2 then demanderCodeQR;
            if versNiveau3 then demanderCarte;
        succession proposerAssistance then done;    
        succession demanderCodeQR if qrPresente then lireQRApplication;
        then decide1;
            if qrInvalide then refuserAccesNiveau2;
            if qrValide then ouvrirAccesNiveau2;
        succession ouvrirAccesNiveau2 then guiderVersPlace;
        succession guiderVersPlace if vehiculeSurPlace then lirePlaquePlace;
        then decide2;
            if plaqueNonReconnue then maintenirBarriereLevee;
            if plaqueAttendue then abaisserBarrierePlace;
        succession abaisserBarrierePlace then signalerArrivee;
        succession signalerArrivee then mettreAJourPlan;
        succession mettreAJourPlan then done;
        succession demanderCarte if cartePresentee then lireCartePersonnelle;
        then decide3;
            if carteInvalide then refuserAccesNiveau3;
            if carteValide then ouvrirAccesNiveau3;
        succession refuserAccesNiveau3 then done;
        succession ouvrirAccesNiveau3 then done;
        succession refuserAccesNiveau2 then merge0;
        succession maintenirBarriereLevee then merge0;
        succession merge0 then proposerAssistance;
    }

    /* composants découverts lors de l'exploration des scénarios (corrigé TD4) */
    package composants {
        part def DistributeurTickets;
        part def BarriereEntree;
        part def LecteurCarte;
        part def Interphone;

        /* données échangées (payloads des messages) */
        part def TicketQR;
        part def CodeQR;
        part def CartePersonnelle;
    }

    package sequences {
        private import parkingConseil::parts::LecteurPlaques;
        private import parkingConseil::parts::Superviseur;
        private import seance2Cherif::composants::*;
        private import seance2Zarrouki::composants::PosteSupervision;
        private import seance2CherifAcces::composants::*;

        /* S1 : accès au niveau 2, QR valide et plaque reconnue */
        occurrence accederAuParkingS1 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part distributeurTickets : DistributeurTickets;
            part barriereEntree : BarriereEntree;
            part controleAccesNiveau2 : ControleAccesNiveau2;
            part serveurReservation : ServeurReservation;
            part appReservation : AppReservation;
            part barrierePlace : BarrierePlace;

            message vehiculeArrive of Plaque from lecteurPlaques to superviseur;
            message imprimerTicket of TicketQR from superviseur to distributeurTickets;
            message ticketImprime of TicketQR from distributeurTickets to superviseur;
            message ouvrirEntree from superviseur to barriereEntree;
            message qrLu of CodeQR from controleAccesNiveau2 to serveurReservation;
            message ouvrirNiveau2 from serveurReservation to controleAccesNiveau2;
            message guiderVersPlace of Place from serveurReservation to appReservation;
            message plaqueLue of Plaque from barrierePlace to serveurReservation;
            message abaisserBarriere from serveurReservation to barrierePlace;
            message mettreAJourPlan of EtatPlaces from serveurReservation to appReservation;
            message from barrierePlace to serveurReservation;
        }

        /* S2 : code QR invalide au niveau 2, assistance proposée */
        occurrence accederAuParkingS2 {
            part controleAccesNiveau2 : ControleAccesNiveau2;
            part serveurReservation : ServeurReservation;
            part appReservation : AppReservation;
            part interphone : Interphone;
            part posteSupervision : PosteSupervision;
            /* entrée générale : identique à S1, non répétée */
            message qrLu of CodeQR from controleAccesNiveau2 to serveurReservation;
            message qrInvalide of CodeQR from serveurReservation to controleAccesNiveau2;
            message proposerAssistance of Notification from serveurReservation to appReservation;
            message activerInterphone from serveurReservation to interphone;
            message appelAgent from interphone to posteSupervision;
            message from posteSupervision to interphone;
        }
        /* S3 : plaque non reconnue par la barrière de place, assistance proposée */
        occurrence accederAuParkingS3 {
            part barrierePlace : BarrierePlace;
            part serveurReservation : ServeurReservation;
            part appReservation : AppReservation;
            part interphone : Interphone;
            part posteSupervision : PosteSupervision;

            /* entrée et accès au niveau 2 : identiques à S1, non répétés */
            message plaqueLue of Plaque from barrierePlace to serveurReservation;
            message maintenirLevee from serveurReservation to barrierePlace;
            message proposerAssistance of Notification from serveurReservation to appReservation;
            message activerInterphone from serveurReservation to interphone;
            message appelAgent from interphone to posteSupervision;
            message from posteSupervision to interphone;
            message from interphone to barrierePlace;
        }

        /* S4 : visiteur sans réservation, accès libre au niveau 1 */
        occurrence accederAuParkingS4 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part distributeurTickets : DistributeurTickets;
            part barriereEntree : BarriereEntree;
            message vehiculeArrive of Plaque from lecteurPlaques to superviseur;
            message imprimerTicket of TicketQR from superviseur to distributeurTickets;
            message ticketImprime of TicketQR from distributeurTickets to superviseur;
            message ouvrirEntree from superviseur to barriereEntree;
            message from barriereEntree to superviseur;
        }
        /* S5 : employé, carte valide, accès au niveau 3 */
        occurrence accederAuParkingS5 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part distributeurTickets : DistributeurTickets;
            part barriereEntree : BarriereEntree;
            part lecteurCarte : LecteurCarte;

            message vehiculeArrive of Plaque from lecteurPlaques to superviseur;
            message imprimerTicket of TicketQR from superviseur to distributeurTickets;
            message ticketImprime of TicketQR from distributeurTickets to superviseur;
            message ouvrirEntree from superviseur to barriereEntree;
            message carteLue of CartePersonnelle from lecteurCarte to superviseur;
            message ouvrirNiveau3 from superviseur to lecteurCarte;
            message from lecteurCarte to superviseur;
        }

        /* S6 : carte invalide, accès au niveau 3 refusé */
        occurrence accederAuParkingS6 {
            part lecteurCarte : LecteurCarte;
            part superviseur : Superviseur;
            /* entrée générale : identique à S5, non répétée */
            message carteLue of CartePersonnelle from lecteurCarte to superviseur;
            message refuserNiveau3 of CartePersonnelle from superviseur to lecteurCarte;
            message from lecteurCarte to superviseur;
        }
    }
}
