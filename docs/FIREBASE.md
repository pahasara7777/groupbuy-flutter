# Firebase setup

Project: `groupbuy-5b6cb`. Apps registered: web and Android.

1. **Authentication**: enable Email/Password (Security > Authentication > Sign-in method).
2. **Firestore**: Databases and storage > Cloud Firestore > Create database, region `asia-south1`.
3. **Rules**: `firebase deploy --only firestore:rules` (rules are in `firestore.rules`).
4. **Config**: `flutterfire configure --project=groupbuy-5b6cb --platforms=web,android`
   writes `lib/firebase_options.dart` and `android/app/google-services.json`.
   These keys identify the project; the security rules protect the data.
5. Run: `flutter run -d chrome`.

## Data

| Collection | Document | Who can do what |
|---|---|---|
| `groups/{id}` | productId, groupSize, memberUids, memberNames, expiresAt | signed-in users read; create as first member; join by appending themselves while open |
| `orders/{id}` | uid, ref, productId, paid, at, groupId? | owner reads and creates; nobody updates or deletes |

## Before going to production

- Payments server-side (Stripe or a regional gateway), never from the client.
- A scheduled Cloud Function to mark expired groups and trigger refunds (needs the Blaze plan).
- Firebase App Check, and a rate limit on group creation.
- Google and Apple sign-in (each needs its own console and platform setup).
