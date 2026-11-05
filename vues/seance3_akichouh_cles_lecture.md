# Séance 3 – Clés de lecture des vues matérielles : Détection et guidage (AKICHOUH)

## Vue générale hiérarchique (GV)

Cette vue présente la décomposition matérielle du sous-système Détection et guidage.
Le parking intelligent contient le sous-système detectionGuidage, composé de cinq
types d'équipements : les capteurs de places, les lecteurs de plaques, les caméras de
zone, les panneaux lumineux et les bornes client. La cardinalité [1..*] indique que le
parking compte au moins un équipement de chaque type, et en pratique plusieurs. Les
capteurs, les lecteurs et les panneaux existent déjà dans le parking (exigence
reutilisationExistant) ; les caméras de zone et les bornes client sont issues de
l'analyse du scénario retrouverVehicule en séance 2. Le serveur central, partagé par
tous les sous-systèmes, héberge les trois blocs logiciels découverts en séance 2 :
le superviseur, le module de prévision et le module de recommandation.

## Vue d'interconnexion (IV)

Cette vue est le plan de montage du sous-système : elle montre comment chaque
équipement est relié au serveur central. Ses six connexions relient chacune deux ports
et correspondent aux échanges identifiés dans les séquences de la séance 2. Les
capteurs de places envoient l'occupation et les lecteurs de plaques la plaque lue à
l'arrivée (ports de sortie). Les panneaux lumineux reçoivent la recommandation à
afficher (port d'entrée). Les caméras de zone échangent dans les deux sens (port
d'entrée/sortie), puisqu'elles reçoivent une demande de localisation et renvoient la
place du véhicule. Enfin, la borne client envoie le QR code scanné au serveur et reçoit
en retour le résultat à afficher : le refus ou la place et le chemin piéton. Seuls les
ports du serveur central utiles à ce sous-système sont représentés ici.
