# EthicFin Task Manager

A robust, Material 3-designed Task Management application built with Flutter. It features a local-first architecture with background cloud synchronization.

## 🚀 Key Features

- **Offline First**: All tasks are saved locally first, ensuring the app is fully functional without an internet connection.
- **Background Sync**: Automatically synchronizes local changes with the cloud when connection is restored.
- **Dynamic Theming**: Support for System Dark/Light modes with a professional Dark Blue and White aesthetic.
- **Full CRUD**: Create, Read, Update, and Delete tasks with Title, Description, Priority, and Due Date.
- **Advanced Management**: Real-time Search, Status Filtering, and Priority/Date Sorting.

## 🛠 Tech Stack & Packages

### Local Storage
- **[Hive](https://pub.dev/packages/hive)**: Used for high-performance, lightweight local storage. It ensures that user data is persisted instantly on the device, providing a lag-free experience even in "dead zones."
- **[Hive Flutter](https://pub.dev/packages/hive_flutter)**: Flutter-specific extensions for Hive.

### Remote Database
- **[Firebase Firestore](https://pub.dev/packages/cloud_firestore)**: Acts as the remote source of truth. It stores task data in the cloud, allowing for cross-device synchronization and data backup.

### State Management & Architecture
- **[GetX](https://pub.dev/packages/get)**: Manages state, dependency injection, and routing across the application.
- **[Connectivity Plus](https://pub.dev/packages/connectivity_plus)**: Monitors real-time network status to trigger background syncs.

## 🔄 Workflow

1. **Local Save**: When a user creates or updates a task, it is immediately written to a Hive box. The UI updates instantly.
2. **Sync Check**: The app checks for internet connectivity.
3. **Cloud Push**: If online, the task is pushed to Firebase Firestore, and the local `isSynced` flag is set to `true`.
4. **Cloud Pull**: On app startup or reconnection, the app listens to a Firestore stream to pull down any remote updates, merging them into the local Hive store.
5. **Conflict Handling**: The remote cloud state acts as the source of truth for existing tasks while preserving local unsynced additions.

## 📦 Installation

1. Clone the repository.
2. Run `flutter pub get`.
3. Ensure your `google-services.json` is placed in `android/app/`.
4. Run `flutter pub run build_runner build` to generate Hive and JSON adapters.
5. Run the app on your emulator or device.

---

Built with ❤️ for efficient task management.
