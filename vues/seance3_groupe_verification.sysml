/*
 * Mini-projet SysML - Séance 3 (travail de groupe) : vérification des exigences
 * Complète vues/seance3_akichouh_verification.sysml (5 exigences fonctionsConseil) et
 * seance3/verification.sysml (exigences de Shopping Assist et accessibilité) pour couvrir
 * les 46 exigences terminales du modèle de la séance 1 (parkingIntelligentV2::requirements).
 * Chaque exigence est satisfaite par un composant de la vue générale (vueGeneraleFlexFlow)
 * et/ou vérifiée par une procédure de test (verification def), selon le point 2.5 du sujet.
 */
package verificationFlexFlow {
    private import parkingIntelligentV2::requirements::*;
    private import parkingIntelligentV2::parts::ParkingIntelligent;
    private import vueGeneraleFlexFlow::flexFlow;

    /* ------------------------------------------------------------------ */
    /* composants qui satisfont les exigences                              */
    /* ------------------------------------------------------------------ */

    /* fonctions de base */
    satisfy controleAcces by flexFlow.reservationAcces;
    satisfy niveauEmployes by flexFlow.reservationAcces.lecteursCarte;
    satisfy tarification by flexFlow.serveurCentral.modulePaiement;
    satisfy paiementUnique by flexFlow.serveurCentral.modulePaiement;

    /* conseil : exigences non encore couvertes */
    satisfy calculTempsTotal by flexFlow.serveurCentral.moduleRecommandation;
    satisfy alerteSaturation by flexFlow.serveurCentral.modulePrevision;

    /* réservation de place */
    satisfy planTempsReel by flexFlow.serveurCentral.serveurReservation;
    satisfy declarationPlaque by flexFlow.serveurCentral.serveurReservation;
    satisfy accesNiveauReserve by flexFlow.reservationAcces.controlesAccesNiveau2;
    satisfy protectionPlace by flexFlow.reservationAcces.barrieresPlace;
    satisfy modificationReservation by flexFlow.serveurCentral.serveurReservation;
    satisfy liberationPlace by flexFlow.serveurCentral.gestionDelais;
    satisfy fideliteReservation by flexFlow.serveurCentral.compteFidelite;
    satisfy guidagePieton by flexFlow.serveurCentral.serveurReservation;

    /* recharge apportée par robot */
    satisfy acceptationCapacite by flexFlow.serveurCentral.gestionRecharge;
    satisfy energieDelivree by flexFlow.recharge.robotsRecharge;
    satisfy deplacementRobot by flexFlow.recharge.robotsRecharge;
    satisfy connexionAutomatique by flexFlow.recharge.robotsRecharge;
    satisfy reserveEnergie by flexFlow.recharge.reservesEnergie;
    satisfy suiviRecharge by flexFlow.serveurCentral.gestionRecharge;

    /* interactions matérielles */
    satisfy reutilisationExistant by flexFlow.detectionGuidage;
    satisfy bornesManuelles by flexFlow.recharge.bornesManuelles;
    satisfy interphone by flexFlow.reservationAcces.interphones;

    /* contraintes */
    satisfy puissanceConstante by flexFlow.recharge.reservesEnergie;
    satisfy puissanceCharge by flexFlow.recharge.accesTrajetSecurise;
    satisfy plafondCompartiment by flexFlow.serveurCentral.gestionRecharge;
    satisfy coupureIncendie by flexFlow.posteSupervision;
    satisfy stockageEnergie by flexFlow.recharge.reservesEnergie;
    satisfy securiteRobot by flexFlow.recharge.accesTrajetSecurise;
    satisfy prixRecharge by flexFlow.serveurCentral.gestionRecharge;
    satisfy localisationProtegee by flexFlow.detectionGuidage.bornesClient;
    satisfy protectionPlaques by flexFlow.serveurCentral.serveurReservation;
    satisfy modeDegrade by flexFlow.detectionGuidage;
    // libreChoix n'est satisfaite par aucun bloc : c'est une propriété d'usage,
    // vérifiée uniquement par la procédure TestLibreChoix

    /* ------------------------------------------------------------------ */
    /* procédures de test qui vérifient les exigences                      */
    /* ------------------------------------------------------------------ */

    verification def TestControleAcces {
        doc /* faire entrer des véhicules aux trois niveaux : plaque lue et ticket QR imprimé
             * à l'entrée, code QR valide puis invalide au niveau 2 (passage chronométré :
             * 10 s au plus), carte valide puis invalide au niveau 3 */
        subject f : ParkingIntelligent;
        objective {
            verify controleAcces;
            verify accesNiveauReserve;
            verify niveauEmployes;
        }
    }
    verification def TestTarificationPaiement {
        doc /* simuler des séjours de 15 min au plus, de plus de 15 min, avec recharge et
             * pour un employé : montant conforme au tarif, payé en une seule fois, heure
             * offerte après 10 réservations honorées, prix de la recharge affiché avant
             * confirmation */
        subject f : ParkingIntelligent;
        objective {
            verify tarification;
            verify paiementUnique;
            verify fideliteReservation;
            verify prixRecharge;
        }
    }
    verification def TestConseilComplementaire {
        doc /* comparer le temps total estimé au temps mesuré (erreur de 20 % au plus) ;
             * simuler une montée d'affluence : l'alerte de saturation arrive au poste
             * au moins 30 min avant */
        subject f : ParkingIntelligent;
        objective {
            verify calculTempsTotal;
            verify alerteSaturation;
        }
    }
    verification def TestPlanReservation {
        doc /* changer l'état de places réelles et chronométrer la mise à jour du plan
             * (3 s au plus, état exact dans 99 % des cas) ; déclarer puis modifier une
             * plaque, modifier, prolonger et annuler une réservation ; suivre le guidage
             * piéton jusqu'au véhicule */
        subject f : ParkingIntelligent;
        objective {
            verify planTempsReel;
            verify declarationPlaque;
            verify modificationReservation;
            verify guidagePieton;
        }
    }
    verification def TestProtectionPlace {
        doc /* présenter la plaque déclarée et d'autres plaques devant la barrière de place
             * (lecture correcte dans 98 % des cas) ; ne pas honorer une réservation :
             * place libérée 30 min après l'heure prévue et 5 € débités */
        subject f : ParkingIntelligent;
        objective {
            verify protectionPlace;
            verify liberationPlace;
        }
    }
    verification def TestRechargeRobot {
        doc /* sur le banc de recharge puis sur le site pilote : refus d'une option au-delà
             * de la capacité de la ligne, trajet du robot chronométré (3 min au plus),
             * connexion sans intervention (98 % au moins), énergie mesurée (20 kWh au
             * moins en 30 min au plus), avancement affiché dans l'application */
        subject f : ParkingIntelligent;
        objective {
            verify acceptationCapacite;
            verify deplacementRobot;
            verify connexionAutomatique;
            verify energieDelivree;
            verify suiviRecharge;
        }
    }
    verification def EssaiEnergieSite {
        doc /* mesurer sur le pilote la puissance appelée au raccordement pendant la
             * recharge de 20 % des places du niveau 2 (aucune augmentation), l'énergie
             * disponible dans la réserve de chaque ligne (200 kWh au moins) et le nombre
             * de charges simultanées par compartiment (20 points et 150 kVA au plus) */
        subject f : ParkingIntelligent;
        objective {
            verify puissanceConstante;
            verify reserveEnergie;
            verify plafondCompartiment;
        }
    }
    verification def InspectionSecuriteIncendie {
        doc /* faire contrôler par l'organisme agréé et la commission de sécurité : charge
             * de 22 kVA au plus hors du trajet sécurisé, avis favorable pour la puissance
             * supérieure sur le trajet, coupure de toutes les charges depuis le poste,
             * réserve implantée dans un local technique séparé */
        subject f : ParkingIntelligent;
        objective {
            verify puissanceCharge;
            verify coupureIncendie;
            verify stockageEnergie;
        }
    }
    verification def InspectionSecuriteRobot {
        doc /* vérifier le dossier de conformité du robot au règlement (UE) 2023/1230 et à
             * l'EN ISO 3691-4 ; mesurer la hauteur des protecteurs fixes du trajet
             * (2,1 m au moins) et contrôler que l'accès est réservé au personnel autorisé */
        subject f : ParkingIntelligent;
        objective {
            verify securiteRobot;
        }
    }
    verification def AuditDonneesPersonnelles {
        doc /* tenter une localisation de véhicule sans QR code valide (refus attendu) ;
             * inspecter la base : aucune plaque en clair (hachage) et suppression des
             * données un mois au plus après la sortie */
        subject f : ParkingIntelligent;
        objective {
            verify localisationProtegee;
            verify protectionPlaques;
        }
    }
    verification def InspectionInteractions {
        doc /* inventaire comparatif avant/après : capteurs, panneaux et lecteurs de
             * plaques existants réutilisés ; présence des bornes manuelles au niveau 1 ;
             * appel de l'interphone depuis chaque niveau vers le poste */
        subject f : ParkingIntelligent;
        objective {
            verify reutilisationExistant;
            verify bornesManuelles;
            verify interphone;
        }
    }
    verification def TestLibreChoix {
        doc /* faire venir un usager sans réservation (accès au niveau 1), ignorer le conseil
             * de zone et retirer ses achats directement en boutique : aucun blocage */
        subject f : ParkingIntelligent;
        objective {
            verify libreChoix;
        }
    }
    verification def TestModeDegrade {
        doc /* débrancher un capteur, rendre la prévision indisponible et mettre un robot
             * hors service : le parking reste utilisable, l'incertitude est signalée et
             * l'agent est alerté */
        subject f : ParkingIntelligent;
        objective {
            verify modeDegrade;
        }
    }
}
