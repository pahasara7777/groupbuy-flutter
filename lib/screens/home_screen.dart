import 'package:flutter/material.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../data/categories.dart';
import '../core/theme/app_spacing.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'deals_screen.dart';
import 'notifications_screen.dart';
import 'product_screen.dart';
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
        backgroundColor: AppColors.surface,
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField(readOnly: true, onTap: () => pushScreen(context, const SearchScreen())),
                      ),
                      const SizedBox(width: 4),
                      Badge(
                        label: Text('${store.unreadCount}'),
                        isLabelVisible: store.unreadCount > 0,
                        child: IconButton(
                          tooltip: 'Notifications',
                          icon: const Icon(Icons.notifications_none, color: AppColors.ink),
                          onPressed: () => pushScreen(context, const NotificationsScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(_greeting, style: AppText.caption),
                ),
                SizedBox(
                  height: 104,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    children: [
                      for (final c in categories)
                        _CategoryTile(
                          c,
                          selected: _category == c.name,
                          onTap: () => setState(() => _category = _category == c.name ? null : c.name),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Hero(onStart: () => pushScreen(context, const DealsScreen())),
                ),
                const SizedBox(height: 24),
                if (_category == null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SectionHeader('Groups ending soon', action: 'See all', onAction: () => pushScreen(context, const DealsScreen())),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 8,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final p = store.trending[i + 8];
                        return SizedBox(
                          width: 150,
                          child: ProductCard(
                            p,
                            wished: store.isWished(p),
                            onWish: () => store.toggleWish(p),
                            onTap: () => ProductScreen.open(context, p),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(
                    _category ?? 'Trending now',
                    action: 'See all',
                    onAction: () => pushScreen(context, const DealsScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProductGrid(_category == null ? store.trending : store.productsIn(_category!)),
                ),
              ],
            ),
          ),
        ),
      );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile(this.category, {required this.selected, required this.onTap});

  final ProductCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 72,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? AppColors.accent : Colors.transparent, width: 2),
                ),
                child: ClipOval(child: Image.asset(category.image, fit: BoxFit.cover)),
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.caption.copyWith(
                  color: AppColors.ink,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          color: AppColors.accent,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Team up, pay less', style: AppText.h1.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Up to 40% off when friends join', style: AppText.body.copyWith(color: Colors.white)),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: onStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                          child: Text('Shop group deals', style: AppText.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 130,
                height: 160,
                child: ProductImage(store.productById('p8'), radius: 0),
              ),
            ],
          ),
        ),
      );
}
