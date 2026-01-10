import 'package:flutter/material.dart';
import '../state/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool medicineReminder = true;
  bool pushNotifications = true;
  bool smartwatchConfirm = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await AppState().loadSettings();
    if (!mounted) return;
    final state = AppState();
    setState(() {
      medicineReminder = state.medicineReminderEnabled;
      pushNotifications = state.notificationsEnabled;
      smartwatchConfirm = state.smartwatchConfirmEnabled;
      _loading = false;
    });
  }

  void _saveSettings() {
    AppState().saveSettings(
      medicineReminderEnabled: medicineReminder,
      notificationsEnabled: pushNotifications,
      smartwatchConfirmEnabled: smartwatchConfirm,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7FAFC);
    const accent = Color(0xFF0BA5A4);
    const card = Color(0xFFF6EEF6);

    Widget settingTile({
      required String title,
      required bool value,
      required ValueChanged<bool> onChanged,
    }) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: value,
              activeTrackColor: accent,
              onChanged: onChanged,
            ),
          ],
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
        centerTitle: true,
        title: const Text(
          'Ρυθμίσεις',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            settingTile(
              title: 'Υπενθύμιση φαρμάκου',
              value: medicineReminder,
              onChanged: (v) {
                setState(() => medicineReminder = v);
                _saveSettings();
              },
            ),
            settingTile(
              title: 'Ειδοποιήσεις push',
              value: pushNotifications,
              onChanged: (v) {
                setState(() => pushNotifications = v);
                _saveSettings();
              },
            ),
            settingTile(
              title: 'Επιβεβαίωση από Smart Watch',
              value: smartwatchConfirm,
              onChanged: (v) {
                setState(() => smartwatchConfirm = v);
                _saveSettings();
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: const Text(
                  'Προφίλ χρήστη',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
