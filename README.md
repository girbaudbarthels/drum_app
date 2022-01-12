# Drumm App

Drumm app is an application meant for drummers who use an e-drum. I couldn't find a drum app that fits my needs hence I started development of this application. Currently its only focused on iPad. The idea is to create an application that plays sounds based upon inputs of a midi instrument (like an e-drum) while focussing on playing over a music app (spotify, apple music, ...).

## Running the application
```bash
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```
## Features
- Choose midi player
- Receive midi signals (Note & velocity)
- Play sounds by tapping or by sending midi signal
- Link own (local) sounds to instruments
- Save presets (UPCOMING)
- Change instrument midi notes in the UI (UPCOMING)
- Ability to add more instruments (UPCOMING)
- Create a nice UI (WIP)
- Change volume of the application without changing the device volume (WIP)

## Contributing
I'm always open to receiving feedback or possible future implementations.
