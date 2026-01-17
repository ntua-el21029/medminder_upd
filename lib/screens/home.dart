import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../state/app_state.dart';
import '../data/interactions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const bg = Color(0xFFF7FAFC);
  static const accent = Color(0xFF0BA5A4);
  static const _medicationsStorageKey = 'medications';

  final List<MedicationItem> _items = [];
  String _displayName = '';

  @override
  void initState() {
    super.initState();
    NotificationService().init();
    AppState().loadSettings();
    _loadProfile();
    _loadMedications();
  }


  Future<void> _loadProfile() async {
    await AppState().loadProfile();
    if (!mounted) return;
    setState(() {
      _displayName = AppState().name.trim();
    });
  }

  Future<void> _goToAdd() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result is Map) {
      await AppState().loadSettings();
      final settings = AppState();
      final allowNotifications =
          settings.notificationsEnabled && settings.medicineReminderEnabled;
      final name = (result['name'] ?? '').toString();
      final dose = (result['dose'] ?? '').toString();
      final notes = (result['notes'] ?? '').toString();
      final time = _extractTime(result['time']);
      final time2 = _extractTime(result['time2']);
      if (name.isEmpty) return;

      final interaction = _findInteractionWithExisting(name);
      if (interaction != null && mounted) {
        await _showInteractionDialog(interaction);
        return;
      }

      final item = MedicationItem(
        name: name,
        dose: dose,
        time: time,
        time2: time2,
        notes: notes,
      );
      setState(() => _items.add(item));
      await _persistMedications();

      if (allowNotifications && time != null) {
        await NotificationService().scheduleDaily(
          id: '${name}_${_formatTime(time)}',
          title: 'Ώρα για $name',
          body: dose.isNotEmpty ? 'Δοσολογία: $dose' : 'Πάρε το φάρμακό σου',
          time: time,
        );
      }
      if (allowNotifications && time2 != null) {
        await NotificationService().scheduleDaily(
          id: '${name}_${_formatTime(time2)}',
          title: 'I?I?Iñ I3I1Iñ $name',
          body: dose.isNotEmpty ? 'I"I¨IŸI¨I¯I¨I3I_Iñ: $dose' : 'IÿIªI?Iæ I,I¨ I+IªI?I¬IñI§IO IŸI¨I.',
          time: time2,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Προστέθηκε το $name${time != null ? ' και μπήκε υπενθύμιση.' : '.'}')),
      );
    }
  }

  TimeOfDay? _extractTime(dynamic raw) {
    if (raw is TimeOfDay) return raw;
    final value = raw?.toString() ?? '';
    if (value.trim().isEmpty) return null;
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(value);
    if (match == null) return null;
    final h = int.tryParse(match.group(1)!);
    final m = int.tryParse(match.group(2)!);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '--:--';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  InteractionResult? _findInteractionWithExisting(String newName) {
    for (final item in _items) {
      final result = findInteractionByInput(newName, item.name);
      if (result != null && result.hasHit) return result;
    }
    return null;
  }

  Future<void> _showInteractionDialog(InteractionResult result) {
    final interaction = result.interaction!;
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        title: Row(
          children: const [
            Icon(Icons.error, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Expanded(
              child: Text('Εντοπίστηκε Αλληλεπίδραση', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        content: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.red, width: 3)),
          ),
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            '${result.drugA.substance} + ${result.drugB.substance}\n'
            'Σοβαρότητα: ${interaction.severity}\n'
            'Περιγραφή: \n ${interaction.description}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: accent),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          _displayName.isEmpty ? '\u0393\u03b5\u03b9\u03ac \u03c3\u03bf\u03c5!' : '\u0393\u03b5\u03b9\u03ac \u03c3\u03bf\u03c5, $_displayName!',
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.person, color: accent, size: 32),
          onPressed: () async {
            await Navigator.pushNamed(context, '/profile');
            await _loadProfile();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: accent, size: 32),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: _items.isEmpty ? _buildEmpty() : _buildList(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'interactionFab',
              backgroundColor: accent,
              foregroundColor: Colors.white,
              elevation: 2,
              onPressed: () => Navigator.pushNamed(context, '/interaction'),
              child: const Icon(Icons.science),
            ),
            FloatingActionButton(
              heroTag: 'addFab',
              backgroundColor: accent,
              onPressed: _goToAdd,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.medication_outlined, size: 42, color: accent),
          SizedBox(height: 12),
          Text(
            'Δεν έχεις φάρμακα στη λίστα.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Πρόσθεσε ένα φάρμακο για να δεις υπενθυμίσεις.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: ValueKey('${item.name}_${item.formattedTimes}_$index'),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 28),
          ),
          confirmDismiss: (_) => _confirmDelete(item),
          onDismissed: (_) async {
            if (item.time != null) {
              await NotificationService().cancelDaily(
                id: '${item.name}_${_formatTime(item.time)}',
              );
            }
            if (item.time2 != null) {
              await NotificationService().cancelDaily(
                id: '${item.name}_${_formatTime(item.time2)}',
              );
            }
            if (!mounted) return;
            setState(() => _items.removeAt(index));
            await _persistMedications();
          },
          child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
            padding: const EdgeInsets.all(14),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.medication, color: accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  Text(
                      item.formattedTimes,
                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (item.dose.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Δόση: ${item.dose}', style: const TextStyle(color: Colors.black87)),
              ],
              if (item.notes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text('Σημειώσεις: ${item.notes}', style: const TextStyle(color: Colors.black54)),
              ],
            ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDelete(MedicationItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Διαγραφή φαρμάκου;'),
        content: Text('Θέλεις να αφαιρέσεις το ${item.name} από τη λίστα;'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Άκυρο'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text('Διαγραφή'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_medicationsStorageKey);
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is! List) return;
    final loaded = <MedicationItem>[];
    for (final item in decoded) {
      if (item is Map) {
        final mapped = MedicationItem.fromMap(Map<String, dynamic>.from(item));
        if (mapped != null) loaded.add(mapped);
      }
    }
    if (!mounted) return;
    setState(() {
      _items
        ..clear()
        ..addAll(loaded);
    });
  }

  Future<void> _persistMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _items.map((item) => item.toMap()).toList();
    await prefs.setString(_medicationsStorageKey, jsonEncode(payload));
  }
}

class MedicationItem {
  final String name;
  final String dose;
  final TimeOfDay? time;
  final TimeOfDay? time2;
  final String notes;

  MedicationItem({
    required this.name,
    required this.dose,
    required this.time,
    required this.time2,
    required this.notes,
  });

  String get formattedTimes {
    final parts = <String>[];
    if (time != null) {
      parts.add('${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}');
    }
    if (time2 != null) {
      parts.add('${time2!.hour.toString().padLeft(2, '0')}:${time2!.minute.toString().padLeft(2, '0')}');
    }
    return parts.isEmpty ? '--:--' : parts.join(' / ');
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dose': dose,
      'time': _encodeTime(time),
      'time2': _encodeTime(time2),
      'notes': notes,
    };
  }

  static MedicationItem? fromMap(Map<String, dynamic> map) {
    final name = (map['name'] ?? '').toString();
    if (name.isEmpty) return null;
    return MedicationItem(
      name: name,
      dose: (map['dose'] ?? '').toString(),
      time: _decodeTime(map['time']),
      time2: _decodeTime(map['time2']),
      notes: (map['notes'] ?? '').toString(),
    );
  }

  static String? _encodeTime(TimeOfDay? time) {
    if (time == null) return null;
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static TimeOfDay? _decodeTime(dynamic value) {
    final raw = value?.toString() ?? '';
    if (raw.isEmpty) return null;
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
    if (match == null) return null;
    final h = int.tryParse(match.group(1)!);
    final m = int.tryParse(match.group(2)!);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }
}
