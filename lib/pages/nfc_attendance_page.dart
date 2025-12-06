import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import '../utils/nfc_type4_helper.dart';

class Student {
  final String name;
  final String tagId;

  Student({required this.name, required this.tagId});
}

class AttendanceRecord {
  final Student student;
  final DateTime time;

  AttendanceRecord({required this.student, required this.time});
}

class NfcAttendancePage extends StatefulWidget {
  const NfcAttendancePage({super.key});

  @override
  State<NfcAttendancePage> createState() => _NfcAttendancePageState();
}

class _NfcAttendancePageState extends State<NfcAttendancePage> {
  // 1) قائمة الطلاب – tagId حتعدّلها بعد ما تقرأ الكروت
  final List<Student> students = [
    Student(name: 'Ahmed', tagId: 'TAG_ID_1'),
    Student(name: 'Salem', tagId: 'TAG_ID_2'),
    Student(name: 'Mazen', tagId: 'TAG_ID_3'),
  ];

  final List<AttendanceRecord> attendance = [];
  String status = 'اضغط على الزر وقرّب كرت NFC';

  Future<void> _startNfcSession() async {
    final isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        status = 'NFC غير متوفر على هذا الجهاز';
      });
      return;
    }

    setState(() {
      status = 'قرّب الكرت من الجهاز...';
    });

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          // 👇 اطبع البيانات عشان تعرف شكل الـ ID في الكونسول
          debugPrint('NFC Tag: ${tag.data}');
          debugPrint('Tag Handle: ${tag.handle}');

          String rawId = NfcType4Helper.getTagId(tag);

          // محاولة قراءة Type 4 Tag أولاً (الأكثر دقة)
          final type4Ndef = await NfcType4Helper.readType4Ndef(tag);
          if (type4Ndef != null && type4Ndef.isNotEmpty) {
            rawId = type4Ndef;
            debugPrint('Type 4 NDEF Message: $rawId');
          } else {
            // Fallback: محاولة قراءة NDEF message باستخدام الطريقة العادية
            final ndef = Ndef.from(tag);
            if (ndef != null) {
              try {
                final ndefMessage = await ndef.read();
                if (ndefMessage.records.isNotEmpty) {
                  // استخراج النص من NDEF record
                  final textRecord = ndefMessage.records.first;
                  rawId = String.fromCharCodes(textRecord.payload);
                  debugPrint('Standard NDEF Message: $rawId');
                }
              } catch (e) {
                debugPrint('Error reading standard NDEF: $e');
              }
            }
          }

          // بعد ما تعرف شكلها، انسخ الجزء الفريد وخلّيه الـ tagId في قائمة الطلاب
          final Student student = students.firstWhere(
            (s) => rawId.contains(s.tagId),
            orElse: () => Student(name: 'غير مسجّل', tagId: ''),
          );

          debugPrint('Raw ID: $rawId');
          setState(() {
            if (student.tagId.isEmpty) {
              status = 'كرت غير معروف (مش مربوط بأي طالب)';
            } else {
              // التحقق من عدم تكرار التسجيل
              final alreadyRecorded = attendance.any(
                (record) => record.student.tagId == student.tagId &&
                    record.time.difference(DateTime.now()).inMinutes.abs() < 1,
              );
              
              if (alreadyRecorded) {
                status = 'تم تسجيل حضور ${student.name} مسبقاً';
              } else {
                attendance.add(
                  AttendanceRecord(student: student, time: DateTime.now()),
                );
                status = 'تم تسجيل حضور: ${student.name}';
              }
            }
          });

          await NfcManager.instance.stopSession();
        } catch (e) {
          debugPrint('Error processing NFC tag: $e');
          setState(() {
            status = 'خطأ في قراءة الكرت';
          });
          await NfcManager.instance.stopSession();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Attendance')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(status, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _startNfcSession,
            child: const Text('ابدأ قراءة NFC'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'سجل الحضور',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: attendance.length,
              itemBuilder: (context, index) {
                final record = attendance[index];
                return ListTile(
                  title: Text(record.student.name),
                  subtitle: Text(record.time.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

