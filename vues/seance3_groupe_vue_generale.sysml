/*
 * Mini-projet SysML - Séance 3 (travail de groupe) : vue générale hiérarchique
 * du système complet ParkSys FlexFlow
 * Groupe : AMROUCH - AKICHOUH - ZARROUKI - CHERIF
 * Assemble, dans un seul arbre, les quatre sous-systèmes décomposés par chaque membre :
 *   - Détection et guidage (AKICHOUH, vues/seance3_akichouh.sysml)
 *   - Shopping Assist (AMROUCH, seance3/composants.sysml)
 *   - Réservation, accès et sortie (CHERIF, vues/seance3_cherif.sysml)
 *   - Recharge par robot (ZARROUKI, vues/seance3_zarrouki.sysml)
 * ainsi que le poste de supervision, le terminal de maintenance et le serveur central
 * partagé avec tous ses modules logiciels.
 * Les ports et les connexions figurent dans les vues d'interconnexion de chaque sous-système.
 */
package vueGeneraleFlexFlow {
    /* système étudié (modèle de la séance 1) */
    private import parkingIntelligentV2::parts::ParkingIntelligent;

    /* Détection et guidage (AKICHOUH) */
    private import materielDetectionGuidage::parts::DetectionGuidage;
    private import materielDetectionGuidage::parts::ServeurCentral;
    private import materielDetectionGuidage::parts::CapteurPlace;
    private import materielDetectionGuidage::parts::LecteurPlaque;
    private import materielDetectionGuidage::parts::CameraZone;
    private import materielDetectionGuidage::parts::PanneauLumineux;
    private import materielDetectionGuidage::parts::BorneClient;
    private import parkingConseil::parts::Superviseur;
    private import parkingConseil::parts::ModulePrevision;
    private import parkingConseil::parts::ModuleRecommandation;

    /* Shopping Assist (AMROUCH) */
    private import composantsAchats::parts::ShoppingAssist;
    private import composantsAchats::parts::ServeurShopping;
    private import composantsAchats::parts::LecteurCode;
    private import composantsAchats::parts::EcranConsigne;
    private import parkingAchats::parts::TabletteBoutique;
    private import parkingAchats::parts::LogicielRetrait;
    private import parkingAchats::parts::JournalRetraits;
    private import parkingAchats::parts::ModuleNotification;
    private import parkingAchats::parts::ConsigneCasiers;
    private import parkingAchats::parts::Casier;

    /* Réservation, accès et sortie, supervision (CHERIF) */
    private import materielReservationAcces::parts::ReservationAcces;
    private import seance2Cherif::composants::BarrierePlace;
    private import seance2Cherif::composants::ControleAccesNiveau2;
    private import seance2Cherif::composants::ServeurReservation;
    private import seance2Cherif::composants::GestionDelais;
    private import seance2Cherif::composants::CompteFidelite;
    private import seance2Cherif::composants::ModulePaiement;
    private import seance2CherifAcces::composants::DistributeurTickets;
    private import seance2CherifAcces::composants::BarriereEntree;
    private import seance2CherifAcces::composants::LecteurCarte;
    private import seance2CherifAcces::composants::Interphone;
    private import seance2CherifSupervision::composants::JournalIncidents;
    private import seance2CherifSupervision::composants::BorneRechargeManuelle;
    private import seance2ZarroukiPaiement::composants::BarriereSortie;
    private import seance2ZarroukiPaiement::composants::BorneSortie;

    /* Recharge par robot et maintenance (ZARROUKI) */
    private import materielRechargeMaintenance::parts::RechargeRobotisee;
    private import seance2Zarrouki::composants::PosteSupervision;
    private import seance2Zarrouki::composants::GestionRecharge;
    private import seance2Zarrouki::composants::RobotRecharge;
    private import seance2Zarrouki::composants::ReserveEnergie;
    private import seance2ZarroukiMaintenance::composants::TerminalMaintenance;
    private import seance2ZarroukiMaintenance::composants::AccesTrajetSecurise;
    private import seance2ZarroukiMaintenance::composants::JournalMaintenance;

    /* vue générale hiérarchique du système complet */
    part flexFlow : ParkingIntelligent {
        doc /* ParkSys FlexFlow : parking intelligent pour grand centre commercial */

        // sous-système 1 : Détection et guidage (SmartFlow Predict et base)
        part detectionGuidage : DetectionGuidage {
            part capteursPlaces : CapteurPlace [1..*];
            part lecteursPlaques : LecteurPlaque [1..*];
            part camerasZone : CameraZone [1..*];
            part panneauxLumineux : PanneauLumineux [1..*];
            part bornesClient : BorneClient [1..*];
        }

        // sous-système 2 : Shopping Assist (dépôt, regroupement et retrait des achats)
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

        // sous-système 3 : Réservation, accès et sortie
        part reservationAcces : ReservationAcces {
            part distributeursTickets : DistributeurTickets [1..*];
            part barrieresEntree : BarriereEntree [1..*];
            part controlesAccesNiveau2 : ControleAccesNiveau2 [1..*];
            part lecteursCarte : LecteurCarte [1..*];
            part barrieresPlace : BarrierePlace [*];
            part barrieresSortie : BarriereSortie [1..*];
            part bornesSortie : BorneSortie [1..*];
            part interphones : Interphone [1..*];
        }

        // sous-système 4 : Recharge par robot
        part recharge : RechargeRobotisee {
            part robotsRecharge : RobotRecharge [*];
            part reservesEnergie : ReserveEnergie [*];
            part accesTrajetSecurise : AccesTrajetSecurise [*];
            part bornesManuelles : BorneRechargeManuelle [1..*];
        }

        // postes de travail des professionnels
        part posteSupervision : PosteSupervision;
        part terminalMaintenance : TerminalMaintenance [1..*];

        // serveur central commun : tous les modules logiciels découverts en séance 2
        part serveurCentral : ServeurCentral {
            part superviseur : Superviseur;
            part modulePrevision : ModulePrevision;
            part moduleRecommandation : ModuleRecommandation;
            part serveurReservation : ServeurReservation;
            part gestionDelais : GestionDelais;
            part compteFidelite : CompteFidelite;
            part modulePaiement : ModulePaiement;
            part journalIncidents : JournalIncidents;
            part gestionRecharge : GestionRecharge;
            part journalMaintenance : JournalMaintenance;
        }
    }
}
