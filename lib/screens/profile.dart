import 'package:flutter/material.dart';
import '../data/drugs.dart';
import '../state/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color accent = Color(0xFF0BA5A4);

  final _nameController = TextEditingController();
  DateTime? _birthDate;
  late Set<String> _selectedAllergies;
  String _gender = 'Άνδρας';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedAllergies = {};
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 20, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Επίλεξε ημερομηνία γέννησης',
      cancelText: 'Άκυρο',
      confirmText: 'OK',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: accent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'dd/mm/yyyy';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  List<String> _allergyOptions() {
    final items = drugs.map((d) => d.substance).toSet().toList();
    items.sort();
    return items;
  }

  Future<void> _loadProfile() async {
    await AppState().loadProfile();
    if (!mounted) return;
    final state = AppState();
    setState(() {
      _nameController.text = state.name;
      _birthDate = state.birthDate;
      _gender = state.gender;
      _selectedAllergies = {...state.allergies};
      _loading = false;
    });
  }

  Future<void> _save() async {
    await AppState().saveProfile(
      name: _nameController.text.trim(),
      birthDate: _birthDate,
      gender: _gender,
      allergies: _selectedAllergies,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Αποθηκεύτηκαν τα στοιχεία.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7FAFC);
    final allergyOptions = _allergyOptions();
    final listHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'Στοιχεία Προφίλ',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: accent, size: 32),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(minHeight: 3),
            ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Όνομα',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickBirthDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Ημερομηνία γέννησης',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today, color: accent, size: 24),
              ),
              child: Text(_formatDate(_birthDate)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _GenderSegment(
                  text: 'Άνδρας',
                  selected: _gender == 'Άνδρας',
                  accent: accent,
                  onTap: () => setState(() => _gender = 'Άνδρας'),
                ),
                _GenderSegment(
                  text: 'Γυναίκα',
                  selected: _gender == 'Γυναίκα',
                  accent: accent,
                  onTap: () => setState(() => _gender = 'Γυναίκα'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Αλλεργίες',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: listHeight,
            child: ListView.builder(
              itemCount: allergyOptions.length,
              itemBuilder: (context, index) {
                final a = allergyOptions[index];
                final checked = _selectedAllergies.contains(a);
                return CheckboxListTile(
                  value: checked,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selectedAllergies.add(a);
                      } else {
                        _selectedAllergies.remove(a);
                      }
                    });
                  },
                  title: Text(a),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: accent,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _save,
          child: const Text('Αποθήκευση'),
        ),
      ),
    );
  }
}

class _GenderSegment extends StatelessWidget {
  final String text;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _GenderSegment({
    required this.text,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? accent : Colors.transparent;
    final fg = selected ? Colors.white : const Color(0xFF49454F);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: fg),
          ),
        ),
      ),
    );
  }
}

