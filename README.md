# PocketHisab

PocketHisab is a comprehensive personal finance management application built with Flutter. It helps users track their income, expenses, set financial goals, and visualize their spending patterns with ease and security.

## Features

- **Transaction Management**: Effortlessly add and categorize your daily income and expenses.
- **Financial Goals & Budgeting**: Set savings goals and monthly budgets to stay on track with your financial objectives.
- **Data Visualization**: Gain insights into your spending habits with interactive charts and graphs powered by `fl_chart`.
- **Local Persistence**: All your financial data is stored securely on your device using `Hive`.
- **Authentication & Security**: Protect your sensitive financial data with biometric authentication (Fingerprint/Face ID).
- **Notifications**: Stay reminded of your financial tasks and updates with local notifications.
- **Modern UI/UX**: A clean and intuitive interface built with Material Design and Google Fonts.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Database**: [Hive](https://pub.dev/packages/hive)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Charts**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Security**: [Local Auth](https://pub.dev/packages/local_auth)
- **Notifications**: [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

## Getting Started

### Prerequisites

- Flutter SDK (check `pubspec.yaml` for version requirements)
- Android Studio / VS Code
- Android SDK / iOS SDK

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/PocketHisab.git
   cd PocketHisab
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters** (if applicable):
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/core`: Utility classes and constants.
- `lib/features`: Module-based feature implementation (Auth, Goals, Transactions, etc.).
- `lib/shared`: Shared widgets and components.
- `lib/data`: Data models and database logic.

## License

Distributed under the MIT License. See `LICENSE` for more information.
