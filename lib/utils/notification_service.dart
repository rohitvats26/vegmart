import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static Future<bool> requestPermission() async {
    var status = await Permission.notification.request();
    return status.isGranted;
  }
}
