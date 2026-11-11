# Séance 3 – Vues matérielles : Réservation, accès et sortie (CHERIF)

Modèle : `vues/seance3_cherif.sysml` (package `materielReservationAcces`)

## Vue générale hiérarchique (GV)

Cette vue présente la décomposition matérielle du sous-système Réservation, accès et sortie, ainsi que le poste de supervision. Le parking intelligent contient le sous-système `reservationAcces`, composé de huit types d'équipements :

| Rôle | Équipements |
|---|---|
| Entrée | distributeurs de tickets QR et barrières d'entrée |
| Accès au niveau 2 | contrôles d'accès par code QR |
| Accès au niveau 3 | lecteurs de carte des employés |
| Places réservées du niveau 2 | barrières de place |
| Sortie | barrières et bornes de sortie |
| Assistance | interphones |

La cardinalité [1..*] signifie qu'il y a au moins un équipement de chaque type. Les barrières de place portent [*], car leur nombre dépend du nombre de places réservées. Chaque équipement est typé par le composant découvert dans les séquences de la séance 2, ce qui assure la traçabilité entre les deux séances.

Le serveur central est partagé avec le sous-système Détection et guidage d'AKICHOUH. Il héberge les blocs logiciels découverts en séance 2 : le superviseur, le serveur de réservation, la gestion des délais, le compte de fidélité, le module de paiement et le journal des incidents.

## Vue d'interconnexion (IV)

Cette vue est le plan de montage du sous-système. Ses dix connexions relient chacune deux ports et correspondent aux échanges identifiés dans les séquences de la séance 2 :

- **Équipements qui échangent dans les deux sens avec le serveur central** (ports d'entrée/sortie), parce qu'ils transmettent une lecture et reçoivent une commande ou une réponse :
  - les distributeurs de tickets ;
  - les contrôles d'accès du niveau 2 ;
  - les lecteurs de carte ;
  - les barrières de place, qui transmettent la plaque lue et reçoivent les ordres d'abaissement et de relèvement ;
  - les bornes de sortie.
- **Équipements commandés uniquement par le serveur** (ports d'entrée) : les barrières d'entrée et de sortie.
- **Interphones** : le serveur les active, puis ils relient l'usager au poste de supervision. Le poste échange lui-même avec le serveur central.

Deux ports du serveur restent volontairement sans connexion, car ils mènent vers des éléments extérieurs du contexte :
- `application` mène à l'application des visiteurs, qui s'exécute sur leur téléphone ;
- `prestatairePaiement` mène à l'organisme qui encaisse les paiements.
