class Drug {
  final String id;
  final String substance;
  final List<String> brands;
  final List<String> typicalDoses;
  final String drugClass;

  const Drug({            //Constructor Drug class
    required this.id,
    required this.substance,
    required this.brands,
    required this.typicalDoses,
    required this.drugClass,
  });

  List<String> allNames() => [   //To return possible names while searching
        substance,
        ...brands,
      ];
}

// 30 συχνά φάρμακα (δραστική + ελληνικές εμπορικές ονομασίες) με ενδεικτικές δοσολογίες.
const List<Drug> drugs = [
  Drug(
    id: 'paracetamol',
    substance: 'Paracetamol',
    brands: ['Depon', 'Panadol', 'Apotel'],
    typicalDoses: ['500-1000 mg κάθε 6-8 ώρες, max 4 g/24h'],
    drugClass: 'Αναλγητικό/Αντιπυρετικό',
  ),
  Drug(
    id: 'ibuprofen',
    substance: 'Ibuprofen',
    brands: ['Nurofen', 'Brufen'],
    typicalDoses: ['200-400 mg κάθε 6-8 ώρες, max 1200-2400 mg/24h'],
    drugClass: 'ΜΣΑΦ',
  ),
  Drug(
    id: 'naproxen',
    substance: 'Naproxen',
    brands: ['Naprosyn', 'Apranax'],
    typicalDoses: ['250-500 mg κάθε 12 ώρες, max 1000 mg/24h'],
    drugClass: 'ΜΣΑΦ',
  ),
  Drug(
    id: 'aspirin',
    substance: 'Acetylsalicylic acid',
    brands: ['Aspirin', 'Bayer'],
    typicalDoses: ['75-100 mg/ημέρα (αντιαιμοπεταλιακό)'],
    drugClass: 'Αντιαιμοπεταλιακό',
  ),
  Drug(
    id: 'amoxiclav',
    substance: 'Amoxicillin/Clavulanic acid',
    brands: ['Augmentin', 'Amoxil CL'],
    typicalDoses: ['875/125 mg κάθε 12 ώρες', '1 g/125 mg κάθε 12 ώρες'],
    drugClass: 'Πενικιλίνη ευρέος φάσματος',
  ),
  Drug(
    id: 'azithromycin',
    substance: 'Azithromycin',
    brands: ['Zithromax', 'Azitro'],
    typicalDoses: ['500 mg/ημέρα x 3 ημέρες', '500 mg την 1η ημέρα, 250 mg x 4 ημέρες'],
    drugClass: 'Μακρολίδη',
  ),
  Drug(
    id: 'clarithromycin',
    substance: 'Clarithromycin',
    brands: ['Klaricid'],
    typicalDoses: ['500 mg κάθε 12 ώρες'],
    drugClass: 'Μακρολίδη',
  ),
  Drug(
    id: 'ciprofloxacin',
    substance: 'Ciprofloxacin',
    brands: ['Ciproxin'],
    typicalDoses: ['500-750 mg κάθε 12 ώρες'],
    drugClass: 'Κινολόνη',
  ),
  Drug(
    id: 'levofloxacin',
    substance: 'Levofloxacin',
    brands: ['Tavanic'],
    typicalDoses: ['500-750 mg/ημέρα'],
    drugClass: 'Κινολόνη',
  ),
  Drug(
    id: 'cefuroxime',
    substance: 'Cefuroxime',
    brands: ['Zinnat'],
    typicalDoses: ['250-500 mg κάθε 12 ώρες'],
    drugClass: 'Κεφαλοσπορίνη 2ης γενιάς',
  ),
  Drug(
    id: 'simvastatin',
    substance: 'Simvastatin',
    brands: ['Zocor', 'Vasilip'],
    typicalDoses: ['10-40 mg άπαξ ημερησίως το βράδυ'],
    drugClass: 'Στατίνη',
  ),
  Drug(
    id: 'atorvastatin',
    substance: 'Atorvastatin',
    brands: ['Lipitor', 'Sortis', 'Atorvast'],
    typicalDoses: ['10-40 mg άπαξ ημερησίως'],
    drugClass: 'Στατίνη',
  ),
  Drug(
    id: 'rosuvastatin',
    substance: 'Rosuvastatin',
    brands: ['Crestor'],
    typicalDoses: ['5-20 mg άπαξ ημερησίως'],
    drugClass: 'Στατίνη',
  ),
  Drug(
    id: 'ramipril',
    substance: 'Ramipril',
    brands: ['Tritace', 'Ramace'],
    typicalDoses: ['2.5-10 mg άπαξ ή δις ημερησίως'],
    drugClass: 'ACEi',
  ),
  Drug(
    id: 'perindopril',
    substance: 'Perindopril',
    brands: ['Coversyl'],
    typicalDoses: ['4-8 mg άπαξ ημερησίως'],
    drugClass: 'ACEi',
  ),
  Drug(
    id: 'valsartan',
    substance: 'Valsartan',
    brands: ['Diovan', 'Tareg'],
    typicalDoses: ['80-160 mg άπαξ ή δις ημερησίως'],
    drugClass: 'ARB',
  ),
  Drug(
    id: 'losartan',
    substance: 'Losartan',
    brands: ['Cozaar', 'Losar'],
    typicalDoses: ['50-100 mg άπαξ ή δις ημερησίως'],
    drugClass: 'ARB',
  ),
  Drug(
    id: 'amlodipine',
    substance: 'Amlodipine',
    brands: ['Norvasc', 'Amlor'],
    typicalDoses: ['5-10 mg άπαξ ημερησίως'],
    drugClass: 'CCB διυδροπυριδίνης',
  ),
  Drug(
    id: 'hctz',
    substance: 'Hydrochlorothiazide',
    brands: ['Hydroton', 'Naturas'],
    typicalDoses: ['12.5-25 mg άπαξ ημερησίως'],
    drugClass: 'Θειαζιδικό διουρητικό',
  ),
  Drug(
    id: 'furosemide',
    substance: 'Furosemide',
    brands: ['Lasix'],
    typicalDoses: ['20-40 mg άπαξ ή δις ημερησίως, εξατομίκευση'],
    drugClass: 'Διουρητικό αγκύλης',
  ),
  Drug(
    id: 'spironolactone',
    substance: 'Spironolactone',
    brands: ['Aldactone', 'Spiroton'],
    typicalDoses: ['25-50 mg άπαξ ημερησίως (ΚΑ/υπ.καλίου)'],
    drugClass: 'Ανταγωνιστής αλδοστερόνης',
  ),
  Drug(
    id: 'metformin',
    substance: 'Metformin',
    brands: ['Glucophage', 'Diabetol'],
    typicalDoses: ['500-1000 mg δύο φορές/ημέρα (μέγ. 2-3 g)'],
    drugClass: 'Biguanide',
  ),
  Drug(
    id: 'insulin_glargine',
    substance: 'Insulin glargine',
    brands: ['Lantus', 'Toujeo'],
    typicalDoses: ['Εξατομίκευση 1x/ημέρα βάσει γλυκόζης'],
    drugClass: 'Βασική ινσουλίνη',
  ),
  Drug(
    id: 'glimepiride',
    substance: 'Glimepiride',
    brands: ['Amaryl'],
    typicalDoses: ['1-4 mg άπαξ ημερησίως με πρωινό'],
    drugClass: 'Σουλφονυλουρία',
  ),
  Drug(
    id: 'sitagliptin',
    substance: 'Sitagliptin',
    brands: ['Januvia'],
    typicalDoses: ['100 mg άπαξ ημερησίως (προσαρμογή σε ΧΝΑ)'],
    drugClass: 'DPP-4 inhibitor',
  ),
  Drug(
    id: 'omeprazole',
    substance: 'Omeprazole',
    brands: ['Losec', 'Loprazol'],
    typicalDoses: ['20-40 mg άπαξ ημερησίως'],
    drugClass: 'PPI',
  ),
  Drug(
    id: 'esomeprazole',
    substance: 'Esomeprazole',
    brands: ['Nexium'],
    typicalDoses: ['20-40 mg άπαξ ημερησίως'],
    drugClass: 'PPI',
  ),
  Drug(
    id: 'sertraline',
    substance: 'Sertraline',
    brands: ['Zoloft'],
    typicalDoses: ['50-100 mg άπαξ ημερησίως (μέγ. 200 mg)'],
    drugClass: 'SSRI',
  ),
  Drug(
    id: 'escitalopram',
    substance: 'Escitalopram',
    brands: ['Cipralex'],
    typicalDoses: ['10-20 mg άπαξ ημερησίως'],
    drugClass: 'SSRI',
  ),
  Drug(
    id: 'clopidogrel',
    substance: 'Clopidogrel',
    brands: ['Plavix', 'Iscover'],
    typicalDoses: ['75 mg άπαξ ημερησίως'],
    drugClass: 'Αντιαιμοπεταλιακό P2Y12',
  ),
  Drug(
    id: 'acenocoumarol',
    substance: 'Acenocoumarol',
    brands: ['Sintrom'],
    typicalDoses: ['Εξατομίκευση βάσει INR (συνήθως 1-4 mg/ημ.)'],
    drugClass: 'Αντιπηκτικό κουμαρινικό',
  ),
  Drug(
    id: 'warfarin',
    substance: 'Warfarin',
    brands: ['Coumadin'],
    typicalDoses: ['Εξατομίκευση βάσει INR (συνήθως 2-10 mg/ημ.)'],
    drugClass: 'Αντιπηκτικό κουμαρινικό',
  ),
  Drug(
    id: 'apixaban',
    substance: 'Apixaban',
    brands: ['Eliquis'],
    typicalDoses: ['5 mg x2 (ή 2.5 mg x2 σε κριτήρια μείωσης)'],
    drugClass: 'DOAC (Xa inhibitor)',
  ),
  Drug(
    id: 'rivaroxaban',
    substance: 'Rivaroxaban',
    brands: ['Xarelto'],
    typicalDoses: ['20 mg άπαξ (ή 15 mg σε κριτήρια μείωσης)'],
    drugClass: 'DOAC (Xa inhibitor)',
  ),
  Drug(
    id: 'dabigatran',
    substance: 'Dabigatran',
    brands: ['Pradaxa'],
    typicalDoses: ['150 mg x2 (ή 110 mg x2 σε κριτήρια μείωσης)'],
    drugClass: 'DOAC (Thrombin inhibitor)',
  ),
  Drug(
    id: 'pantoprazole',
    substance: 'Pantoprazole',
    brands: ['Controloc', 'Pantomed'],
    typicalDoses: ['20-40 mg άπαξ ημερησίως'],
    drugClass: 'PPI',
  ),
  Drug(
    id: 'tramadol',
    substance: 'Tramadol',
    brands: ['Tramal'],
    typicalDoses: ['50-100 mg κάθε 6 ώρες (μέγ. 400 mg/24h)'],
    drugClass: 'Αναλγητικό οπιοειδές',
  ),
  Drug(
    id: 'pregabalin',
    substance: 'Pregabalin',
    brands: ['Lyrica'],
    typicalDoses: ['75-150 mg x2 (μέγ. 600 mg/ημ.)'],
    drugClass: 'Αντιαλγαισθητικό/αντιεπιληπτικό',
  ),
  Drug(
    id: 'alprazolam',
    substance: 'Alprazolam',
    brands: ['Xanax'],
    typicalDoses: ['0.25-0.5 mg 2-3x/ημ (μέγ. ~4 mg/ημ.)'],
    drugClass: 'Βενζοδιαζεπίνη',
  ),
  Drug(
    id: 'diazepam',
    substance: 'Diazepam',
    brands: ['Stedon'],
    typicalDoses: ['2-10 mg 2-3x/ημ (εξατομίκευση)'],
    drugClass: 'Βενζοδιαζεπίνη',
  ),
  Drug(
    id: 'quetiapine',
    substance: 'Quetiapine',
    brands: ['Seroquel'],
    typicalDoses: ['50-400 mg/ημ (ανά ένδειξη)'],
    drugClass: 'Άτυπο αντιψυχωσικό',
  ),
  Drug(
    id: 'amiodarone',
    substance: 'Amiodarone',
    brands: ['Cordarone'],
    typicalDoses: ['Φόρτιση 600-800 mg/ημ, συντήρηση 200 mg/ημ'],
    drugClass: 'Αντιαρρυθμικό',
  ),
  Drug(
    id: 'digoxin',
    substance: 'Digoxin',
    brands: ['Lanoxin'],
    typicalDoses: ['0.125-0.25 mg/ημ (εξατομίκευση σε ΧΝΑ/ηλικιωμένους)'],
    drugClass: 'Καρδιοτονικό γλυκοσίδιο',
  ),
  Drug(
    id: 'bisoprolol',
    substance: 'Bisoprolol',
    brands: ['Concor'],
    typicalDoses: ['1.25-10 mg άπαξ ημερησίως'],
    drugClass: 'Β-αναστολέας',
  ),
  Drug(
    id: 'carvedilol',
    substance: 'Carvedilol',
    brands: ['Dilatrend'],
    typicalDoses: ['6.25-25 mg x2 (ΚΑ/Υπέρταση)'],
    drugClass: 'Β-αναστολέας με α-δράση',
  ),
  Drug(
    id: 'metoprolol',
    substance: 'Metoprolol',
    brands: ['Lopresor', 'Betaloc'],
    typicalDoses: ['50-200 mg/ημ (άπαξ ή δις, βραδείας/άμεσης)'],
    drugClass: 'Β-αναστολέας',
  ),
  Drug(
    id: 'levothyroxine',
    substance: 'Levothyroxine',
    brands: ['T4', 'Euthyrox', 'Thyroxine'],
    typicalDoses: ['50-150 μg άπαξ ημερησίως (πρωί νηστικός)'],
    drugClass: 'Θυρεοειδική ορμόνη',
  ),
  Drug(
    id: 'salbutamol',
    substance: 'Salbutamol',
    brands: ['Ventolin'],
    typicalDoses: ['100-200 μg εισπνοή ανά 4-6 ώρες PRN'],
    drugClass: 'Β2 αγωνιστής βραχείας δράσης',
  ),
  Drug(
    id: 'budesonide',
    substance: 'Budesonide',
    brands: ['Pulmicort'],
    typicalDoses: ['200-800 μg/ημ εισπνεόμενο (συντήρηση)'],
    drugClass: 'Εισπνεόμενο κορτικοστεροειδές',
  ),
  Drug(
    id: 'budesonide_formoterol',
    substance: 'Budesonide/Formoterol',
    brands: ['Symbicort'],
    typicalDoses: ['1-2 εισπνοές x2 (ανά ισχύ)'],
    drugClass: 'ICS/LABA συνδυασμός',
  ),
  Drug(
    id: 'cetirizine',
    substance: 'Cetirizine',
    brands: ['Zyrtec', 'Cezin'],
    typicalDoses: ['10 mg άπαξ ημερησίως'],
    drugClass: 'Αντιισταμινικό 2ης γενιάς',
  ),
  Drug(
    id: 'loratadine',
    substance: 'Loratadine',
    brands: ['Claritin'],
    typicalDoses: ['10 mg άπαξ ημερησίως'],
    drugClass: 'Αντιισταμινικό 2ης γενιάς',
  ),
  Drug(
    id: 'fluconazole',
    substance: 'Fluconazole',
    brands: ['Fungustatin', 'Diflucan'],
    typicalDoses: ['150 mg εφάπαξ (μυκητίαση) ή 100-400 mg/ημ συστηματικά'],
    drugClass: 'Τριαζολικό αντιμυκητιασικό',
  ),
  Drug(
    id: 'doxycycline',
    substance: 'Doxycycline',
    brands: ['Vibramycin'],
    typicalDoses: ['100 mg x2 την 1η ημέρα, έπειτα 100 mg/ημ'],
    drugClass: 'Τετρακυκλίνη',
  ),
  Drug(
    id: 'metronidazole',
    substance: 'Metronidazole',
    brands: ['Flagyl'],
    typicalDoses: ['500 mg κάθε 8-12 ώρες'],
    drugClass: 'Νιτροϊμιδαζόλη',
  ),
  Drug(
    id: 'prednisolone',
    substance: 'Prednisolone',
    brands: ['Prednisolon'],
    typicalDoses: ['5-60 mg/ημ ανά ένδειξη'],
    drugClass: 'Κορτικοστεροειδές συστηματικό',
  ),
];

String _norm(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9α-ωάέίόύήώ]'), '');  // Normalize strings for comparison (remove spaces, special chars, capital letters etc)

Drug? findDrugByName(String input) {   // This function returns a Drug or null
  final needleNorm = _norm(input);    // Normalize input string
  if (needleNorm.isEmpty) return null;
  for (final d in drugs) {     // Loop through drugs
    for (final name in d.allNames()) {  // Loop through all possible names in drug
      final n = _norm(name);
      if (needleNorm == n || needleNorm.contains(n) || n.contains(needleNorm)) {
        return d;
      }
    }
  }
  return null;
}
