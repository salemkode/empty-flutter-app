import 'package:flutter/material.dart';
import 'package:flutter_nfc_hce/flutter_nfc_hce.dart';

class NfcHcePage extends StatefulWidget {
  const NfcHcePage({super.key});

  @override
  State<NfcHcePage> createState() => _NfcHcePageState();
}

class _NfcHcePageState extends State<NfcHcePage> {
  final _flutterNfcHcePlugin = FlutterNfcHce();
  bool _isNfcHceSupported = false;
  bool _isNfcEnabled = false;
  bool _isSecureNfcEnabled = false;
  String status = "HCE is Off";
  final String _nfcContent = 'Hello from HCE';

  @override
  void initState() {
    super.initState();
    _checkNfcSupport();
  }

  Future<void> _checkNfcSupport() async {
    final isSupported = await _flutterNfcHcePlugin.isNfcHceSupported();
    final isEnabled = await _flutterNfcHcePlugin.isNfcEnabled();
    final isSecureNfcEnabled = await _flutterNfcHcePlugin.isSecureNfcEnabled();
    setState(() {
      _isNfcHceSupported = isSupported;
      _isNfcEnabled = isEnabled;
      _isSecureNfcEnabled = isSecureNfcEnabled;
      if (!_isNfcHceSupported) {
        status = "HCE غير مدعوم";
      } else if (!_isNfcEnabled) {
        status = "NFC غير مفعّل";
      } else {
        status = "HCE is Off";
      }
    });
  }

  Future<void> startHce() async {
    if (_isNfcHceSupported && _isNfcEnabled) {
      await _flutterNfcHcePlugin.startNfcHce(_nfcContent);
      setState(() => status = "HCE Started");
    } else {
      setState(() => status = "لا يمكن بدء HCE - تحقق من إعدادات NFC");
    }
  }

  Future<void> stopHce() async {
    await _flutterNfcHcePlugin.stopNfcHce();
    setState(() => status = "HCE Stopped");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFC HCE Page")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'دعم HCE: $_isNfcHceSupported',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'حالة NFC: $_isNfcEnabled',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Secure NFC: $_isSecureNfcEnabled',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startHce,
              child: const Text("Start HCE"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: stopHce,
              child: const Text("Stop HCE"),
            ),
          ],
        ),
      ),
    );
  }
}

