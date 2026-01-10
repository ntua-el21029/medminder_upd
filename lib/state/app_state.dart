import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  AppState._internal();
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;

  String name = '';
  DateTime? birthDate;
  String gender = 'Άνδρας';
  final Set<String> allergies = {};
  bool medicineReminderEnabled = true;
  bool notificationsEnabled = true;
  bool smartwatchConfirmEnabled = true;

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('profile_name') ?? '';
    final birth = prefs.getString('profile_birth_date');
    birthDate = birth == null || birth.isEmpty ? null : DateTime.tryParse(birth);
    gender = prefs.getString('profile_gender') ?? 'Άνδρας';
    final storedAllergies = prefs.getStringList('profile_allergies') ?? [];
    allergies
      ..clear()
      ..addAll(storedAllergies);
  }


  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    medicineReminderEnabled = prefs.getBool('settings_med_reminder') ?? true;
    notificationsEnabled = prefs.getBool('settings_notifications') ?? true;
    smartwatchConfirmEnabled = prefs.getBool('settings_smartwatch') ?? true;
  }

  Future<void> saveProfile({
    required String name,
    required DateTime? birthDate,
    required String gender,
    required Iterable<String> allergies,
  }) async {
    this.name = name;
    this.birthDate = birthDate;
    this.gender = gender;
    this.allergies
      ..clear()
      ..addAll(allergies);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', this.name);
    await prefs.setString('profile_gender', this.gender);
    await prefs.setStringList('profile_allergies', this.allergies.toList());
    if (this.birthDate == null) {
      await prefs.remove('profile_birth_date');
    } else {
      await prefs.setString('profile_birth_date', this.birthDate!.toIso8601String());
    }
  }

  Future<void> saveSettings({
    required bool medicineReminderEnabled,
    required bool notificationsEnabled,
    required bool smartwatchConfirmEnabled,
  }) async {
    this.medicineReminderEnabled = medicineReminderEnabled;
    this.notificationsEnabled = notificationsEnabled;
    this.smartwatchConfirmEnabled = smartwatchConfirmEnabled;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('settings_med_reminder', this.medicineReminderEnabled);
    await prefs.setBool('settings_notifications', this.notificationsEnabled);
    await prefs.setBool('settings_smartwatch', this.smartwatchConfirmEnabled);
  }

}
