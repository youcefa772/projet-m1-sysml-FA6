/*
 * Mini-projet SysML - Séance 2 : flux d'actions et séquences (CHERIF Ayman)
 * Cas d'utilisation : superviserExploitation (package parkingIntelligentV2::useCases)
 * Exigences détaillées : alerteSaturation, coupureIncendie, interphone,
 * tarification, modeDegrade
 * Point de vue : celui du système ; les gardes sont des attributs booléens.
 * Une action sépare toujours deux nœuds de contrôle (decide / merge), comme dans le corrigé.
 * Séquences : un scénario par cheminement du flux, S1 à S5 ;
 * les lignes de vie sont des composants du système, sans acteur.
 * Réutilise Superviseur (parkingConseil, AKICHOUH), les composants de seance2Cherif,
 * seance2Zarrouki et Interphone (seance2CherifAcces).
 */
package seance2CherifSupervision {
    private import ScalarValues::Boolean;

    action superviserExploitation {
        attribute sessionOuverte : Boolean;
        attribute alerteSaturation : Boolean;
        attribute incidentSignale : Boolean;
        attribute alarmeIncendie : Boolean;
        attribute parametrageDemande : Boolean;
        attribute finSession : Boolean;
        attribute appelInterphone : Boolean;
        attribute sansAppel : Boolean;

        action collecterEtat;
        action afficherTableauBord;
        action afficherAlerteSaturation;
        action afficherIncident;
        action localiserIncident;
        action mettreEnRelationInterphone;
        action marquerIncidentPrisEnCompte;
        action enregistrerTraitement;
        action couperToutesCharges;
        action confirmerCoupure;
        action appliquerParametres;
        merge merge0;
        merge merge1;
        decide decide0;
        decide decide1;

        first start;
        succession start if sessionOuverte then merge0;
        then collecterEtat;
        succession collecterEtat then afficherTableauBord;
        then decide0;
            if alerteSaturation then afficherAlerteSaturation;
            if incidentSignale then afficherIncident;
            if alarmeIncendie then couperToutesCharges;
            if parametrageDemande then appliquerParametres;
            if finSession then done;
        succession afficherAlerteSaturation then merge0;
        succession couperToutesCharges then confirmerCoupure;
        succession confirmerCoupure then merge0;
        succession appliquerParametres then merge0;
        succession afficherIncident then localiserIncident;
        then decide1;
            if appelInterphone then mettreEnRelationInterphone;
            if sansAppel then marquerIncidentPrisEnCompte;
        succession mettreEnRelationInterphone then merge1;
        succession marquerIncidentPrisEnCompte then merge1;
        succession merge1 then enregistrerTraitement;
        succession enregistrerTraitement then merge0;
    }

    /* composants découverts lors de l'exploration des scénarios */
    package composants {
        part def JournalIncidents;
        part def BorneRechargeManuelle;

        /* données échangées (payloads des messages) */
        part def TableauBord;
        part def Incident;
        part def Parametres;
    }

    package sequences {
        private import parkingConseil::parts::Superviseur;
        private import parkingConseil::parts::ModulePrevision;
        private import parkingConseil::parts::Prevision;
        private import seance2Cherif::composants::*;
        private import seance2Zarrouki::composants::*;
        private import seance2CherifAcces::composants::Interphone;
        private import seance2CherifSupervision::composants::*;

        /* S1 : alerte de saturation affichée au poste */
        occurrence superviserExploitationS1 {
            part posteSupervision : PosteSupervision;
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part modulePrevision : ModulePrevision;
            message ouvrirTableauBord from posteSupervision to superviseur;
            message collecterEtat from superviseur to serveurReservation;
            message etatPlaces of EtatPlaces from serveurReservation to superviseur;
            message afficherTableauBord of TableauBord from superviseur to posteSupervision;
            message alerteSaturation of Prevision from modulePrevision to superviseur;
            message afficherAlerte of Prevision from superviseur to posteSupervision;
            message from posteSupervision to superviseur;
        }
        /* S2 : incident signalé par la recharge, traité par interphone */
        occurrence superviserExploitationS2 {
            part posteSupervision : PosteSupervision;
            part superviseur : Superviseur;
            part serveurReservation : ServeurReservation;
            part gestionRecharge : GestionRecharge;
            part interphone : Interphone;
            part journalIncidents : JournalIncidents;

            message ouvrirTableauBord from posteSupervision to superviseur;
            message collecterEtat from superviseur to serveurReservation;
            message etatPlaces of EtatPlaces from serveurReservation to superviseur;
            message afficherTableauBord of TableauBord from superviseur to posteSupervision;
            message alerte of Alerte from gestionRecharge to posteSupervision;
            message mettreEnRelation from posteSupervision to interphone;
            message from interphone to posteSupervision;
            message enregistrerTraitement of Incident from posteSupervision to journalIncidents;
            message from journalIncidents to posteSupervision;
        }

        /* S3 : alarme incendie, coupure de toutes les charges depuis le poste */
        occurrence superviserExploitationS3 {
            part posteSupervision : PosteSupervision;
            part gestionRecharge : GestionRecharge;
            part reserveEnergie : ReserveEnergie;
            part borneRechargeManuelle : BorneRechargeManuelle;

            message alarmeIncendie of Alerte from posteSupervision to gestionRecharge;
            message couperReserve from gestionRecharge to reserveEnergie;
            message from reserveEnergie to gestionRecharge;
            message chargesRobotsCoupees from gestionRecharge to posteSupervision;
            message couperBornes from posteSupervision to borneRechargeManuelle;
            message from borneRechargeManuelle to posteSupervision;
        }
        /* S4 : modification de la tarification par l'agent */
        occurrence superviserExploitationS4 {
            part posteSupervision : PosteSupervision;
            part superviseur : Superviseur;
            part modulePaiement : ModulePaiement;
            message modifierParametres of Parametres from posteSupervision to superviseur;
            message appliquerTarif of Parametres from superviseur to modulePaiement;
            message from modulePaiement to superviseur;
            message afficherTableauBord of TableauBord from superviseur to posteSupervision;
        }
        /* S5 : fin de la session de supervision */
        occurrence superviserExploitationS5 {
            part posteSupervision : PosteSupervision;
            part superviseur : Superviseur;
            message fermerSession from posteSupervision to superviseur;
            message from superviseur to posteSupervision;
        }
    }
}
