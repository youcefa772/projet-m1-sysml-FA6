# Séance 3 – Matrice d'allocation : Détection et guidage (AKICHOUH)

Allocation fonctionnelle : chaque action des flux d'actions de la séance 2 est
affectée au composant matériel qui la réalise (code : `seance3_akichouh_allocation.sysml`).

| Action (séance 2) | capteursPlaces | lecteursPlaques | camerasZone | panneauxLumineux | bornesClient | serveurCentral.superviseur | serveurCentral.modulePrevision | serveurCentral.moduleRecommandation |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| consulterConseilStationnement.mesurerOccupation | X | | | | | | | |
| consulterConseilStationnement.prevoirOccupation | | | | | | | X | |
| consulterConseilStationnement.basculerModeDegrade | | | | | | X | | |
| consulterConseilStationnement.calculerTempsTotalParZone | | | | | | | | X |
| consulterConseilStationnement.recommanderZoneEtEntree | | | | | | | | X |
| consulterConseilStationnement.afficherRecommandation | | | | X | | | | |
| retrouverVehicule.verifierQRCode | | | | | | X | | |
| retrouverVehicule.afficherRefus | | | | | X | | | |
| retrouverVehicule.localiserVehicule | | | X | | | | | |
| retrouverVehicule.afficherPlaceEtChemin | | | | | X | | | |

## Clés de lecture

Cette matrice affecte chacune des dix actions des flux d'actions de la séance 2 à un
composant matériel du sous-système Détection et guidage. Une croix signifie que
l'action est réalisée par le composant de la colonne. Les actions de mesure,
d'affichage et de localisation sont réalisées par les équipements du parking
(capteurs, panneaux, bornes, caméras), tandis que les actions de vérification, de bascule en mode dégradé, de
prévision et de recommandation sont des traitements logiciels hébergés par le
serveur central. Chaque action est allouée à un seul composant et aucune action n'est
restée sans allocation. La colonne lecteursPlaques est vide : le lecteur signale
l'arrivée du véhicule, ce qui correspond à la garde de départ du flux et non à une
action.
