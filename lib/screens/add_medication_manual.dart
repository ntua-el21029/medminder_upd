import 'package:flutter/material.dart';
import '../data/drugs.dart';
import '../state/app_state.dart';

class AddMedicationManualScreen extends StatefulWidget {
  const AddMedicationManualScreen({super.key});

  @override
  State<AddMedicationManualScreen> createState() => _AddMedicationManualScreenState();
}

class _AddMedicationManualScreenState extends State<AddMedicationManualScreen> {
  static const Color accent = Color(0xFF0BA5A4);

  final _searchController = TextEditingController();
  final _doseController = TextEditingController();
  final _notesController = TextEditingController();

  TimeOfDay? _time1;
  TimeOfDay? _time2;
  bool _showSuggestions = true;
  bool _suppressSuggestionOpen = false;
  bool _loadedInitial = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_suppressSuggestionOpen) {
        _suppressSuggestionOpen = false;
        return;
      }
      setState(() => _showSuggestions = true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedInitial) return;
    _loadedInitial = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    String? initialName;
    String? initialDose;
    String? initialNotes;
    if (args is String) {
      initialName = args;
    } else if (args is Map && args['name'] != null) {
      initialName = args['name'].toString();
      if (args['dose'] != null) initialDose = args['dose'].toString();
      if (args['notes'] != null) initialNotes = args['notes'].toString();
    }
    if (initialName == null || initialName.trim().isEmpty) return;
    final resolved = findDrugByName(initialName);
    final displayName = resolved == null
        ? initialName.trim()
        : _displayNameForSelection(resolved, initialName.trim());
    _suppressSuggestionOpen = true;
    setState(() {
      _searchController.text = displayName;
      if (initialDose != null && initialDose.trim().isNotEmpty) {
        _doseController.text = initialDose.trim();
      }
      if (initialNotes != null && initialNotes.trim().isNotEmpty) {
        _notesController.text = initialNotes.trim();
      }
      _showSuggestions = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _doseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return 'Δεν έχει οριστεί';
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  void _save() {
    final input = _searchController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Παρακαλώ συμπλήρωσε το φάρμακο.')),
      );
      return;
    }
    final drug = findDrugByName(input);
    if ((drug != null && _isAllergic(drug)) || _isAllergicName(input)) {
      _showAllergyDialog(input);
      return;
    }
    if (_time1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Διάλεξε ώρα λήψης.')),
      );
      return;
    }

    Navigator.pop(context, {
      'name': input,
      'dose': _doseController.text.trim(),
      'notes': _notesController.text.trim(),
      'time': _formatTime(_time1),
      'time2': _time2 == null ? '' : _formatTime(_time2),
    });
  }

  void _showMedicineList() {
    final q = _searchController.text.trim().toLowerCase();
    final list = drugs.where((d) {
      final names = d.allNames().map((n) => n.toLowerCase());
      return q.isEmpty || names.any((n) => n.contains(q));
    }).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  'Επίλεξε φάρμακο από τη λίστα',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final d = list[index];
                    final displayName = _displayNameForSelection(
                      d,
                      _searchController.text.trim(),
                    );
                    final brands = d.brands.join(', ');
                    final dose = d.typicalDoses.isNotEmpty ? d.typicalDoses.first : '';
                    return ListTile(
                      title: Text(d.substance),
                      subtitle: brands.isEmpty ? null : Text(brands),
                      onTap: () {
                        if (_isAllergic(d)) {
                          Navigator.pop(context);
                          _showAllergyDialog(d.substance);
                          return;
                        }
                        String doseField = dose;
                        String notesField = '';
                        if (dose.contains(',')) {
                          final parts = dose.split(',');
                          doseField = parts.first.trim();
                          final rest = parts.skip(1).join(',').trim();
                          if (rest.isNotEmpty) {
                            notesField = rest;
                          }
                        }
                        setState(() {
                          _searchController.text = displayName;
                          _doseController.text = doseField;
                          _notesController.text = notesField;
                          _showSuggestions = false;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectSuggestion(Drug d) {
    if (_isAllergic(d)) {
      _showAllergyDialog(d.substance);
      return;
    }
    final dose = d.typicalDoses.isNotEmpty ? d.typicalDoses.first : '';
    String doseField = dose;
    String notesField = '';
    if (dose.contains(',')) {
      final parts = dose.split(',');
      doseField = parts.first.trim();
      final rest = parts.skip(1).join(',').trim();
      if (rest.isNotEmpty) {
        notesField = rest;
      }
    }
    setState(() {
      _searchController.text =
          _displayNameForSelection(d, _searchController.text.trim());
      _doseController.text = doseField;
      _notesController.text = notesField;
      _showSuggestions = false;
    });
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

  String _normalizeSearch(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  bool _isAllergic(Drug drug) {
    final allergies = AppState().allergies.map((a) => a.toLowerCase()).toSet();
    if (allergies.isEmpty) return false;
    final names = drug.allNames().map((n) => n.toLowerCase());
    return names.any((n) => allergies.any((a) => n.contains(a) || a.contains(n)));
  }

  bool _isAllergicName(String name) {
    final allergies = AppState().allergies.map((a) => a.toLowerCase()).toSet();
    if (allergies.isEmpty) return false;
    final n = name.toLowerCase();
    return allergies.any((a) => n.contains(a) || a.contains(n));
  }

  void _showAllergyDialog(String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          title: Row(
            children: const [
              Icon(Icons.error, color: Colors.red, size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text('Αλλεργία σε φάρμακο', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          content: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Colors.red, width: 3)),
            ),
            padding: const EdgeInsets.only(left: 12),
            child: Text('Είσαι αλλεργικός σε αυτό το φάρμακο: $name.'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: accent),
              child: const Text('ΟΚ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7FAFC);
    const fieldBg = Color(0xFFECE6F0);

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
          'Προσθήκη φαρμάκου',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Φάρμακο (π.χ. Sintrom, Tritace, Zoloft)',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.menu, color: accent, size: 24),
                  onPressed: _showMedicineList,
                ),
                suffixIcon: const Icon(Icons.search, color: accent, size: 24),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (_showSuggestions && _searchController.text.trim().isNotEmpty)
            _SuggestionList(
              query: _searchController.text.trim(),
              onPick: _selectSuggestion,
            ),
          const SizedBox(height: 28),

          _LabeledField(
            controller: _doseController,
            label: 'Δοσολογία',
            onClear: () => setState(() => _doseController.clear()),
          ),
          const SizedBox(height: 18),

          _LabeledField(
            controller: _notesController,
            label: 'Σημειώσεις',
            onClear: () => setState(() => _notesController.clear()),
          ),
          const SizedBox(height: 26),

          // Time dropdowns
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ώρα λήψης',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _TimeDropdown(
                  value: _time1,
                  onChanged: (t) => setState(() => _time1 = t),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Second time (optional)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ώρα λήψης 2 (προαιρετικό)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _TimeDropdown(
                  value: _time2,
                  onChanged: (t) => setState(() => _time2 = t),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Save button
          Center(
            child: SizedBox(
              width: 220,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: _save,
                child: const Text('Αποθήκευση', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _LabeledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onClear;

  const _LabeledField({
    required this.controller,
    required this.label,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    const fieldBg = Color(0xFFECE6F0);
    const accent = Color(0xFF0BA5A4);

    return Container(
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: accent, size: 24),
            onPressed: onClear,
          ),
        ),
      ),
    );
  }
}

class _TimeDropdown extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;

  const _TimeDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0BA5A4);
    final hours = List<int>.generate(24, (i) => i);
    final minutes = List<int>.generate(60, (i) => i);
    final selectedHour = value?.hour;
    final selectedMinute = value?.minute;

    return Row(
      children: [
        const Icon(Icons.access_time, color: accent, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedHour,
                    hint: const Text('HH'),
                    isExpanded: true,
                    items: hours
                        .map(
                          (h) => DropdownMenuItem(
                            value: h,
                            child: Text(h.toString().padLeft(2, '0')),
                          ),
                        )
                        .toList(),
                    onChanged: (h) {
                      if (h == null) return;
                      onChanged(TimeOfDay(hour: h, minute: selectedMinute ?? 0));
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(':', style: TextStyle(fontSize: 18)),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedMinute,
                    hint: const Text('MM'),
                    isExpanded: true,
                    items: minutes
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.toString().padLeft(2, '0')),
                          ),
                        )
                        .toList(),
                    onChanged: (m) {
                      if (m == null) return;
                      onChanged(TimeOfDay(hour: selectedHour ?? 0, minute: m));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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







