# Séance 3 – Clés de lecture des vues matérielles : Détection et guidage (AKICHOUH)

## Vue générale hiérarchique (GV)

Cette vue présente la décomposition matérielle du sous-système Détection et guidage.
Le parking intelligent contient le sous-système detectionGuidage, lui-même composé de
quatre types d'équipements : les capteurs de places, les lecteurs de plaques, les
caméras de zone et les panneaux lumineux. La cardinalité [1..*] indique que le parking
compte au moins un équipement de chaque type, et en pratique plusieurs. Les capteurs,
les lecteurs et les panneaux existent déjà dans le parking (exigence
reutilisationExistant) ; les caméras de zone sont le composant découvert lors de
l'analyse du scénario retrouverVehicule en séance 2. Le serveur central apparaît à côté
du sous-système, car il est partagé par tous les sous-systèmes du parking.

## Vue d'interconnexion (IV)

Cette vue est le plan de montage du sous-système : elle montre comment chaque
équipement est relié au serveur central. Chaque connexion relie deux ports et
correspond à un échange identifié dans les séquences de la séance 2. Les capteurs de
places envoient l'occupation (port de sortie), les lecteurs de plaques envoient la
plaque lue à l'arrivée (port de sortie), les panneaux lumineux reçoivent la
recommandation à afficher (port d'entrée), et les caméras de zone échangent dans les
deux sens (port d'entrée/sortie), puisqu'elles reçoivent une demande de localisation et
renvoient la place du véhicule. Seuls les ports du serveur central utiles à ce
sous-système sont représentés ici.
