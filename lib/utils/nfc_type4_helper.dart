import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// Helper class for reading NFC Type 4 Tags using SEND/RECEIVE commands
/// Based on NFCForum-TS-Type-4-Tag specification
/// 
/// Note: This implementation provides a framework for Type 4 Tag reading.
/// For full implementation, you may need platform-specific code or
/// use a package that directly supports ISO-DEP transceive commands.
class NfcType4Helper {
  /// Read NDEF message from Type 4 Tag
  /// This is a simplified version that works with nfc_manager's standard NDEF reading
  /// For full Type 4 implementation with SEND/RECEIVE, platform channels may be needed
  static Future<String?> readType4Ndef(NfcTag tag) async {
    try {
      if (kDebugMode) debugPrint('Attempting to read Type 4 Tag');
      
      // First, try standard NDEF reading (works for most Type 4 tags)
      final ndef = Ndef.from(tag);
      if (ndef != null) {
        try {
          final ndefMessage = await ndef.read();
          if (ndefMessage.records.isNotEmpty) {
            // Extract text from NDEF records
            final textRecords = ndefMessage.records
                .where((record) => record.typeNameFormat == NdefTypeNameFormat.nfcWellknown)
                .map((record) {
              try {
                // Try to decode as text record
                if (record.payload.isNotEmpty) {
                  final status = record.payload[0];
                  final languageCodeLength = status & 0x3F;
                  if (record.payload.length > languageCodeLength + 1) {
                    final textData = record.payload.sublist(languageCodeLength + 1);
                    return String.fromCharCodes(textData);
                  }
                }
                // Fallback: try to decode entire payload
                return String.fromCharCodes(record.payload);
              } catch (e) {
                if (kDebugMode) debugPrint('Error parsing NDEF record: $e');
                return null;
              }
            })
                .where((text) => text != null && text.isNotEmpty)
                .cast<String>()
                .toList();
            
            if (textRecords.isNotEmpty) {
              if (kDebugMode) debugPrint('Type 4 NDEF read successfully: ${textRecords.join(' ')}');
              return textRecords.join(' ');
            }
          }
        } catch (e) {
          if (kDebugMode) debugPrint('Error reading standard NDEF: $e');
        }
      }

      // Check if tag handle contains ISO-DEP information
      try {
        final handle = tag.handle;
        if (handle is Map) {
          if (kDebugMode) {
            debugPrint('Tag handle type: ${handle.runtimeType}');
            debugPrint('Tag handle: $handle');
          }
          
          // Try to extract ID from handle if it's a Map
          if (handle is Map) {
            final handleMap = handle as Map;
            if (handleMap.containsKey('id')) {
              final id = handleMap['id'];
              if (id is List) {
                final idString = id.map((b) {
                  if (b is int) {
                    return b.toRadixString(16).padLeft(2, '0');
                  }
                  return '00';
                }).join('');
                if (kDebugMode) debugPrint('Tag ID from handle: $idString');
                return idString;
              }
            }
          }
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Error processing handle: $e');
      }

      if (kDebugMode) debugPrint('Could not read Type 4 Tag NDEF');
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading Type 4 Tag: $e');
      return null;
    }
  }

  /// Get tag identifier as string
  static String getTagId(NfcTag tag) {
    try {
      final handle = tag.handle;
      if (handle is Map) {
        final handleMap = handle as Map;
        if (handleMap.containsKey('id')) {
          final id = handleMap['id'];
          if (id is List) {
            return id.map((b) {
              if (b is int) {
                return b.toRadixString(16).padLeft(2, '0');
              }
              return '00';
            }).join('');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting tag ID: $e');
    }
    return tag.data.toString();
  }

  /// Check if tag supports Type 4 (ISO-DEP)
  static bool isType4Tag(NfcTag tag) {
    try {
      final handle = tag.handle;
      if (handle is Map) {
        final handleMap = handle as Map;
        // Check for ISO-DEP indicators
        return handleMap.containsKey('isoDep') || 
               handleMap.containsKey('hiLayerResponse') ||
               handleMap.containsKey('historicalBytes');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error checking Type 4: $e');
    }
    // Fallback: check if NDEF is available (most Type 4 tags support NDEF)
    return Ndef.from(tag) != null;
  }
}
