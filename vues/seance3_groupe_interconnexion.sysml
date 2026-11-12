/*
 * Mini-projet SysML - Séance 3 (travail de groupe) : vue d'interconnexion du système complet
 * Groupe : AMROUCH - AKICHOUH - ZARROUKI - CHERIF
 * Complète la vue générale hiérarchique (vues/seance3_groupe_vue_generale.sysml) :
 * chaque sous-système est vu comme un bloc, avec un port par famille d'échanges
 * identifiée dans les séquences de la séance 2. Le détail des composants et de leurs
 * ports figure dans les vues d'interconnexion de chaque sous-système :
 * vues/seance3_akichouh.sysml, seance3/interconnexions.sysml, vues/seance3_cherif.sysml
 * et vues/seance3_zarrouki.sysml.
 * Les éléments extérieurs sont ceux du contexte de la séance 1 (part def Contexte).
 */
package interconnexionFlexFlow {
    private import parkingIntelligentV2::parts::*;
    private import materielDetectionGuidage::parts::DetectionGuidage;
    private import materielDetectionGuidage::parts::ServeurCentral;
    private import composantsAchats::parts::ShoppingAssist;
    private import materielReservationAcces::parts::ReservationAcces;
    private import materielRechargeMaintenance::parts::RechargeRobotisee;
    private import seance2Zarrouki::composants::PosteSupervision;
    private import seance2ZarroukiMaintenance::composants::TerminalMaintenance;

    /* vue d'interconnexion : le système et les éléments extérieurs avec lesquels il échange */
    part interconnexion {
        /* éléments extérieurs du contexte */
        part telephone : Telephone {
            inout port application;
            in port sms;
        }
        part systemePaiement : SystemePaiement {
            inout port paiement;
        }
        part reseauElectrique : ReseauElectrique {
            out port alimentation;
        }
        part systemeSecuriteIncendie : SystemeSecuriteIncendie {
            out port alarme;
        }
        part vehiculeElectrique : VehiculeElectrique {
            in port prise;
        }

        /* système étudié, vu au niveau de ses sous-systèmes */
        part flexFlow : ParkingIntelligent {
            // occupation des places, plaques, localisation, panneaux et bornes client
            part detectionGuidage : DetectionGuidage {
                inout port detection;
            }
            // dépôt, regroupement et retrait des achats (serveur Shopping propre)
            part shoppingAssist : ShoppingAssist {
                out port notification;
            }
            // tickets, codes QR, cartes, barrières d'entrée, de place et de sortie, bornes
            part reservationAcces : ReservationAcces {
                inout port acces;
                inout port audio;
            }
            // robots, réserves d'énergie, accès au trajet sécurisé, bornes manuelles
            part recharge : RechargeRobotisee {
                inout port commande;
                in port alimentation;
                out port energie;
            }
            part posteSupervision : PosteSupervision {
                inout port supervision;
                inout port audio;
                in port alarme;
            }
            part terminalMaintenance : TerminalMaintenance {
                inout port maintenance;
            }
            // serveur central commun : modules de tous les sous-systèmes sauf Shopping Assist
            part serveurCentral : ServeurCentral {
                inout port detection;
                inout port acces;
                inout port recharge;
                inout port supervision;
                inout port maintenance;
                inout port application;
                inout port prestatairePaiement;
            }

            // liaisons internes : chaque sous-système échange avec le serveur central
            connect detectionGuidage.detection to serveurCentral.detection;
            connect reservationAcces.acces to serveurCentral.acces;
            connect recharge.commande to serveurCentral.recharge;
            connect posteSupervision.supervision to serveurCentral.supervision;
            connect terminalMaintenance.maintenance to serveurCentral.maintenance;
            // assistance : les interphones sont reliés directement au poste (accederAuParkingS3)
            connect reservationAcces.audio to posteSupervision.audio;
        }

        // liaisons avec les éléments extérieurs du contexte
        connect flexFlow.serveurCentral.application to telephone.application;
        connect flexFlow.shoppingAssist.notification to telephone.sms;
        connect flexFlow.serveurCentral.prestatairePaiement to systemePaiement.paiement;
        connect reseauElectrique.alimentation to flexFlow.recharge.alimentation;
        connect flexFlow.recharge.energie to vehiculeElectrique.prise;
        connect systemeSecuriteIncendie.alarme to flexFlow.posteSupervision.alarme;
    }
}
