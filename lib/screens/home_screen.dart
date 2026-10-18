import 'package:flutter/material.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../data/categories.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'categories_screen.dart';
import 'deals_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _category; // null = All

  String get _greeting {
    final h = DateTime.now().hour;
    final part = h < 12 ? 'Good morning' : (h < 18 ? 'Good afternoon' : 'Good evening');
    final name = store.user?.name.split(' ').first;
    return name == null ? part : '$part, $name';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting, style: AppText.caption),
                        Text('Team up, pay less', style: AppText.h1),
                      ],
                    ),
                    Badge(
                      label: Text('${store.unreadCount}'),
                      isLabelVisible: store.unreadCount > 0,
                      child: CircleIconButton(
                        Icons.notifications_none,
                        size: 44,
                        border: true,
                        tooltip: 'Notifications',
                        onTap: () => pushScreen(context, const NotificationsScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SearchField(readOnly: true, onTap: () => pushScreen(context, const SearchScreen())),
                const SizedBox(height: 16),
                _Hero(onStart: () => pushScreen(context, const DealsScreen())),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppChip('All', selected: _category == null, onTap: () => setState(() => _category = null)),
                      for (final c in categories.take(5)) ...[
                        const SizedBox(width: 8),
                        AppChip(c.name, selected: _category == c.name, onTap: () => setState(() => _category = c.name)),
                      ],
                      const SizedBox(width: 8),
                      AppChip('More', onTap: () => pushScreen(context, const CategoriesScreen())),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  _category == null ? 'Trending groups' : _category!,
                  action: 'See all',
                  onAction: () => pushScreen(context, const DealsScreen()),
                ),
                const SizedBox(height: 12),
                ProductGrid(_category == null ? store.trending : store.productsIn(_category!)),
              ],
            ),
          ),
        ),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: AppColors.ink,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(999)),
                        child: Text('FLASH GROUP DEAL', style: AppText.micro.copyWith(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      Text('Up to 40% off when friends join', style: AppText.h2.copyWith(color: Colors.white)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: onStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                          child: Text('Start a group', style: AppText.caption.copyWith(color: AppColors.ink)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 140,
                height: 170,
                child: ProductImage(store.productById('p8'), radius: 0),
              ),
            ],
          ),
        ),
      );
}
