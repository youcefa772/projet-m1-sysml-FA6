package parkingConseil {
    doc /*
     * Mini-projet SysML - Séance 2 : travail individuel (AKICHOUH)
     * Cas d'utilisation traités (issus de la vue des cas d'utilisation du groupe) :
     *  - obtenirConseilStationnement
     *  - retrouverVehicule
     */
    private import ScalarValues::Boolean;

    /* composants découverts lors de l'exploration des scénarios */
    package parts {
        /* lignes de vie */
        part def LecteurPlaques;
        part def Superviseur;
        part def CapteursPlaces;
        part def ModulePrevision;
        part def ModuleRecommandation;
        part def PanneauAffichage;
        part def BorneClient;
        part def CamerasZone;
        part def Message;

        /* payloads des messages */
        part def Plaque;
        part def Occupation;
        part def Prevision;
        part def Recommandation;
        part def QRCode;
        part def Place;
        part def Chemin;
    }

    /* ===================== VUES DES FLUX D'ACTIONS ===================== */
    package actions {

        /* À l'arrivée, le système recommande une zone et une entrée selon la
         * prévision d'occupation et le temps total estimé.
         * Exigences : mesureOccupation, previsionAffluence, recommandationZone,
         * reutilisationExistant (panneaux), modeDegrade (panne de la prévision). */
        action obtenirConseilStationnement {
            attribute vehiculeArrive : Boolean;
            attribute previsionDisponible : Boolean;
            attribute previsionIndisponible : Boolean;

            action mesurerOccupation;
            action prevoirOccupation;
            action calculerTempsTotalParZone;
            action recommanderZoneEtEntree;
            action afficherRecommandation;
            decide decide0;
            merge merge0;

            first start;
            succession start if vehiculeArrive then mesurerOccupation;
            then decide0;
                if previsionDisponible then prevoirOccupation;
                if previsionIndisponible then merge0;
            succession prevoirOccupation then merge0;
            then calculerTempsTotalParZone;
            then recommanderZoneEtEntree;
            then afficherRecommandation;
            then done;
        }

        /* Au retour, une borne affiche la place du véhicule et le chemin
         * piéton après identification du client (scan du QR code).
         * Exigences : localisationVehicule, donneesPersonnelles
         * (aucune localisation sans identification valide). */
        action retrouverVehicule {
            attribute qrCodeScanne : Boolean;
            attribute qrCodeValide : Boolean;
            attribute qrCodeInvalide : Boolean;

            action verifierQRCode;
            action afficherRefus;
            action localiserVehicule;
            action afficherPlaceEtChemin;
            decide decide0;

            first start;
            succession start if qrCodeScanne then verifierQRCode;
            then decide0;
                if qrCodeInvalide then afficherRefus;
                if qrCodeValide then localiserVehicule;
            succession afficherRefus then done;
            succession localiserVehicule then afficherPlaceEtChemin;
            then done;
        }
    }

    /* ======================== VUES DES SÉQUENCES ======================== */
    package sequences {
        private import parkingConseil::parts::*;

        /* obtenirConseilStationnement - S1 : prévision disponible */
        occurrence obtenirConseilS1 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part capteursPlaces : CapteursPlaces;
            part modulePrevision : ModulePrevision;
            part moduleRecommandation : ModuleRecommandation;
            part panneauAffichage : PanneauAffichage;

            message vehiculeArrive from lecteurPlaques to superviseur;
            message mesurer from superviseur to capteursPlaces;
            message occupation of Occupation from capteursPlaces to superviseur;
            message prevoir of Occupation from superviseur to modulePrevision;
            message prevision of Prevision from modulePrevision to superviseur;
            message recommander of Prevision from superviseur to moduleRecommandation;
            message recommandation of Recommandation from moduleRecommandation to superviseur;
            message afficher of Recommandation from superviseur to panneauAffichage;
            message from panneauAffichage to superviseur;
        }

        /* obtenirConseilStationnement - S2 : prévision indisponible (mode dégradé) */
        occurrence obtenirConseilS2 {
            part lecteurPlaques : LecteurPlaques;
            part superviseur : Superviseur;
            part capteursPlaces : CapteursPlaces;
            part modulePrevision : ModulePrevision;
            part moduleRecommandation : ModuleRecommandation;
            part panneauAffichage : PanneauAffichage;

            message vehiculeArrive from lecteurPlaques to superviseur;
            message mesurer from superviseur to capteursPlaces;
            message occupation of Occupation from capteursPlaces to superviseur;
            message prevoir of Occupation from superviseur to modulePrevision;
            message indisponible from modulePrevision to superviseur;
            message recommander of Occupation from superviseur to moduleRecommandation;
            message recommandation of Recommandation from moduleRecommandation to superviseur;
            message afficher of Recommandation from superviseur to panneauAffichage;
            message from panneauAffichage to superviseur;
        }

        /* retrouverVehicule - S1 : QR code invalide */
        occurrence retrouverVehiculeS1 {
            part borneClient : BorneClient;
            part superviseur : Superviseur;
            part messageRefus : Message;

            message retrouverVehicule of QRCode from borneClient to superviseur;
            message afficher from superviseur to messageRefus;
            message from messageRefus to superviseur;
            message from superviseur to borneClient;
        }

        /* retrouverVehicule - S2 : QR code valide, véhicule localisé par les caméras */
        occurrence retrouverVehiculeS2 {
            part borneClient : BorneClient;
            part superviseur : Superviseur;
            part camerasZone : CamerasZone;

            message retrouverVehicule of QRCode from borneClient to superviseur;
            message localiser of Plaque from superviseur to camerasZone;
            message place of Place from camerasZone to superviseur;
            message afficher of Chemin from superviseur to borneClient;
        }
    }
}
