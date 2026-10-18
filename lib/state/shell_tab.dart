import 'package:flutter/foundation.dart';

/// Which bottom-nav tab the app shell shows (0 Home, 1 Cart, 2 Orders, 3 Me).
final ValueNotifier<int> shellTab = ValueNotifier<int>(0);
