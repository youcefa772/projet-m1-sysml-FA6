# Séance 3 – Table des exigences : fonctionsConseil (AKICHOUH)

| id | Exigence | Doc (modèle du groupe) | Exigence parente | Satisfaite par (composants) | Vérifiée par (procédure de test) |
| --- | --- | --- | --- | --- | --- |
| C1 | mesureOccupation | détecter l'état libre / occupé des places dans au moins 98 % des cas et le mettre à jour en 30 s au plus | fonctionsConseil | CapteurPlace ; ServeurCentral (Superviseur) | Comparer l'état détecté à l'état réel sur un échantillon de places : taux correct ≥ 98 %. Chronométrer la mise à jour après l'arrivée ou le départ d'un véhicule : ≤ 30 s. |
| C2 | previsionAffluence | prévoir l'occupation par zone sur au moins 2 h, avec une erreur à 1 h d'au plus 15 % de la capacité | fonctionsConseil | ServeurCentral (ModulePrevision) | Vérifier que la prévision couvre au moins 2 h. Comparer la prévision à 1 h avec l'occupation mesurée 1 h plus tard : écart ≤ 15 % de la capacité de la zone. |
| C3 | recommandationZone | recommander une zone selon le temps total estimé, sans conseiller une zone prévue à plus de 90 % | fonctionsConseil | ServeurCentral (ModuleRecommandation) ; PanneauLumineux | Simuler des arrivées avec des zones prévues au-dessus et en dessous de 90 % : aucune zone prévue à plus de 90 % n'est affichée sur les panneaux. |
| C4 | reductionRecherche | le temps moyen de recherche d'une place doit baisser d'au moins 25 % par rapport à une période comparable | fonctionsConseil | Sous-système DetectionGuidage dans son ensemble | Mesurer le temps moyen entre l'entrée et le stationnement avant puis après la mise en service, sur des périodes comparables : baisse ≥ 25 %. |
| C5 | localisationVehicule | la borne doit afficher place et chemin piéton en 5 s au plus, avec une localisation correcte dans au moins 99 % des cas | fonctionsConseil | CameraZone ; BorneClient ; ServeurCentral (Superviseur) | Chronométrer l'affichage après le scan du QR code : ≤ 5 s. Comparer la place affichée à la place réelle sur un échantillon de véhicules : ≥ 99 % correctes. |

## Clés de lecture

Cette table reprend les cinq exigences de la catégorie fonctionsConseil, avec leur
documentation issue du modèle du groupe. Pour chacune, elle indique les composants
matériels qui la satisfont (et, entre parenthèses, le bloc fonctionnel qu'ils
hébergent) ainsi que la procédure de test qui permet de la vérifier, en reprenant
les valeurs chiffrées de l'exigence. L'exigence reductionRecherche n'est pas
satisfaite par un composant isolé mais par le sous-système entier : elle ne peut
être vérifiée que par une mesure avant / après. Les procédures de test sont aussi
modélisées dans le fichier seance3_akichouh_verification.sysml. Toutes les exigences de la catégorie sont ainsi couvertes par au moins un
composant et une procédure de test.
