import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/drugs.dart';

class ScanMedicationScreen extends StatefulWidget {
  const ScanMedicationScreen({super.key});

  @override
  State<ScanMedicationScreen> createState() => _ScanMedicationScreenState();
}

class _ScanMedicationScreenState extends State<ScanMedicationScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _picker = ImagePicker();
  late final TextRecognizer _textRecognizer = TextRecognizer();

  bool _handled = false;
  bool _processing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    if (capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;

    _handled = true;

    // TODO: Use raw value (e.g. barcode) to prefill add-medication screen.
    Navigator.pop(context, {'name': raw});
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _extractName(String text) {
    final match = findDrugByName(text);
    if (match != null) return _displayNameForSelection(match, text);
    for (final line in text.split(RegExp(r'\r?\n'))) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }

  String _displayNameForSelection(Drug drug, String query) {
    final normalizedQuery = _normalizeSearch(query);
    final normalizedSubstance = _normalizeSearch(drug.substance);
    if (normalizedQuery.isNotEmpty &&
        (normalizedQuery == normalizedSubstance ||
            normalizedSubstance.contains(normalizedQuery))) {
      return drug.substance;
    }
    return drug.brands.isNotEmpty ? drug.brands.first : drug.substance;
  }

  String _normalizeSearch(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  Future<void> _scanFromPhoto() async {
    if (_processing) return;
    setState(() => _processing = true);
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked == null) return;
      final inputImage = InputImage.fromFilePath(picked.path);
      final recognized = await _textRecognizer.processImage(inputImage);
      final text = recognized.text.trim();
      if (text.isEmpty) {
        _showMessage('No text detected.');
        return;
      }
      final match = findDrugByName(text);
      final name = _extractName(text);
      if (name.isEmpty) {
        _showMessage('No medicine name found.');
        return;
      }
      if (!mounted) return;
      final dose =
          match != null && match.typicalDoses.isNotEmpty ? match.typicalDoses.first : '';
      Navigator.pop(context, {'name': name, 'dose': dose});
    } catch (_) {
      if (mounted) {
        _showMessage('Failed to scan the photo.');
      }
    } finally {
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7FAFC);
    const accent = Color(0xFF0BA5A4);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: accent, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Φωτογραφήστε το φάρμακό σας",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.black54),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.black54),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _processing ? 'Επεξεργασία...' : 'Παρακαλώ τοποθετήστε το φάρμακο ώστε να φαίνεται το όνομά',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: _processing ? null : _scanFromPhoto,
                  backgroundColor: accent,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
