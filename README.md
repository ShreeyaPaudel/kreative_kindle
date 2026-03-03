# Kreative Kindle

A Flutter mobile application for early childhood learning, designed for parents and instructors. The app offers structured activities across craft, literacy, numeracy, science, and storytelling domains.

## Features
- Role-based auth (parent / instructor) with JWT
- Activity library with step-by-step instructions
- Sensor integrations: shake for activity suggestions, gyroscope for hands-free step navigation, proximity sensor for auto-pause, and ambient light–driven dark mode
- Post updates with image upload
- Learning progress tracking and settings

## Setup
```bash
flutter pub get
flutter run
```
Backend: Express + MongoDB — set `baseUrl` in `lib/core/api/api_endpoints.dart`.
