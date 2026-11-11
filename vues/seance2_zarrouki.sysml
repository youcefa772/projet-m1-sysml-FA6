/*
 * Mini-projet SysML - Séance 2 : flux d'actions et séquences (ZARROUKI Ahmed)
 * Cas d'utilisation : demanderRecharge (package parkingIntelligentV2::useCases)
 * Exigences détaillées : acceptationCapacite, prixRecharge, deplacementRobot,
 * connexionAutomatique, energieDelivree, reserveEnergie, suiviRecharge,
 * coupureIncendie, paiementUnique
 * Point de vue : celui du système ; les gardes sont des attributs booléens.
 * Une action sépare toujours deux nœuds de contrôle (decide / merge), comme dans le corrigé.
 * Séquences : S1 (recharge complète), S4 (échec de connexion),
 * S5 (alarme incendie) ; les lignes de vie sont des composants du système, sans acteur.
 * Réutilise les composants de seance2Cherif (AppReservation, ServeurReservation, BarrierePlace).
 */
package seance2Zarrouki {
    private import ScalarValues::Boolean;

    action demanderRecharge {
        attribute rechargeDemandee : Boolean;
        attribute capaciteSuffisante : Boolean;
        attribute capaciteInsuffisante : Boolean;
        attribute prixAccepte : Boolean;
        attribute prixRefuse : Boolean;
        attribute vehiculeStationne : Boolean;
        attribute connexionReussie : Boolean;
        attribute connexionEchouee : Boolean;
        attribute rechargeTerminee : Boolean;
        attribute alarmeIncendie : Boolean;

        action verifierCapaciteLigne;
        action proposerAutreLigne;
        action calculerPrixOption;
        action afficherPrixOption;
        action enregistrerOption;
        action planifierIntervention;
        action envoyerRobot;
        action connecterRobot;
        action alerterAgent;
        action demarrerRecharge;
        action afficherAvancement;
        action notifierFinRecharge;
        action couperRecharge;
        action deconnecterRobot;
        action ramenerRobotBase;
        action rechargerRobot;
        action enregistrerEnergieDelivree;
        merge merge0;
        decide decide0;
        decide decide1;
        decide decide2;
        decide decide3;

        first start;
        succession start if rechargeDemandee then verifierCapaciteLigne;
        then decide0;
            if capaciteInsuffisante then proposerAutreLigne;
            if capaciteSuffisante then calculerPrixOption;
        succession calculerPrixOption then afficherPrixOption;
        then decide1;
            if prixRefuse then done;
            if prixAccepte then enregistrerOption;
        succession enregistrerOption then planifierIntervention;
        succession planifierIntervention if vehiculeStationne then envoyerRobot;
        succession envoyerRobot then connecterRobot;
        then decide2;
            if connexionEchouee then alerterAgent;
            if connexionReussie then demarrerRecharge;
        succession demarrerRecharge then afficherAvancement;
        then decide3;
            if rechargeTerminee then notifierFinRecharge;
            if alarmeIncendie then couperRecharge;
        succession notifierFinRecharge then merge0;
        succession couperRecharge then merge0;
        succession merge0 then deconnecterRobot;
        succession deconnecterRobot then ramenerRobotBase;
        succession ramenerRobotBase then rechargerRobot;
        succession rechargerRobot then enregistrerEnergieDelivree;
        succession enregistrerEnergieDelivree then done;
        succession proposerAutreLigne then done;
        succession alerterAgent then done;
    }

    /* composants découverts lors de l'exploration des scénarios (corrigé TD4) */
    package composants {
        part def GestionRecharge;
        part def RobotRecharge;
        part def ReserveEnergie;
        part def DialogueOption;
        part def PosteSupervision;

        /* données échangées (payloads des messages) */
        part def OptionRecharge;
        part def PrixRecharge;
        part def EnergieDisponible;
        part def MissionRobot;
        part def EtatRecharge;
        part def EnergieDelivree;
        part def Alerte;
    }

    package sequences {
        private import parkingIntelligentV2::parts::*;
        private import seance2Cherif::composants::*;
        private import seance2Zarrouki::composants::*;

        /* S1 : recharge complète */
        occurrence demanderRechargeS1 {
            part telephone : Telephone;
            part appReservation : AppReservation;
            part dialogueOption : DialogueOption;
            part gestionRecharge : GestionRecharge;
            part reserveEnergie : ReserveEnergie;
            part barrierePlace : BarrierePlace;
            part robotRecharge : RobotRecharge;
            part serveurReservation : ServeurReservation;

            message demanderRecharge from telephone to appReservation;
            message verifierCapacite of OptionRecharge from appReservation to gestionRecharge;
            message consulterReserve from gestionRecharge to reserveEnergie;
            message energieDisponible of EnergieDisponible from reserveEnergie to gestionRecharge;
            message prixOption of PrixRecharge from gestionRecharge to appReservation;
            message afficherPrix of PrixRecharge from appReservation to dialogueOption;
            message prixAccepte of PrixRecharge from dialogueOption to appReservation;
            message enregistrerOption of OptionRecharge from appReservation to gestionRecharge;
            message vehiculeStationne of Plaque from barrierePlace to gestionRecharge;
            message envoyerMission of MissionRobot from gestionRecharge to robotRecharge;
            message robotConnecte from robotRecharge to gestionRecharge;
            message alimenterRobot from gestionRecharge to reserveEnergie;
            message energie of EnergieDelivree from reserveEnergie to robotRecharge;
            message etatRecharge of EtatRecharge from robotRecharge to gestionRecharge;
            message afficherAvancement of EtatRecharge from gestionRecharge to appReservation;
            message rechargeTerminee of EnergieDelivree from robotRecharge to gestionRecharge;
            message retourBase from gestionRecharge to robotRecharge;
            message enregistrerEnergie of EnergieDelivree from gestionRecharge to serveurReservation;
            message notifierFin of Notification from gestionRecharge to appReservation;
            message from appReservation to telephone;
        }

        /* S4 : échec de la connexion automatique, l'agent est alerté */
        occurrence demanderRechargeS4 {
            part telephone : Telephone;
            part appReservation : AppReservation;
            part gestionRecharge : GestionRecharge;
            part robotRecharge : RobotRecharge;
            part posteSupervision : PosteSupervision;

            /* vérification de capacité et acceptation du prix : identiques à S1, non répétées */
            message demanderRecharge from telephone to appReservation;
            message enregistrerOption of OptionRecharge from appReservation to gestionRecharge;
            message envoyerMission of MissionRobot from gestionRecharge to robotRecharge;
            message connexionEchouee from robotRecharge to gestionRecharge;
            message alerterAgent of Alerte from gestionRecharge to posteSupervision;
            message from posteSupervision to gestionRecharge;
            message from gestionRecharge to appReservation;
            message from appReservation to telephone;
        }

        /* S5 : alarme incendie pendant la recharge, coupure depuis le poste */
        occurrence demanderRechargeS5 {
            part telephone : Telephone;
            part appReservation : AppReservation;
            part gestionRecharge : GestionRecharge;
            part reserveEnergie : ReserveEnergie;
            part robotRecharge : RobotRecharge;
            part posteSupervision : PosteSupervision;
            part serveurReservation : ServeurReservation;

            /* début identique à S1 jusqu'au démarrage de la recharge, non répété */
            message demanderRecharge from telephone to appReservation;
            message enregistrerOption of OptionRecharge from appReservation to gestionRecharge;
            message alimenterRobot from gestionRecharge to reserveEnergie;
            message energie of EnergieDelivree from reserveEnergie to robotRecharge;
            message alarmeIncendie of Alerte from posteSupervision to gestionRecharge;
            message couperRecharge from gestionRecharge to reserveEnergie;
            message retourBase from gestionRecharge to robotRecharge;
            message energieDelivree of EnergieDelivree from robotRecharge to gestionRecharge;
            message enregistrerEnergie of EnergieDelivree from gestionRecharge to serveurReservation;
            message from gestionRecharge to appReservation;
            message from appReservation to telephone;
        }
    }
}
