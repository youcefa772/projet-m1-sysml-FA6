package verificationConseil {
    doc /* Séance 3 (AKICHOUH) : satisfaction et vérification des exigences fonctionsConseil */
    private import parkingIntelligentV2::requirements::*;
    private import materielDetectionGuidage::*;
    private import materielDetectionGuidage::parts::*;

    /* composants qui satisfont les exigences */
    satisfy mesureOccupation by parking.detectionGuidage.capteursPlaces;
    satisfy previsionAffluence by parking.serveurCentral.modulePrevision;
    satisfy recommandationZone by parking.serveurCentral.moduleRecommandation;
    // exigence globale : satisfaite par le sous-système entier
    satisfy reductionRecherche by parking.detectionGuidage;
    satisfy localisationVehicule by parking.detectionGuidage.camerasZone;

    /* cas qui vérifient les exigences */
    verification def TestDetection {
        doc /* comparer l'état détecté à l'état réel sur un échantillon de places
             * (au moins 98 % correct) et chronométrer la mise à jour (30 s au plus) */
        subject p : ParkingIntelligent;
        objective {
            verify mesureOccupation;
        }
    }
    verification def TestPrevision {
        doc /* comparer la prévision à 1 h avec l'occupation mesurée 1 h plus tard
             * (écart d'au plus 15 % de la capacité) */
        subject p : ParkingIntelligent;
        objective {
            verify previsionAffluence;
        }
    }
    verification def TestRecommandation {
        doc /* simuler des arrivées avec des zones prévues au-dessus de 90 % :
             * aucune n'est affichée sur les panneaux */
        subject p : ParkingIntelligent;
        objective {
            verify recommandationZone;
        }
    }
    verification def MesureTempsRecherche {
        doc /* mesurer le temps moyen entre l'entrée et le stationnement avant puis
             * après la mise en service (baisse d'au moins 25 %) */
        subject p : ParkingIntelligent;
        objective {
            verify reductionRecherche;
        }
    }
    verification def TestLocalisation {
        doc /* chronométrer l'affichage après le scan du QR code (5 s au plus) et comparer
             * la place affichée à la place réelle (au moins 99 % correctes) */
        subject p : ParkingIntelligent;
        objective {
            verify localisationVehicule;
        }
    }
}
