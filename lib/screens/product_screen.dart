import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/format.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../models/group_deal.dart';
import '../models/product.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'checkout_screen.dart';
import 'group_screen.dart';
import 'join_sheet.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.product, {super.key});

  final Product product;

  static Future<void> open(BuildContext context, Product product) =>
      pushScreen(context, ProductScreen(product));

  void _buyAlone(BuildContext context) => pushScreen(
        context,
        CheckoutScreen(
          lines: [CheckoutLine(product, 1, product.price)],
          onPay: () => store.buySolo(product),
        ),
      );

  void _startGroup(BuildContext context) =>
      GroupScreen.open(context, store.startGroup(product));

  Future<void> _share(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: 'https://groupbuy.app/p/${product.id}'));
    if (context.mounted) showMessage(context, 'Product link copied.');
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final groups = store.openGroupsFor(product);
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Stack(
              children: [
                Positioned(top: 0, left: 0, right: 0, height: 420, child: ProductImage(product, radius: 0)),
                ListView(
                  padding: const EdgeInsets.only(bottom: 130),
                  children: [
                    const SizedBox(height: 396),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, style: AppText.h2),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 18, color: AppColors.warn),
                              const SizedBox(width: 4),
                              Text(product.rating.toStringAsFixed(1), style: AppText.bodyStrong),
                              Text(' · ${product.soldLabel} sold · Ships in 3–5 days', style: AppText.caption),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              PriceTag(product, large: true),
                              const SizedBox(width: 10),
                              SavePill(product.saving),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              InfoPill('Free shipping', icon: Icons.local_shipping_outlined, background: AppColors.bg, foreground: AppColors.ink),
                              InfoPill('Auto refund', icon: Icons.verified_user_outlined, background: AppColors.bg, foreground: AppColors.ink),
                              InfoPill('24h group', icon: Icons.schedule, background: AppColors.bg, foreground: AppColors.ink),
                            ],
                          ),
                          if (product.description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(product.description, style: AppText.body.copyWith(color: AppColors.ink2)),
                          ],
                          const SizedBox(height: 20),
                          Text('Join an open group', style: AppText.h3),
                          const SizedBox(height: 12),
                          if (groups.isEmpty)
                            Text(
                              'No open groups yet. Start one and invite friends.',
                              style: AppText.body.copyWith(color: AppColors.ink2),
                            ),
                          for (final g in groups) ...[
                            _GroupRow(g, onJoin: () => showJoinSheet(context, g)),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleIconButton(
                            Icons.chevron_left,
                            tooltip: 'Back',
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                          Row(
                            children: [
                              CircleIconButton(
                                Icons.add_shopping_cart,
                                tooltip: 'Add to cart',
                                onTap: () {
                                  store.addToCart(product);
                                  showMessage(context, 'Added to your cart.');
                                },
                              ),
                              const SizedBox(width: 8),
                              CircleIconButton(Icons.ios_share, tooltip: 'Share', onTap: () => _share(context)),
                              const SizedBox(width: 8),
                              CircleIconButton(
                                store.isWished(product) ? Icons.favorite : Icons.favorite_border,
                                iconColor: store.isWished(product) ? AppColors.accent : AppColors.ink,
                                tooltip: 'Wishlist',
                                onTap: () => store.toggleWish(product),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomActionBar(
                    row: true,
                    children: [
                      AppButton(
                        'Buy alone · ${money(product.price)}',
                        style: AppButtonStyle.soft,
                        onPressed: () => _buyAlone(context),
                      ),
                      AppButton('Start group · ${money(product.groupPrice)}', onPressed: () => _startGroup(context)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class _GroupRow extends StatelessWidget {
  const _GroupRow(this.group, {required this.onJoin});

  final GroupDeal group;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) => WhiteCard(
        color: AppColors.bg,
        padding: const EdgeInsets.all(12),
        radius: 16,
        child: Row(
          children: [
            AvatarStack([group.host], size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${group.host}'s group", style: AppText.bodyStrong),
                  Row(
                    children: [
                      Text('${group.missing} more needed · ends in ', style: AppText.caption),
                      Countdown(group.expiresAt, style: AppText.caption),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onJoin,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(12)),
                child: Text('Join', style: AppText.caption.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
}
