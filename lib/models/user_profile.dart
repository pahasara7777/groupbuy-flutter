class UserProfile {
  const UserProfile({required this.name, required this.email, required this.address});

  final String name, email, address;

  /// "PL" for "Pahasara Lekamge".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
