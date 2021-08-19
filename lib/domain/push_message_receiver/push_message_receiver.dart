import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../commons/providers/firebase_messaging_provider.dart';
import '../../commons/providers/firestore_provider.dart';

final pushMessageReceiverProvider = Provider<PushMessageReceiver>((ref) {
  return PushMessageReceiver(ref.read);
});

class PushMessageReceiver {
  PushMessageReceiver(this._read) {
    // Subscribe to the latest FCM Token.
    // The FCM Token will be updated when the app is installed, the device is
    // changed, the app is reinstalled, or the app's data is deleted.
    // TODO(Riscait): cancel on dispose.
    _messaging.onTokenRefresh.listen(saveLatestToken);
    // Foreground messages.
    // TODO(Riscait): cancel on dispose.
    FirebaseMessaging.onMessage.listen(handleMessage);
  }

  final Reader _read;
  late final _messaging = _read(firebaseMessagingProvider);

  /// Save the FCM Token in Firestore.
  Future<void> saveLatestToken(String token) async {
    _read(firestoreProvider);
  }

  /// Foreground messages.
  Future<void> handleMessage(RemoteMessage message) async {
    if (message.notification != null) {
      // Has notification.
    }
  }

  /// Read the current permissions without attempting to request
  /// On Android authorizationStatus is always authorized.
  Future<NotificationSettings> getCurrentSettings() async {
    final settings = await _messaging.getNotificationSettings();
    return settings;
  }

  /// If the user declines the request, you cannot re-request permission.
  /// On Android authorizationStatus is always authorized.
  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      // If enabled, Siri will read the notification content out when devices
      // are connected to AirPods.
      announcement: false,
      // If enabled, display a notification when carPlay is connected.
      carPlay: false,
      // If enabled, notification permission to be instantly granted without
      // displaying a dialog to your user.
      provisional: false,
    );
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        // The user granted permission.
        break;
      case AuthorizationStatus.denied:
        // The user denied permission.
        break;
      case AuthorizationStatus.notDetermined:
        // The user has not yet chosen whether to grant permission.
        break;
      case AuthorizationStatus.provisional:
        // The user granted provisional permission.
        break;
    }
  }

  /// FCM Token.
  Future<String> web() async {
    final token = await _messaging.getToken(
      vapidKey:
          '''BIDJgmXPe0BrpfTOwKeBB9W6kGMDEeTjyIXLoXHQlGQrMYTjTWlJuL04rYv5HzKFsIGQsplZ2_Gz56OnKdxHNDc''',
    );
    return token!;
  }
}
