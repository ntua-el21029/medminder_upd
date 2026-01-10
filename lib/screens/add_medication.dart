import 'package:flutter/material.dart';

class AddMedicationScreen extends StatelessWidget {
  const AddMedicationScreen({super.key});

  static const bg = Color(0xFFF7FAFC);
  static const accent = Color(0xFF0BA5A4);

  Future<void> _goManual(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/add-manual');
    if (context.mounted && result is Map) {
      Navigator.pop(context, result);
    }
  }

  Future<void> _goScan(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/scan');
    if (!context.mounted) return;
    Map<String, dynamic>? args;
    if (result is String && result.trim().isNotEmpty) {
      args = {'name': result.trim()};
    } else if (result is Map) {
      final name = (result['name'] ?? '').toString().trim();
      if (name.isNotEmpty) {
        args = {
          'name': name,
          'dose': (result['dose'] ?? '').toString(),
          'notes': (result['notes'] ?? '').toString(),
        };
      }
    }
    if (args != null) {
      final manualResult = await Navigator.pushNamed(
        context,
        '/add-manual',
        arguments: args,
      );
      if (context.mounted && manualResult is Map) {
        Navigator.pop(context, manualResult);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: accent, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Προσθήκη φαρμάκου',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Διάλεξε τρόπο προσθήκης:',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _goScan(context),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: accent, width: 2),
                ),
                child: const Icon(Icons.photo_camera_outlined, size: 24, color: accent),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'ή',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () => _goManual(context),
                child: const Text(
                  'Χειροκίνητη προσθήκη',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
