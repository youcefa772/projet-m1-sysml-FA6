/*
 * Mini-projet SysML - Séance 2 : flux d'actions et séquences (CHERIF Ayman)
 * Cas d'utilisation : reserverPlace (package parkingIntelligentV2::useCases)
 * Exigences détaillées : planTempsReel, declarationPlaque, modificationReservation,
 * liberationPlace, fideliteReservation
 * Point de vue : celui du système ; les gardes sont des attributs booléens.
 * Une action sépare toujours deux nœuds de contrôle (decide / merge), comme dans le corrigé.
 * Séquences : scénarios S1 (réservation honorée) et S6 (non-venue) ;
 * les lignes de vie sont des composants du système, sans acteur.
 */
package seance2Cherif {
    private import ScalarValues::Boolean;

    action reserverPlace {
        attribute reservationDemandee : Boolean;
        attribute placeChoisie : Boolean;
        attribute placeLibre : Boolean;
        attribute placePrise : Boolean;
        attribute plaqueValidee : Boolean;
        attribute modificationDemandee : Boolean;
        attribute retardSignale : Boolean;
        attribute annulationDemandee : Boolean;
        attribute delaiGraceDepasse : Boolean;
        attribute vehiculeArrive : Boolean;

        action afficherPlan;
        action verifierDisponibilite;
        action afficherPlaqueDeclaree;
        action enregistrerReservation;
        action marquerPlaceReservee;
        action envoyerConfirmation;
        action prolongerMaintienPlace;
        action debiterFraisNonVenue;
        action libererPlace;
        action crediterPointsFidelite;
        action signalerPlaceIndisponible;
        action afficherReservation;
        action chargerReservationEnCours;
        action confirmerAnnulation;
        merge merge0;
        merge merge1;
        merge merge2;
        decide decide0;
        decide decide1;

        first start;
        succession start if reservationDemandee then merge0;
        then afficherPlan;
        succession afficherPlan if placeChoisie then verifierDisponibilite;
        then decide0;
            if placePrise then signalerPlaceIndisponible;
            if placeLibre then afficherPlaqueDeclaree;
        succession afficherPlaqueDeclaree if plaqueValidee then enregistrerReservation;
        then marquerPlaceReservee;
        then envoyerConfirmation;
        succession envoyerConfirmation then merge1;
        succession merge1 then afficherReservation;
        then decide1;
            if modificationDemandee then chargerReservationEnCours;
            if retardSignale then prolongerMaintienPlace;
            if annulationDemandee then confirmerAnnulation;
            if delaiGraceDepasse then debiterFraisNonVenue;
            if vehiculeArrive then crediterPointsFidelite;
        succession signalerPlaceIndisponible then merge0;
        succession chargerReservationEnCours then merge0;
        succession confirmerAnnulation then merge2;
        succession prolongerMaintienPlace then merge1;
        succession debiterFraisNonVenue then merge2;
        succession merge2 then libererPlace;
        succession libererPlace then done;
        succession crediterPointsFidelite then done;
    }

    /* composants découverts lors de l'exploration des scénarios (corrigé TD4) */
    package composants {
        part def AppReservation;
        part def DialoguePlan;
        part def DialoguePlaque;
        part def ServeurReservation;
        part def BarrierePlace;
        part def ControleAccesNiveau2;
        part def CompteFidelite;
        part def GestionDelais;
        part def ModulePaiement;

        /* données échangées (payloads des messages) */
        part def EtatPlaces;
        part def Place;
        part def Plaque;
        part def Reservation;
        part def FraisNonVenue;
        part def Notification;
    }

    package sequences {
        private import parkingIntelligentV2::parts::*;
        private import seance2Cherif::composants::*;

        /* S1 : réservation honorée */
        occurrence reserverPlaceS1 {
            part telephone : Telephone;
            part appReservation : AppReservation;
            part dialoguePlan : DialoguePlan;
            part dialoguePlaque : DialoguePlaque;
            part serveurReservation : ServeurReservation;
            part barrierePlace : BarrierePlace;
            part controleAccesNiveau2 : ControleAccesNiveau2;
            part compteFidelite : CompteFidelite;

            message reserverPlace from telephone to appReservation;
            message demanderEtatPlaces from appReservation to serveurReservation;
            message etatPlaces of EtatPlaces from serveurReservation to appReservation;
            message afficherPlan of EtatPlaces from appReservation to dialoguePlan;
            message placeChoisie of Place from dialoguePlan to appReservation;
            message verifierDisponibilite of Place from appReservation to serveurReservation;
            message placeLibre of Place from serveurReservation to appReservation;
            message afficherPlaque of Plaque from appReservation to dialoguePlaque;
            message plaqueValidee of Plaque from dialoguePlaque to appReservation;
            message enregistrerReservation of Reservation from appReservation to serveurReservation;
            message programmerPlaqueAttendue of Plaque from serveurReservation to barrierePlace;
            message confirmerReservation of Reservation from serveurReservation to appReservation;
            message notifierConfirmation of Notification from appReservation to telephone;
            message vehiculeArrive of Reservation from controleAccesNiveau2 to serveurReservation;
            message crediterPoints of Reservation from serveurReservation to compteFidelite;
            message from compteFidelite to serveurReservation;
        }

        /* S6 : non-venue - place libérée et frais de 5 € débités */
        occurrence reserverPlaceS6 {
            part telephone : Telephone;
            part appReservation : AppReservation;
            part serveurReservation : ServeurReservation;
            part gestionDelais : GestionDelais;
            part modulePaiement : ModulePaiement;
            part barrierePlace : BarrierePlace;

            /* choix de la place et de la plaque : identiques à S1, non répétés */
            message reserverPlace from telephone to appReservation;
            message enregistrerReservation of Reservation from appReservation to serveurReservation;
            message programmerPlaqueAttendue of Plaque from serveurReservation to barrierePlace;
            message surveillerDelai of Reservation from serveurReservation to gestionDelais;
            message delaiDepasse of Reservation from gestionDelais to serveurReservation;
            message debiterFrais of FraisNonVenue from serveurReservation to modulePaiement;
            message from modulePaiement to serveurReservation;
            message annulerPlaqueAttendue of Plaque from serveurReservation to barrierePlace;
            message notifierLiberation of Notification from serveurReservation to appReservation;
            message from appReservation to telephone;
        }
    }
}
