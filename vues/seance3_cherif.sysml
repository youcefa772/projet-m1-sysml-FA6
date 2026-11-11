/*
 * Mini-projet SysML - Séance 3 : décomposition matérielle et interconnexions (CHERIF Ayman)
 * Sous-système : Réservation, accès et sortie, et poste de supervision
 * Les types des composants sont ceux découverts dans les séquences de la séance 2
 * (seance2Cherif, seance2CherifAcces, seance2CherifSupervision, seance2ZarroukiPaiement) ;
 * les ports sont déduits des messages échangés dans ces séquences.
 * Style repris de vues/seance3_akichouh.sysml (même serveur central partagé).
 */
package materielReservationAcces {
    private import parkingIntelligentV2::parts::ParkingIntelligent;
    private import materielDetectionGuidage::parts::ServeurCentral;
    private import parkingConseil::parts::Superviseur;
    private import seance2Cherif::composants::*;
    private import seance2CherifAcces::composants::*;
    private import seance2CherifSupervision::composants::*;
    private import seance2ZarroukiPaiement::composants::*;
    private import seance2Zarrouki::composants::PosteSupervision;

    package parts {
        part def ReservationAcces {
            doc /* sous-système qui contrôle l'accès aux niveaux, protège les places
                   réservées du niveau 2 et gère la sortie et son paiement */
        }
    }

    private import materielReservationAcces::parts::*;

    /* vue générale hiérarchique et vue d'interconnexion */
    part parking : ParkingIntelligent {

        part reservationAcces : ReservationAcces {
            // entrée générale : ticket QR de visite (accederAuParkingS1)
            part distributeursTickets : DistributeurTickets [1..*] {
                inout port ticket;
            }
            part barrieresEntree : BarriereEntree [1..*] {
                in port commande;
            }
            // niveau 2 : lecture du code QR de l'application (accederAuParkingS1)
            part controlesAccesNiveau2 : ControleAccesNiveau2 [1..*] {
                inout port codeQR;
            }
            // niveau 3 : carte personnelle des employés (accederAuParkingS5)
            part lecteursCarte : LecteurCarte [1..*] {
                inout port carte;
            }
            // une barrière par place réservée du niveau 2 (reserverPlaceS1, accederAuParkingS1)
            part barrieresPlace : BarrierePlace [*] {
                inout port plaque;
            }
            // sortie (payerEtSortirS1 et S5)
            part barrieresSortie : BarriereSortie [1..*] {
                in port commande;
            }
            part bornesSortie : BorneSortie [1..*] {
                inout port paiement;
            }
            // assistance aux usagers (accederAuParkingS3)
            part interphones : Interphone [1..*] {
                in port activation;
                inout port audio;
            }
        }

        // poste d'exploitation de l'agent (superviserExploitationS2 et S3)
        part posteSupervision : PosteSupervision {
            inout port supervision;
            inout port audio;
        }

        // le serveur central est commun à tous les sous-systèmes ;
        // seuls les modules et les ports utiles à ce sous-système sont montrés ici
        part serveurCentral : ServeurCentral {
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part gestionDelais : GestionDelais;
            part compteFidelite : CompteFidelite;
            part modulePaiement : ModulePaiement;
            part journalIncidents : JournalIncidents;

            inout port tickets;
            out port commandeEntree;
            inout port codeQR;
            inout port carte;
            inout port plaquePlace;
            out port commandeSortie;
            inout port paiementSortie;
            out port activationInterphone;
            inout port supervision;
            // vers les éléments extérieurs du contexte : application des visiteurs
            // (téléphone) et prestataire de paiement
            inout port application;
            inout port prestatairePaiement;
        }

        // une connexion par échange identifié dans les séquences de la séance 2
        connect reservationAcces.distributeursTickets.ticket to serveurCentral.tickets;
        connect serveurCentral.commandeEntree to reservationAcces.barrieresEntree.commande;
        connect reservationAcces.controlesAccesNiveau2.codeQR to serveurCentral.codeQR;
        connect reservationAcces.lecteursCarte.carte to serveurCentral.carte;
        connect reservationAcces.barrieresPlace.plaque to serveurCentral.plaquePlace;
        connect serveurCentral.commandeSortie to reservationAcces.barrieresSortie.commande;
        connect reservationAcces.bornesSortie.paiement to serveurCentral.paiementSortie;
        connect serveurCentral.activationInterphone to reservationAcces.interphones.activation;
        connect reservationAcces.interphones.audio to posteSupervision.audio;
        connect posteSupervision.supervision to serveurCentral.supervision;
    }
}
