import 'drugs.dart';

class Interaction {
  final String aId;
  final String bId;
  final String severity; // Low, Moderate, High
  final String description;

  const Interaction({    // Constructor for Interaction class
    required this.aId,
    required this.bId,
    required this.severity,
    required this.description,
  });

  bool matches(String id1, String id2) =>
      (id1 == aId && id2 == bId) || (id1 == bId && id2 == aId);
}

// List of Interaction objects defining known drug interactions
const List<Interaction> interactions = [
  Interaction(
    aId: 'clopidogrel',
    bId: 'omeprazole',
    severity: 'Moderate',
    description: 'Τα PPI μειώνουν τη δράση της κλοπιδογρέλης. Προτιμήστε άλλο PPI αν γίνεται.',
  ),
  Interaction(
    aId: 'clopidogrel',
    bId: 'esomeprazole',
    severity: 'Moderate',
    description: 'Πιθανή μείωση δράσης κλοπιδογρέλης. Προτιμήστε pantoprazole.',
  ),
  Interaction(
    aId: 'simvastatin',
    bId: 'clarithromycin',
    severity: 'High',
    description: 'Η κλαριθρομυκίνη αυξάνει πολύ τη σιμβαστατίνη → κίνδυνος μυών. Διακοπή/εναλλακτική.',
  ),
  Interaction(
    aId: 'atorvastatin',
    bId: 'clarithromycin',
    severity: 'Moderate',
    description: 'Αυξάνει τα επίπεδα ατορβαστατίνης. Σκέψου μείωση δόσης/εναλλακτική.',
  ),
  Interaction(
    aId: 'simvastatin',
    bId: 'fluconazole',
    severity: 'Moderate',
    description: 'Το fluconazole αυξάνει τη σιμβαστατίνη → κίνδυνος μυών.',
  ),
  Interaction(
    aId: 'atorvastatin',
    bId: 'fluconazole',
    severity: 'Moderate',
    description: 'Το fluconazole αυξάνει την ατορβαστατίνη → κίνδυνος μυών.',
  ),
  Interaction(
    aId: 'warfarin',
    bId: 'fluconazole',
    severity: 'High',
    description: 'Αυξάνει πολύ το INR. Χρειάζεται συχνός έλεγχος/μείωση δόσης.',
  ),
  Interaction(
    aId: 'acenocoumarol',
    bId: 'fluconazole',
    severity: 'High',
    description: 'Αυξάνει το INR. Χρειάζεται συχνός έλεγχος/προσαρμογή.',
  ),
  Interaction(
    aId: 'warfarin',
    bId: 'metronidazole',
    severity: 'High',
    description: 'Αυξάνει το INR. Χρειάζεται συχνός έλεγχος/μείωση δόσης.',
  ),
  Interaction(
    aId: 'acenocoumarol',
    bId: 'metronidazole',
    severity: 'High',
    description: 'Αυξάνει το INR. Χρειάζεται έλεγχος/προσαρμογή.',
  ),
  Interaction(
    aId: 'warfarin',
    bId: 'amiodarone',
    severity: 'High',
    description: 'Αυξάνει το INR. Συνήθως χρειάζεται μείωση δόσης.',
  ),
  Interaction(
    aId: 'acenocoumarol',
    bId: 'amiodarone',
    severity: 'High',
    description: 'Αυξάνει το INR. Συνήθως χρειάζεται μείωση δόσης.',
  ),
  Interaction(
    aId: 'amiodarone',
    bId: 'digoxin',
    severity: 'High',
    description: 'Ανεβάζει τη δακτυλίτιδα → κίνδυνος τοξικότητας. Μείωση δόσης/έλεγχος.',
  ),
  Interaction(
    aId: 'amiodarone',
    bId: 'bisoprolol',
    severity: 'Moderate',
    description: 'Μπορεί να πέσει η καρδιακή συχνότητα. Παρακολούθηση.',
  ),
  Interaction(
    aId: 'amiodarone',
    bId: 'metoprolol',
    severity: 'Moderate',
    description: 'Μπορεί να πέσει η καρδιακή συχνότητα. Παρακολούθηση.',
  ),
  Interaction(
    aId: 'amiodarone',
    bId: 'quetiapine',
    severity: 'Moderate',
    description: 'Κίνδυνος παράτασης QT. Έλεγχος ΗΚΓ/ηλεκτρολυτών.',
  ),
  Interaction(
    aId: 'ramipril',
    bId: 'spironolactone',
    severity: 'High',
    description: 'Κίνδυνος υψηλού καλίου/νεφρικής επιβάρυνσης. Έλεγχος K+ και κρεατινίνης.',
  ),
  Interaction(
    aId: 'perindopril',
    bId: 'spironolactone',
    severity: 'High',
    description: 'Κίνδυνος υψηλού καλίου/νεφρικής επιβάρυνσης. Έλεγχος K+ και κρεατινίνης.',
  ),
  Interaction(
    aId: 'valsartan',
    bId: 'spironolactone',
    severity: 'Moderate',
    description: 'Κίνδυνος υψηλού καλίου. Έλεγχος ηλεκτρολυτών.',
  ),
  Interaction(
    aId: 'losartan',
    bId: 'spironolactone',
    severity: 'Moderate',
    description: 'Κίνδυνος υψηλού καλίου. Έλεγχος ηλεκτρολυτών.',
  ),
  Interaction(
    aId: 'ibuprofen',
    bId: 'aspirin',
    severity: 'Moderate',
    description: 'Τα ΜΣΑΦ μπορεί να μειώσουν λίγο τη δράση της ασπιρίνης. Προτίμησε απόσταση στη λήψη.',
  ),
  Interaction(
    aId: 'ibuprofen',
    bId: 'ramipril',
    severity: 'Moderate',
    description: 'ΜΣΑΦ μπορεί να επηρεάσουν πίεση/νεφρά, ειδικά με διουρητικά.',
  ),
  Interaction(
    aId: 'ibuprofen',
    bId: 'hctz',
    severity: 'Moderate',
    description: 'ΜΣΑΦ μπορεί να μειώσουν λίγο το διουρητικό αποτέλεσμα και να ζορίσουν τα νεφρά.',
  ),
  Interaction(
    aId: 'sertraline',
    bId: 'naproxen',
    severity: 'Moderate',
    description: 'SSRI + ΜΣΑΦ → αυξημένος κίνδυνος γαστρεντερικής αιμορραγίας. Σκέψου PPI.',
  ),
  Interaction(
    aId: 'sertraline',
    bId: 'ibuprofen',
    severity: 'Moderate',
    description: 'SSRI + ΜΣΑΦ → αυξημένος κίνδυνος γαστρεντερικής αιμορραγίας.',
  ),
  Interaction(
    aId: 'escitalopram',
    bId: 'ibuprofen',
    severity: 'Moderate',
    description: 'SSRI + ΜΣΑΦ → αυξημένος κίνδυνος γαστρεντερικής αιμορραγίας.',
  ),
  Interaction(
    aId: 'sertraline',
    bId: 'tramadol',
    severity: 'Moderate',
    description: 'Μαζί μπορεί να φέρουν συμπτώματα σεροτονίνης (τρέμουλο, πυρετό).',
  ),
  Interaction(
    aId: 'escitalopram',
    bId: 'tramadol',
    severity: 'Moderate',
    description: 'Μαζί μπορεί να φέρουν συμπτώματα σεροτονίνης (τρέμουλο, πυρετό).',
  ),
  Interaction(
    aId: 'alprazolam',
    bId: 'tramadol',
    severity: 'Moderate',
    description: 'Πιο έντονη υπνηλία/καταστολή. Προσοχή σε δόση και οδήγηση.',
  ),
  Interaction(
    aId: 'furosemide',
    bId: 'ramipril',
    severity: 'Moderate',
    description: 'Πιθανή πτώση πίεσης στην έναρξη. Παρακολούθηση πίεσης/νεφρών.',
  ),
  Interaction(
    aId: 'furosemide',
    bId: 'valsartan',
    severity: 'Moderate',
    description: 'Πιθανή πτώση πίεσης στην έναρξη. Παρακολούθηση.',
  ),
  Interaction(
    aId: 'metformin',
    bId: 'furosemide',
    severity: 'Low',
    description: 'Μικρή αλληλεπίδραση. Προσοχή σε νεφρική λειτουργία.',
  ),
  Interaction(
    aId: 'glimepiride',
    bId: 'ciprofloxacin',
    severity: 'Moderate',
    description: 'Οι κινολόνες μπορεί να ρίξουν ή να ανεβάσουν ζάχαρο. Έλεγχος γλυκόζης.',
  ),
  Interaction(
    aId: 'insulin_glargine',
    bId: 'ciprofloxacin',
    severity: 'Moderate',
    description: 'Κινολόνες μπορεί να αλλάξουν το ζάχαρο. Έλεγχος και προσαρμογή.',
  ),
  Interaction(
    aId: 'levothyroxine',
    bId: 'omeprazole',
    severity: 'Low',
    description: 'Τα PPI ίσως μειώνουν την απορρόφηση. Πάρε την θυροξίνη νηστικός, με απόσταση.',
  ),
  Interaction(
    aId: 'levothyroxine',
    bId: 'pantoprazole',
    severity: 'Low',
    description: 'Τα PPI ίσως μειώνουν την απορρόφηση. Πάρε την θυροξίνη νηστικός, με απόσταση.',
  ),
  Interaction(
    aId: 'clarithromycin',
    bId: 'apixaban',
    severity: 'Moderate',
    description: 'Αυξάνει τα επίπεδα apixaban → μεγαλύτερος κίνδυνος αιμορραγίας.',
  ),
  Interaction(
    aId: 'clarithromycin',
    bId: 'rivaroxaban',
    severity: 'Moderate',
    description: 'Αυξάνει τα επίπεδα rivaroxaban → κίνδυνος αιμορραγίας.',
  ),
  Interaction(
    aId: 'fluconazole',
    bId: 'apixaban',
    severity: 'Moderate',
    description: 'Αυξάνει τα επίπεδα apixaban → κίνδυνος αιμορραγίας.',
  ),
  Interaction(
    aId: 'ibuprofen',
    bId: 'apixaban',
    severity: 'Moderate',
    description: 'NSAID + αντιπηκτικό → αυξημένος κίνδυνος αιμορραγίας.',
  ),
  Interaction(
    aId: 'ibuprofen',
    bId: 'rivaroxaban',
    severity: 'Moderate',
    description: 'NSAID + αντιπηκτικό → αυξημένος κίνδυνος αιμορραγίας.',
  ),
  Interaction(
    aId: 'naproxen',
    bId: 'apixaban',
    severity: 'Moderate',
    description: 'NSAID + αντιπηκτικό → αυξημένος κίνδυνος αιμορραγίας.',
  ),
  Interaction(
    aId: 'clopidogrel',
    bId: 'apixaban',
    severity: 'Moderate',
    description: 'Διπλή αντιπηκτική/αντιαιμοπεταλιακή δράση → περισσότεροι μώλωπες/αιμορραγία.',
  ),
  Interaction(
    aId: 'sertraline',
    bId: 'apixaban',
    severity: 'Moderate',
    description: 'SSRI μπορεί να αυξήσει λίγο τον κίνδυνο αιμορραγίας με αντιπηκτικά.',
  ),
  Interaction(
    aId: 'prednisolone',
    bId: 'ibuprofen',
    severity: 'Moderate',
    description: 'Κορτιζόνη + ΜΣΑΦ → περισσότερο ρίσκο γαστρεντερικής αιμορραγίας/έλκους. Σκέψου PPI.',
  ),
];

InteractionResult? findInteractionByInput(String drugA, String drugB) {    // Returns InteractionResult or null
  final a = findDrugByName(drugA);
  final b = findDrugByName(drugB);
  if (a == null || b == null) return null;

  for (final i in interactions) {
    if (i.matches(a.id, b.id)) {
      return InteractionResult(interaction: i, drugA: a, drugB: b);
    }
  }
  
  return InteractionResult(drugA: a, drugB: b, interaction: null);
}

class InteractionResult {
  final Drug drugA;
  final Drug drugB;
  final Interaction? interaction;

  InteractionResult({
    required this.drugA,
    required this.drugB,
    required this.interaction,
  });

  bool get hasHit => interaction != null;
}
