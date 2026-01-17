import 'package:flutter/material.dart';
import '../data/interactions.dart';
import '../data/drugs.dart';

class InteractionCheckScreen extends StatefulWidget {
  const InteractionCheckScreen({super.key});

  @override
  State<InteractionCheckScreen> createState() => _InteractionCheckScreenState();
}



class _InteractionCheckScreenState extends State<InteractionCheckScreen> {
  final _drug1 = TextEditingController();
  final _drug2 = TextEditingController();

  

  @override
  void dispose() {
    _drug1.dispose();
    _drug2.dispose();
    super.dispose();
  }

  Color _severityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'high':
        return Colors.red.shade400;
      case 'moderate':
        return Colors.orange.shade400;
      case 'low':
        return Colors.green.shade500;
      default:
        return Colors.blueGrey.shade400;
    }
  }

  String _severityLabel(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'high':
        return 'Υψηλή';
      case 'moderate':
        return 'Μέτρια';
      case 'low':
        return 'Χαμηλή';
      default:
        return 'Άγνωστο';
    }
  }

  Future<void> _showResultDialog({
    required String title,
    required String message,
    String? severity,
  }) async {
    final color = _severityColor(severity);
    final label = _severityLabel(severity);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: const Color(0xFFF7F2FF),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (severity != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(height: 1.5, fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ΟΚ'),
            ),
          ],
        );
      },
    );
  }

  void _check() {
    final a = _drug1.text.trim();
    final b = _drug2.text.trim();

    if (a.isEmpty || b.isEmpty) {
      _showResultDialog(
        title: 'Λείπουν στοιχεία',
        message: 'Συμπλήρωσε και τα 2 πεδία για να γίνει ο έλεγχος.',
      );
      return;
    }

    final result = findInteractionByInput(a, b);

    if (result == null) {
      _showResultDialog(
        title: 'Δεν αναγνωρίστηκε',
        message: 'Δεν βρήκα αυτά τα φάρμακα στη λίστα (~60 καταχωρήσεις). Δοκίμασε διαφορετική ονομασία ή brand.',
      );
      return;
    }

    if (!result.hasHit) {
      _showResultDialog(
        title: 'Δεν υπάρχει αλληλεπίδραση',
        message:
            'Δεν υπάρχει αλληλεπίδραση για:\n${result.drugA.substance} + ${result.drugB.substance}.',
        severity: 'Low',
      );
      return;
    }

    final i = result.interaction!;
    _showResultDialog(
      title: 'Αλληλεπίδραση',
      severity: i.severity,
      message:
          '${i.description}\n\nΖεύγος: ${result.drugA.substance} + ${result.drugB.substance}\n}',
    );
  }

  bool _showSuggestions1 = true;
  bool _showSuggestions2 = true;

  String _normalizeSearch(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  String _displayNameForSelection(Drug drug, String query) {
    final normalizedQuery = _normalizeSearch(query);
    final normalizedSubstance = _normalizeSearch(drug.substance);
    if (normalizedQuery.isNotEmpty &&
        (normalizedQuery == normalizedSubstance ||
            normalizedSubstance.contains(normalizedQuery))) {
      return drug.substance;
    }
    return _preferredDisplayName(drug);
  }

  String _preferredDisplayName(Drug drug) {
    if (drug.brands.isNotEmpty) return drug.brands.first;
    return drug.substance;
  }

  void _selectSuggestion1(Drug d) {
    setState(() {
      _drug1.text = _displayNameForSelection(d, _drug1.text.trim());
      _showSuggestions1 = false;
    });
  }

  void _selectSuggestion2(Drug d) {
    setState(() {
      _drug2.text = _displayNameForSelection(d, _drug2.text.trim());
      _showSuggestions2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7FAFC);
    const accent = Color(0xFF0BA5A4);

    InputDecoration deco(String hint, TextEditingController c) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFEDE7F6).withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: c.text.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close, color: accent, size: 24),
                onPressed: () {
                  c.clear();
                  setState(() {});
                },
              ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: accent, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Έλεγχος αλληλεπίδρασης',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _drug1,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.next,
              decoration: deco('Φάρμακο 1 (π.χ. Sintrom, Tritace, Zoloft)', _drug1),
            ),
            if (_drug1.text.trim().isNotEmpty && _showSuggestions1)
              _SuggestionList(
                query: _drug1.text.trim(),
                onPick: _selectSuggestion1,
              ),
            const SizedBox(height: 14),
            TextField(
              controller: _drug2,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _check(),
              decoration: deco('Φάρμακο 2 (π.χ. Augmentin, Aldactone, Tramal)', _drug2),
            ),
            if (_drug2.text.trim().isNotEmpty && _showSuggestions2) 
              _SuggestionList(
                query: _drug2.text.trim(),
                onPick: _selectSuggestion2,
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                onPressed: _check,
                child: const Text(
                  'Έλεγχος',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Ενδεικτικά δεδομένα. Ο έλεγχος δεν αντικαθιστά ιατρική συμβουλή.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  final String query;
  final ValueChanged<Drug> onPick;

  const _SuggestionList({
    required this.query,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final list = drugs.where((d) {
      final names = d.allNames().map((n) => n.toLowerCase());
      return q.isEmpty || names.any((n) => n.contains(q));
    }).toList();

    if (list.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      constraints: const BoxConstraints(maxHeight: 240),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: list.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final d = list[index];
          final brands = d.brands.join(', ');
          return ListTile(
            title: Text(d.substance),
            subtitle: brands.isEmpty ? null : Text(brands),
            onTap: () => onPick(d),
          );
        },
      ),
    );
  }
}


