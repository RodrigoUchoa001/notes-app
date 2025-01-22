import 'package:flutter_riverpod/flutter_riverpod.dart';

// controls if the note is being edit or not, used for enable or note fieldtexts
// and control the save icon
final editModeProvider = StateProvider<bool>((ref) => true);
