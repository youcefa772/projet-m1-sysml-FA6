# Séance 3 – Matrice d'allocation : Détection et guidage (AKICHOUH)

| Bloc fonctionnel (séance 2) | CapteurPlace | LecteurPlaque | CameraZone | PanneauLumineux | ServeurCentral |
| --- | :---: | :---: | :---: | :---: | :---: |
| CapteursPlaces | X | | | | |
| LecteurPlaques | | X | | | |
| CamerasZone | | | X | | |
| PanneauAffichage | | | | X | |
| Superviseur | | | | | X |
| ModulePrevision | | | | | X |
| ModuleRecommandation | | | | | X |

Remarque : le bloc `BorneClient` n'apparaît pas ici ; la borne appartient au
sous-système Bornes et retrait (AMROUCH), qui l'alloue dans sa propre matrice.

## Clés de lecture

Cette matrice affecte chaque bloc fonctionnel identifié dans les séquences de la
séance 2 à un composant matériel du sous-système Détection et guidage. Une croix
signifie que le bloc fonctionnel est réalisé par le composant de la colonne.
Les quatre blocs liés à des équipements (capteurs, lecteurs, caméras, panneaux)
relèvent d'une allocation structurelle, chacun sur l'équipement du même nom.
Les trois blocs logiciels (superviseur, module de prévision, module de
recommandation) relèvent d'une allocation de logiciel sur du matériel : ils sont
tous hébergés par le serveur central. Chaque bloc est alloué à un seul composant,
et aucun bloc n'est resté sans allocation.
