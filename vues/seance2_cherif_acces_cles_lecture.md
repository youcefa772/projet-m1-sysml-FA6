# Séance 2 – CHERIF Ayman – cas d'utilisation « accederAuParking »

Modèle : `vues/seance2_cherif_acces.sysml` (package `seance2CherifAcces`)

## 2.1 Flux d'actions – clés de lecture

La vue décrit, du point de vue du système, l'accès d'un véhicule au parking puis à son niveau. Elle reprend la règle de l'exigence `controleAcces` :
- à l'entrée générale, la plaque est lue et un ticket QR de visite est imprimé (solution d'AKICHOUH–AMROUCH) ;
- au niveau 2, l'accès se fait par le code QR de l'application ;
- au niveau 3, il se fait par la carte personnelle (solutions de CHERIF–ZARROUKI).

**Entrée.** Le système lit la plaque, imprime le ticket QR, puis ouvre la barrière d'entrée. Une décision (`decide0`) aiguille ensuite le véhicule selon le niveau visé.

**Niveau 1.** L'accès est libre : le cas se termine. Le conseil de zone relève du cas `consulterConseilStationnement`.

**Niveau 2.** Le système demande puis lit le code QR de l'application (`accesNiveauReserve`).
- Si le code est **invalide**, il refuse l'accès.
- Si le code est **valide**, il ouvre l'accès et guide le conducteur jusqu'à sa place. Une fois le véhicule sur la place, la barrière de place lit la plaque.
  - **Plaque attendue** : la barrière s'abaisse (`protectionPlace`). Le système signale l'arrivée, ce qui crédite la fidélité dans `reserverPlace`, puis met à jour le plan (`planTempsReel`).
  - **Plaque non reconnue** : la barrière reste levée.

Un refus d'accès et une plaque non reconnue convergent (`merge0`) vers la proposition d'assistance : par l'application ou par l'interphone (`interphone`).

**Niveau 3.** Le système lit la carte personnelle de l'employé. Il ouvre l'accès si la carte est valide et le refuse sinon (`niveauEmployes`).

Les gardes sont des attributs booléens, comme dans le corrigé du TD3. Une action sépare toujours deux nœuds de contrôle.

## Scénarios de cas d'utilisation

| Scénario | Chemin dans le flux |
|---|---|
| S1 – Niveau 2 nominal | entrée → QR valide → guidage → plaque attendue → barrière abaissée → arrivée signalée → plan mis à jour |
| S2 – QR invalide | entrée → QR invalide → accès refusé → assistance |
| S3 – Plaque non reconnue | … guidage → plaque non reconnue → barrière levée → assistance |
| S4 – Niveau 1 | entrée → accès libre |
| S5 – Employé, carte valide | entrée → carte lue → accès au niveau 3 |
| S6 – Carte invalide | entrée → carte lue → accès refusé |

## 2.2 Vues des séquences – clés de lecture

Conformément au sujet, chaque cheminement du flux d'actions est décrit par une vue des séquences. Les six scénarios S1 à S6 sont tracés ; S2, S4 et S6 n'utilisent aucun composant supplémentaire. Comme dans le corrigé du TD4, aucun acteur ne figure : la première ligne de vie est l'équipement sur lequel agit le conducteur.

**S1 – Niveau 2 nominal** (`accederAuParkingS1`)
1. Le **lecteur de plaques** signale l'arrivée au **superviseur**, qui fait imprimer le ticket par le **distributeur de tickets** et ouvre la **barrière d'entrée**.
2. Au niveau 2, le **contrôle d'accès** transmet le QR lu au **serveur de réservation**, qui ouvre l'accès et guide le conducteur par l'**application**.
3. La **barrière de place** transmet la plaque lue. Le serveur la fait abaisser et met à jour le plan.

**S2 – QR invalide** (`accederAuParkingS2`). Le serveur de réservation rejette le code QR lu par le contrôle d'accès du niveau 2, qui reste fermé. Comme en S3, il propose l'assistance dans l'application et active l'**interphone** vers le poste de supervision.

**S3 – Plaque non reconnue** (`accederAuParkingS3`) : le serveur maintient la barrière levée, propose l'assistance dans l'application et active l'**interphone**, qui met le conducteur en relation avec le **poste de supervision**.

**S4 – Niveau 1** (`accederAuParkingS4`). L'entrée générale de S1 suffit : plaque lue, ticket QR imprimé, barrière d'entrée ouverte. Le niveau 1 est en accès libre.

**S5 – Employé** (`accederAuParkingS5`) : après l'entrée, identique à S1, le **lecteur de carte** transmet la carte au superviseur, qui ouvre l'accès au niveau 3.

**S6 – Carte invalide** (`accederAuParkingS6`). Après l'entrée générale, le superviseur refuse la carte lue par le **lecteur de carte**, qui reste fermé.

**Composants découverts** :
- DistributeurTickets, BarriereEntree, LecteurCarte et Interphone ;
- les données TicketQR, CodeQR et CartePersonnelle.

Ils sont déclarés dans `seance2CherifAcces::composants`.

**Composants réutilisés** :
- LecteurPlaques et Superviseur, d'AKICHOUH ;
- les composants de `seance2Cherif` ;
- PosteSupervision, de ZARROUKI.
