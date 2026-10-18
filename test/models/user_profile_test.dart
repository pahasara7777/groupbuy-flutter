import 'package:flutter_test/flutter_test.dart';
import 'package:groupbuy/models/user_profile.dart';

UserProfile _u(String n) => UserProfile(name: n, email: 'a@b.c', address: 'x');

void main() {
  test('initials use first and last name', () {
    expect(_u('Pahasara Lekamge').initials, 'PL');
    expect(_u('  ada   king lovelace ').initials, 'AL');
  });

  test('single name and empty name', () {
    expect(_u('Madonna').initials, 'M');
    expect(_u('   ').initials, '?');
  });
}
