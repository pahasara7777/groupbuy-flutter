# GroupBuy

A Pinduoduo-style group-buying shop built with Flutter for global markets. Runs on in-memory mock data; no backend yet.

Design: https://www.figma.com/design/ukgm4jQd0eVF6xvWr56NSg

## Run

```bash
flutter create . --project-name groupbuy --platforms=android,ios,web
flutter pub get
flutter analyze && flutter test
flutter run
```

## How it works

Each product has a solo price and a lower group price. Join an open group, start your own (24h), or buy alone. A full group completes the order; an expired group refunds it. "Simulate a friend joining" in the demo fills a group.

## Layout

- `lib/core/`: theme tokens, formatting, navigation helpers
- `lib/models/`, `lib/data/`: domain types and seed data
- `lib/state/store.dart`: all app rules (the file to swap for Firebase)
- `lib/widgets/`, `lib/screens/`: UI
- `test/`: unit, widget and flow tests

## Not built yet

Firebase auth and Firestore, real payments (must be server-side), seller dashboard, translations, push notifications.
