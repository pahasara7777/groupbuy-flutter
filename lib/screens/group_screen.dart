import 'package:flutter/material.dart';
import '../core/navigation.dart';
import '../models/group_deal.dart';
import '../state/store.dart';
import 'group_complete_view.dart';
import 'group_expired_view.dart';
import 'group_waiting_view.dart';

/// Picks the right view for a group's current status and updates as it changes.
class GroupScreen extends StatelessWidget {
  const GroupScreen(this.group, {super.key});

  final GroupDeal group;

  static Future<void> open(BuildContext context, GroupDeal group) =>
      pushScreen(context, GroupScreen(group));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) => switch (group.statusAt()) {
          GroupStatus.open => GroupWaitingView(group),
          GroupStatus.full => GroupCompleteView(group),
          GroupStatus.expired => GroupExpiredView(group),
        },
      );
}
