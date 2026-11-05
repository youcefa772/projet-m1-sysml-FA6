package materielDetectionGuidage {
    doc /* Séance 3 (AKICHOUH) : décomposition matérielle et interconnexion
         * du sous-système Détection et guidage. */

    /* définitions des composants matériels et de leurs ports */
    package parts {
        part def ParkingIntelligent;
        part def DetectionGuidage {
            doc /* sous-système qui détecte les véhicules et guide les conducteurs */
        }
        part def ServeurCentral {
            doc /* serveur qui héberge le superviseur et les modules logiciels */
        }

        part def CapteurPlace {
            doc /* capteur qui détecte si une place est libre ou occupée */
            // existe déjà dans le parking (exigence reutilisationExistant)
            // port issu du message "occupation" de la séquence obtenirConseilS1
            out port occupation;
        }
        part def LecteurPlaque {
            doc /* lecteur qui lit la plaque des véhicules à l'entrée */
            // existe déjà dans le parking (exigence reutilisationExistant)
            // port issu du message "vehiculeArrive" de la séquence obtenirConseilS1
            out port plaque;
        }
        part def CameraZone {
            doc /* caméra qui lit les plaques dans une zone pour relier chaque véhicule à sa place */
            // composant découvert en séance 2 (séquence retrouverVehiculeS2)
            // inout : elle reçoit "localiser" et renvoie "place"
            inout port localisation;
        }
        part def PanneauLumineux {
            doc /* panneau qui affiche la zone et l'entrée recommandées */
            // existe déjà dans le parking (exigence reutilisationExistant)
            // port issu du message "afficher" de la séquence obtenirConseilS1
            in port affichage;
        }
    }

    private import materielDetectionGuidage::parts::*;

    /* vue générale hiérarchique et vue d'interconnexion */
    part parking : ParkingIntelligent {

        // [1..*] : le parking compte plusieurs équipements de chaque type
        part detectionGuidage : DetectionGuidage {
            part capteursPlaces : CapteurPlace [1..*];
            part lecteursPlaques : LecteurPlaque [1..*];
            part camerasZone : CameraZone [1..*];
            part panneauxLumineux : PanneauLumineux [1..*];
        }

        // le serveur central est commun à tous les sous-systèmes ;
        // seuls les ports utiles à Détection et guidage sont montrés ici
        part serveurCentral : ServeurCentral {
            part superviseur;
            part modulePrevision;
            part moduleRecommandation;

            in port occupation;
            in port plaque;
            inout port localisation;
            out port affichage;
        }

        // une connexion par échange identifié dans les séquences de séance 2
        connect detectionGuidage.capteursPlaces.occupation to serveurCentral.occupation;
        connect detectionGuidage.lecteursPlaques.plaque to serveurCentral.plaque;
        connect detectionGuidage.camerasZone.localisation to serveurCentral.localisation;
        connect serveurCentral.affichage to detectionGuidage.panneauxLumineux.affichage;
    }
}