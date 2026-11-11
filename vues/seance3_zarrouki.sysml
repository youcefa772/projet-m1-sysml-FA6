/*
 * Mini-projet SysML - Séance 3 : décomposition matérielle et interconnexions (ZARROUKI Ahmed)
 * Sous-système : Recharge par robot et maintenance
 * Les types des composants sont ceux découverts dans les séquences de la séance 2
 * (seance2Zarrouki, seance2ZarroukiMaintenance, seance2CherifSupervision) ;
 * les ports sont déduits des messages échangés dans ces séquences.
 * Style repris de vues/seance3_akichouh.sysml (même serveur central partagé).
 */
package materielRechargeMaintenance {
    private import parkingIntelligentV2::parts::ParkingIntelligent;
    private import materielDetectionGuidage::parts::ServeurCentral;
    private import seance2Zarrouki::composants::*;
    private import seance2ZarroukiMaintenance::composants::*;
    private import seance2CherifSupervision::composants::BorneRechargeManuelle;

    package parts {
        part def RechargeRobotisee {
            doc /* sous-système qui recharge les véhicules électriques du niveau 2 par robot
                   mobile, à partir d'une réserve d'énergie par ligne de 50 places */
        }
    }

    private import materielRechargeMaintenance::parts::*;

    /* vue générale hiérarchique et vue d'interconnexion */
    part parking : ParkingIntelligent {

        part recharge : RechargeRobotisee {
            // deux robots par ligne de 50 places (demanderRechargeS1)
            part robotsRecharge : RobotRecharge [*] {
                inout port mission;
                in port energie;
                // vers le véhicule électrique, élément extérieur du contexte
                inout port connecteurVehicule;
            }
            // une réserve par ligne, dans un local technique séparé (demanderRechargeS1, S5)
            part reservesEnergie : ReserveEnergie [*] {
                inout port commande;
                out port energie;
                // vers le réseau électrique du site, élément extérieur du contexte
                in port alimentation;
            }
            // grille d'accès au trajet sécurisé des robots (maintenirEquipementsS2)
            part accesTrajetSecurise : AccesTrajetSecurise [*] {
                in port deverrouillage;
            }
            // bornes à branchement manuel du niveau 1 (superviserExploitationS3)
            part bornesManuelles : BorneRechargeManuelle [1..*] {
                in port coupure;
            }
        }

        // terminal du technicien (maintenirEquipementsS2 et S3)
        part terminalMaintenance : TerminalMaintenance [1..*] {
            inout port maintenance;
        }

        // le serveur central est commun à tous les sous-systèmes ;
        // seuls les modules et les ports utiles à ce sous-système sont montrés ici
        part serveurCentral : ServeurCentral {
            part gestionRecharge : GestionRecharge;
            part journalMaintenance : JournalMaintenance;

            inout port missionRobots;
            inout port commandeReserves;
            out port deverrouillageTrajet;
            out port coupureBornes;
            inout port maintenance;
        }

        // une connexion par échange identifié dans les séquences de la séance 2
        connect serveurCentral.missionRobots to recharge.robotsRecharge.mission;
        connect serveurCentral.commandeReserves to recharge.reservesEnergie.commande;
        connect recharge.reservesEnergie.energie to recharge.robotsRecharge.energie;
        connect serveurCentral.deverrouillageTrajet to recharge.accesTrajetSecurise.deverrouillage;
        connect serveurCentral.coupureBornes to recharge.bornesManuelles.coupure;
        connect terminalMaintenance.maintenance to serveurCentral.maintenance;
    }
}
