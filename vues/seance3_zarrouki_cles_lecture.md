# Séance 3 – Vues matérielles : Recharge par robot et maintenance (ZARROUKI)

Modèle : `vues/seance3_zarrouki.sysml` (package `materielRechargeMaintenance`)

## Vue générale hiérarchique (GV)

Cette vue présente la décomposition matérielle du sous-système de recharge par robot ainsi que le terminal de maintenance. Le parking intelligent contient le sous-système `recharge`, composé de quatre types d'équipements :
- les robots de recharge, deux par ligne de 50 places ;
- les réserves d'énergie, une par ligne, installées dans un local technique séparé ;
- les accès au trajet sécurisé des robots ;
- les bornes à branchement manuel du niveau 1.

La cardinalité [*] des robots, des réserves et des accès dépend du nombre de lignes équipées. Chaque équipement est typé par le composant découvert dans les séquences de la séance 2.

Le serveur central est partagé avec les autres sous-systèmes. Il héberge la gestion de la recharge et le journal de maintenance.

## Vue d'interconnexion (IV)

Cette vue est le plan de montage du sous-système. Ses six connexions correspondent aux échanges identifiés dans les séquences de la séance 2 :
- le serveur central envoie leurs missions aux robots et commande les réserves d'énergie (ports d'entrée/sortie), car il reçoit en retour l'état de la recharge ;
- la réserve alimente directement les robots de sa ligne (port de sortie vers port d'entrée). C'est la solution retenue pour ne pas augmenter la puissance de raccordement du site ;
- le serveur déverrouille l'accès au trajet sécurisé et coupe les bornes manuelles en cas d'alarme incendie (ports de sortie) ;
- le terminal de maintenance échange avec le serveur dans les deux sens, en envoyant les interventions et en recevant la liste des défauts.

Deux ports restent volontairement sans connexion, car ils mènent vers des éléments extérieurs du contexte :
- le connecteur du robot vers le véhicule électrique ;
- l'alimentation des réserves par le réseau électrique du site.
