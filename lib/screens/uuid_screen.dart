import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class UUIDScreen extends StatefulWidget {
  const UUIDScreen({super.key});

  @override
  State<UUIDScreen> createState() => _UUIDScreenState();
}

class _UUIDScreenState extends State<UUIDScreen> {
  String _deviceUUID = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchUUID();
  }

  Future<void> _fetchUUID() async {
    String deviceUUID;

    try {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceUUID = await androidIdPlugin.getId() ?? "Unknown Android ID";
      } else if (Platform.isIOS) {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceUUID = iosInfo.identifierForVendor ?? "Unknown iOS UUID";
      } else {
        deviceUUID = "Unsupported platform";
      }
    } catch (e) {
      deviceUUID = "Error: $e";
    }

    if (mounted) {
      setState(() {
        _deviceUUID = deviceUUID;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device UUID'),
      ),
      body: Center(
        child: Text(
          _deviceUUID,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: Platform.isAndroid ? 24 : 14),
        ),
      ),
    );
  }
}
