# Séance 2 – ZARROUKI Ahmed – cas d'utilisation « payerEtSortir »

Modèle : `vues/seance2_zarrouki_paiement.sysml` (package `seance2ZarroukiPaiement`)

## 2.1 Flux d'actions – clés de lecture

La vue décrit, du point de vue du système, le départ d'un véhicule et le paiement de son séjour. Le processus réunit les règles des deux dossiers :
- la tarification (`tarification`) : 15 minutes gratuites puis payant, au même tarif aux niveaux 1 et 2, et gratuité pour les employés ;
- le débit automatique par l'application au niveau 2 ;
- la caisse et la borne reliées à la lecture de plaque au niveau 1 (AKICHOUH–AMROUCH) ;
- le paiement en une seule fois du stationnement et de la recharge (`paiementUnique`).

**Départ de la place.** Le système détecte le départ du véhicule. Si la place était réservée, il relève la barrière de place (`protectionPlace`) et libère la place sur le plan (`planTempsReel`). Sinon, il met simplement à jour l'occupation.

**Sortie.** À la voie de sortie, le système lit la plaque et identifie l'usager (`decide1`).
- **Employé.** Le système vérifie son droit : la sortie est gratuite (`niveauEmployes`).
- **Réservation au niveau 2.** Le montant comprend le stationnement et l'énergie de la recharge, moins l'heure offerte par la fidélité (`fideliteReservation`). Il est débité automatiquement. Si le débit est accepté, un reçu est envoyé. S'il est refusé, le paiement est reporté sur la borne de sortie.
- **Visiteur du niveau 1.** Le système lit le ticket QR. La sortie est autorisée si le séjour a duré 15 minutes au plus, ou si le ticket a été payé à la caisse automatique. Sinon, le montant dû est affiché et encaissé à la borne de sortie.

**Fin.** Un paiement validé, un débit accepté, une sortie autorisée et le droit d'un employé convergent tous (`merge1`) vers l'ouverture de la barrière de sortie et l'enregistrement de la sortie. Un paiement qui échoue à la borne aboutit à une mise en relation par l'interphone (`interphone`).

Les gardes sont des attributs booléens, comme dans le corrigé du TD3. Une action sépare toujours deux nœuds de contrôle. Les frais de non-venue n'apparaissent pas ici : ils sont débités dans le cas `reserverPlace`.

## Scénarios de cas d'utilisation

| Scénario | Chemin dans le flux |
|---|---|
| S1 – Niveau 2, débit automatique | départ → barrière de place relevée → plan mis à jour → plaque lue → montant calculé → débit accepté → reçu → sortie |
| S2 – Niveau 2, débit refusé | … débit refusé → montant encaissé à la borne → reçu → sortie |
| S3 – Niveau 1, 15 min au plus | … ticket lu → sortie autorisée → sortie |
| S4 – Niveau 1, ticket payé à la caisse | … ticket lu → sortie autorisée → sortie |
| S5 – Niveau 1, ticket non payé | … ticket lu → montant affiché → montant encaissé à la borne → reçu → sortie |
| S6 – Employé | … plaque lue → droit vérifié → sortie |
| S7 – Échec du paiement à la borne | … montant encaissé à la borne → échec → interphone |

## 2.2 Vues des séquences – clés de lecture

Conformément au sujet, chaque cheminement du flux d'actions est décrit par une vue des séquences. Les sept scénarios S1 à S7 sont tracés ; S2 à S7 n'utilisent aucun composant supplémentaire, sauf l'interphone et le poste de supervision en S7. Comme dans le corrigé du TD4, aucun acteur ne figure dans les séquences.

**S1 – Niveau 2, débit automatique** (`payerEtSortirS1`)
1. Le **capteur de place** signale le départ au **serveur de réservation**.
2. Le serveur fait relever la **barrière de place** et met à jour le plan dans l'**application**.
3. À la sortie, le **lecteur de plaques** prévient le **superviseur**, qui interroge le serveur sur la réservation.
4. Le serveur fait débiter le montant par le **module de paiement**, puis envoie le reçu à l'application.
5. Le serveur autorise la sortie. Le superviseur ouvre alors la **barrière de sortie**.

**S2 – Niveau 2, débit refusé** (`payerEtSortirS2`). Le module de paiement refuse le débit automatique. Le serveur prévient le visiteur dans l'application et transmet le montant dû au superviseur, qui l'affiche à la **borne de sortie**. Le paiement à la borne se déroule ensuite comme en S5.

**S3 – Niveau 1, 15 min au plus** (`payerEtSortirS3`). Le superviseur lit le ticket QR à la borne et constate une durée gratuite : il ouvre la barrière de sortie sans paiement.

**S4 – Niveau 1, ticket payé à la caisse** (`payerEtSortirS4`). Le superviseur fait vérifier le ticket par le module de paiement, qui confirme qu'il est payé, puis ouvre la barrière de sortie.

**S5 – Niveau 1, paiement à la borne** (`payerEtSortirS5`)
1. La **borne de sortie** transmet le ticket QR au superviseur, qui y affiche le montant dû.
2. La borne fait encaisser le montant par le module de paiement.
3. Une fois le paiement validé, le superviseur édite le reçu et ouvre la barrière de sortie.

**S6 – Employé** (`payerEtSortirS6`). Le serveur de réservation identifie la plaque comme celle d'un employé : la sortie est gratuite et le superviseur ouvre la barrière.

**S7 – Échec du paiement à la borne** (`payerEtSortirS7`). Le module de paiement signale l'échec au superviseur, qui met le conducteur en relation avec le poste de supervision par l'**interphone**.

**Composants découverts**
- BarriereSortie et BorneSortie ;
- la donnée MontantDu.

Ils sont déclarés dans `seance2ZarroukiPaiement::composants`.

**Composants réutilisés**
- CapteursPlaces, LecteurPlaques et Superviseur, d'AKICHOUH ;
- les composants de `seance2Cherif` ;
- TicketQR, de `seance2CherifAcces`.
