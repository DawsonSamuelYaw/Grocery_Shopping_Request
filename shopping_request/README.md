# Group 10 Grocery App — Modular Flutter Version

This version is properly separated into modules.

## Structure

```text
lib/
├── app/
├── core/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── models/
│   └── mock/
├── providers/
├── features/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── categories/
│   ├── products/
│   ├── cart/
│   ├── checkout/
│   ├── orders/
│   └── profile/
├── navigation/
└── main.dart
```

## Run

```bash
flutter pub get
flutter run
```

The project is frontend-only and uses Provider with mock data.
