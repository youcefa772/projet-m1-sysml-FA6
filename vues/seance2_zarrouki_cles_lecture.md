# Séance 2 – ZARROUKI Ahmed – cas d'utilisation « demanderRecharge »

Modèle : `vues/seance2_zarrouki.sysml` (package `seance2Zarrouki`)

## 2.1 Flux d'actions – clés de lecture

La vue décrit, du point de vue du système, la recharge d'un véhicule électrique sur sa place réservée, par un robot mobile. Elle suppose qu'une réservation existe déjà (cas `reserverPlace`). Elle commence quand le conducteur demande l'option recharge (`rechargeDemandee`).

- **Acceptation.** Le système vérifie que les robots et la réserve de la ligne peuvent satisfaire la demande (`acceptationCapacite`). Si ce n'est pas le cas, il propose une autre ligne et le cas se termine. Sinon, il calcule et affiche le prix de l'option avant confirmation (`prixRecharge`). Un refus du prix met fin au cas, sans recharge.
- **Intervention.** Si le prix est accepté, le système enregistre l'option et planifie l'intervention du robot. Dès que le véhicule est stationné (barrière de place abaissée), il envoie le robot par le trajet sécurisé (`deplacementRobot`) et le connecte sans intervention de l'usager (`connexionAutomatique`). En cas d'échec de connexion, il alerte l'agent d'exploitation.
- **Recharge.** Le système démarre la recharge à partir de la réserve de la ligne (`reserveEnergie`, `energieDelivree`) et affiche l'avancement dans l'application (`suiviRecharge`). La recharge se termine normalement, avec une notification au visiteur, ou elle est coupée sur alarme incendie (`coupureIncendie`).
- **Fin.** Dans les deux cas (`merge0`), le système déconnecte le robot, le ramène à sa base où il se recharge sur la réserve, et enregistre l'énergie délivrée pour le paiement à la sortie (`paiementUnique`).

Les gardes sont des attributs booléens, comme dans le corrigé du TD3. Une action sépare toujours deux nœuds de contrôle.

## Scénarios de cas d'utilisation

| Scénario | Chemin dans le flux |
|---|---|
| S1 – Recharge complète | capacité suffisante → prix accepté → robot envoyé → connexion réussie → recharge terminée → retour à la base → énergie enregistrée |
| S2 – Capacité insuffisante | capacité insuffisante → autre ligne proposée |
| S3 – Prix refusé | capacité suffisante → prix refusé |
| S4 – Échec de connexion | … robot envoyé → connexion échouée → agent alerté |
| S5 – Alarme incendie | … recharge démarrée → alarme → recharge coupée → retour à la base → énergie enregistrée |

## 2.2 Vues des séquences – clés de lecture

Comme dans le corrigé du TD4, les séquences ne représentent aucun acteur. La première ligne de vie est le **téléphone**, la deuxième l'**application de réservation**. Seuls S1, S4 et S5 sont tracés, car S2 et S3 n'utilisent que des composants déjà présents dans S1.

**S1 – Recharge complète** (`demanderRechargeS1`)
1. L'application demande à la **gestion de la recharge** de vérifier la capacité. La gestion de la recharge consulte la **réserve d'énergie**.
2. Le prix est affiché dans le **dialogue de l'option**, puis accepté.
3. Quand la **barrière de place** signale le véhicule stationné, la gestion de la recharge envoie une mission au **robot de recharge**. Celui-ci se connecte et reçoit l'énergie de la réserve.
4. L'avancement remonte jusqu'à l'application.
5. En fin de recharge, le robot regagne sa base. L'énergie délivrée est enregistrée sur le **serveur de réservation**, pour le paiement à la sortie.

**S4 – Échec de connexion** (`demanderRechargeS4`) : le robot signale l'échec, et la gestion de la recharge alerte le **poste de supervision**.

**S5 – Alarme incendie** (`demanderRechargeS5`) : pendant la recharge, le poste de supervision transmet l'alarme. La gestion de la recharge coupe la réserve et renvoie le robot à sa base. L'énergie déjà délivrée est enregistrée.

**Composants découverts** : GestionRecharge, RobotRecharge, ReserveEnergie, DialogueOption et PosteSupervision, avec les données OptionRecharge, PrixRecharge, EnergieDisponible, MissionRobot, EtatRecharge, EnergieDelivree et Alerte. Ils sont déclarés dans `seance2Zarrouki::composants`. Les séquences réutilisent AppReservation, ServeurReservation, BarrierePlace, Plaque et Notification de `seance2Cherif::composants`. Ils seront reportés dans la décomposition matérielle de la séance 3.
