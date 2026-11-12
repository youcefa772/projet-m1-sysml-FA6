# Séance 3 – Vue générale hiérarchique du système complet (groupe)

Modèle : `vues/seance3_groupe_vue_generale.sysml` (package `vueGeneraleFlexFlow`)

## Vue générale hiérarchique (GV) – clés de lecture

Cette vue présente la décomposition matérielle du système complet **ParkSys FlexFlow**. Elle réunit dans un seul arbre les sous-systèmes décomposés par les quatre membres du groupe. Le système `flexFlow`, typé par le `ParkingIntelligent` du modèle de la séance 1, se décompose en quatre sous-systèmes, deux postes de travail et un serveur central commun :

| Élément | Composants | Issu de |
|---|---|---|
| `detectionGuidage` | capteurs de places, lecteurs de plaques, caméras de zone, panneaux lumineux, bornes client | AKICHOUH – SmartFlow Predict et fonctions de base |
| `shoppingAssist` | tablettes en boutique, serveur Shopping (logiciel de retrait, journal des retraits, notification), 3 consignes (casiers, lecteur de code, écran) | AMROUCH – Shopping Assist |
| `reservationAcces` | distributeurs de tickets, barrières d'entrée, contrôles d'accès du niveau 2, lecteurs de carte, barrières de place, barrières et bornes de sortie, interphones | CHERIF – réservation de place, accès et sortie |
| `recharge` | robots de recharge, réserves d'énergie, accès au trajet sécurisé, bornes manuelles | ZARROUKI – recharge par robot |
| `posteSupervision`, `terminalMaintenance` | postes de l'agent d'exploitation et du technicien | CHERIF et ZARROUKI |
| `serveurCentral` | superviseur, prévision, recommandation, réservation, délais, fidélité, paiement, journal des incidents, gestion de la recharge, journal de maintenance | les quatre membres |

**Cardinalités.**
- **[1..*]** : au moins un équipement de chaque type ; en pratique, il y en a plusieurs.
- **[*]** : le nombre dépend de la configuration du site. C'est le cas des barrières de place (une par place réservée) ainsi que des robots, des réserves et des accès (selon le nombre de lignes équipées).
- **[3]** : les consignes de Shopping Assist, une par niveau.

Chaque composant est typé par la définition issue des séquences de la séance 2. Ce typage assure la traçabilité entre les scénarios et la décomposition matérielle.

Le serveur central est **unique et partagé** : il héberge les modules logiciels de tous les sous-systèmes, à l'exception de ceux de Shopping Assist, qui disposent de leur propre serveur, comme l'a modélisé AMROUCH.

Les ports et les connexions ne figurent pas dans cette vue. Ils sont détaillés dans les vues d'interconnexion de chaque sous-système :
- `vues/seance3_akichouh.sysml` ;
- `seance3/interconnexions.sysml` ;
- `vues/seance3_cherif.sysml` ;
- `vues/seance3_zarrouki.sysml`.
