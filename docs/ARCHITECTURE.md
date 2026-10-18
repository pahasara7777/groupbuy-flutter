# Architecture

```
lib/
  core/        theme tokens, formatting, navigation helpers, identity ("You")
  models/      Product, GroupDeal, Order, Coupon, UserProfile, AppNotification
  data/        demo catalogue, categories, seed groups/orders/coupons
  services/    AuthService (demo + Firebase), ShopBackend (interface + Firestore)
  state/       Store (ChangeNotifier singleton), shell tab notifier
  widgets/     shared UI pieces (barrel: widgets.dart)
  screens/     one file per screen
  app.dart     AppRoot: splash, onboarding, sign in or the tab shell
  main.dart    Firebase init (falls back to demo mode), MaterialApp
```

## State

`Store` is the only place rules live (group full/expired, coupons, totals). Screens read it
through `ListenableBuilder` and call its methods. It has two modes:

- **Demo** (no Firebase, or not signed in): everything in memory, seeded from `lib/data`.
- **Live** (signed in with Firebase): groups and orders come from `ShopBackend` streams.
  Local changes are applied immediately and rolled back, with a notice, if the backend refuses.

The product catalogue is bundled with the app (its photos are assets), so it is not in Firestore.

## Groups

A group is `open` while it has a free slot and time left, `full` once `members >= groupSize`
(even if the timer later runs out), and `expired` otherwise. An order's status follows its group.
Joining runs in a Firestore transaction so two people cannot take the last slot.

## Known limits

- Payments are not real. Orders are recorded as paid.
- Expiry is evaluated on the client. Refunds need a scheduled Cloud Function (Blaze plan).
- `groupSize` is stored on the group and checked by the rules, but not cross-checked with the catalogue.
