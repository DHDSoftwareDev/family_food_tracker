# Family Food Tracker

A responsive Flutter application for tracking family food preferences. The same
codebase supports Android, iOS, and web.

## Run locally

```sh
flutter pub get
flutter run
```

To run the web app specifically:

```sh
flutter run -d chrome
```

## Build the web app for GitHub Pages

GitHub Pages serves the checked-in Flutter web build from `docs/`. From the
repository root, run:

```sh
flutter build web \
  --release \
  --base-href /family_food_tracker/ \
  --output docs
```

Commit the regenerated `docs/` files with the source changes. In the GitHub
repository settings, configure Pages to deploy from the `main` branch and the
`/docs` folder.

The published app is available at:

<https://dhdsoftwaredev.github.io/family_food_tracker/>
