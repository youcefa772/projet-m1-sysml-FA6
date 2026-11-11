# Séance 2 – CHERIF Ayman – cas d'utilisation « reserverPlace »

Modèle : `vues/seance2_cherif.sysml` (package `seance2Cherif`)

## 2.1 Flux d'actions – clés de lecture

La vue décrit, du point de vue du système, le processus de réservation d'une place précise du niveau 2. Elle commence quand le conducteur demande une réservation (`reservationDemandee`) et se termine soit quand le véhicule arrive, soit quand la place est libérée.

- **Choix de la place.** Le système affiche le plan et vérifie que la place choisie est toujours libre. Si elle a été prise entre-temps (`placePrise`), il signale qu'elle n'est plus disponible et réaffiche le plan (`merge0`).
- **Enregistrement.** Le système affiche la plaque déclarée, que le visiteur peut modifier. Une fois la plaque validée, il enregistre la réservation, marque la place comme réservée sur le plan (exigence `planTempsReel`) et envoie la confirmation.
- **Suivi jusqu'à l'arrivée.** Le système affiche la réservation dans l'application, puis cinq événements sont possibles (`decide1`) :
  - une **modification** : le système charge la réservation en cours et revient au plan, pour changer de place, de plaque ou d'heure (`modificationReservation`, `declarationPlaque`) ;
  - un **retard signalé** prolonge le maintien de la place ;
  - une **annulation** est confirmée, puis la place est libérée ;
  - **30 minutes sans nouvelles** après l'heure prévue entraînent le débit de 5 € de frais de non-venue, puis la libération de la place (`liberationPlace`) ;
  - l'**arrivée du véhicule** crédite les points de fidélité (`fideliteReservation`). La suite se déroule dans le cas `accederAuParking`.

Les gardes des transitions sont modélisées par des attributs booléens, comme dans le corrigé du TD3 : le système franchit la transition quand la condition est vraie, sans action « attendre ». Comme dans le corrigé, une action sépare toujours deux nœuds de contrôle (décision, convergence). L'option recharge n'apparaît pas ici : elle relève du cas `demanderRecharge`.

## Scénarios de cas d'utilisation

| Scénario | Chemin dans le flux |
|---|---|
| S1 – Réservation honorée | plan → place libre → plaque → enregistrement → arrivée → points de fidélité |
| S2 – Place prise entre-temps | plan → place prise → signalement → plan → … |
| S3 – Modification | … affichage de la réservation → modification → chargement → plan → … |
| S4 – Retard signalé | … affichage de la réservation → prolongation → affichage → … |
| S5 – Annulation | … affichage de la réservation → annulation confirmée → libération de la place |
| S6 – Non-venue | … affichage de la réservation → délai dépassé → frais de 5 € → libération de la place |

## 2.2 Vues des séquences – clés de lecture

Comme dans le corrigé du TD4, les séquences ne représentent aucun acteur. La première ligne de vie est l'élément sur lequel agit le visiteur, son **téléphone**, et la deuxième est le système, ici l'**application de réservation**. On ne trace que les scénarios qui font apparaître de nouveaux composants. S2 à S5 réutilisent les composants de S1, avec les mêmes messages (place prise, modification, retard, annulation) : ils ne sont donc pas représentés.

**S1 – Réservation honorée** (`reserverPlaceS1`)
1. L'application demande l'état des places au **serveur de réservation** et l'affiche dans le **dialogue du plan**.
2. Elle fait vérifier la place choisie, puis affiche la plaque dans le **dialogue de la plaque**.
3. Après validation, le serveur enregistre la réservation et transmet la plaque attendue à la **barrière de place**. C'est la solution retenue pour le couple C5 : la barrière connaît la plaque à l'avance.
4. Le serveur confirme la réservation au téléphone.
5. À l'arrivée, le **contrôle d'accès du niveau 2** signale le véhicule au serveur, qui crédite le **compte de fidélité**.

**S6 – Non-venue** (`reserverPlaceS6`). Une fois la réservation enregistrée, le serveur confie la surveillance du délai de grâce à la **gestion des délais**. Quand le délai de 30 minutes est dépassé :
1. le serveur fait débiter les 5 € de frais par le **module de paiement** ;
2. il annule la plaque attendue auprès de la barrière de place, ce qui libère la place ;
3. il prévient le visiteur.

**Composants découverts** : AppReservation, DialoguePlan, DialoguePlaque, ServeurReservation, BarrierePlace, ControleAccesNiveau2, CompteFidelite, GestionDelais, ModulePaiement. Ils sont déclarés dans le package `seance2Cherif::composants`, avec les données échangées (EtatPlaces, Place, Plaque, Reservation, FraisNonVenue, Notification), notées par le mot-clé `of`. Ils seront reportés dans la décomposition matérielle de la séance 3.
