import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/navigation.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';
import 'product_screen.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  static DateTime get _endOfDay {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, 23, 59, 59);
  }

  Future<void> _invite(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: 'https://groupbuy.app/invite/pahasara'));
    if (context.mounted) showMessage(context, 'Invite link copied. You get \$5 when a friend joins.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final featured = store.featuredGroup;
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const TopBar('Deals'),
                  const SizedBox(height: 16),
                  Align(alignment: Alignment.centerLeft, child: TimerPill(_endOfDay, prefix: 'Flash deals end in ')),
                  const SizedBox(height: 16),
                  if (featured != null) ...[
                    GestureDetector(
                      onTap: () => ProductScreen.open(context, featured.product),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: ColoredBox(
                          color: AppColors.surface,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: ProductImage(featured.product, radius: 0),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(featured.product.title, style: AppText.h3)),
                                        PriceTag(featured.product),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: LinearProgressIndicator(
                                        value: featured.progress,
                                        minHeight: 8,
                                        color: AppColors.accent,
                                        backgroundColor: AppColors.line,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '${featured.members.length} of ${featured.product.groupSize} joined · ends in ',
                                          style: AppText.caption,
                                        ),
                                        Countdown(featured.expiresAt, style: AppText.caption),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  WhiteCard(
                    color: AppColors.ink,
                    padding: const EdgeInsets.all(16),
                    onTap: () => _invite(context),
                    child: Row(
                      children: [
                        const CircleIconButton(
                          Icons.card_giftcard,
                          size: 48,
                          background: AppColors.accent,
                          iconColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Invite a friend, get \$5', style: AppText.bodyStrong.copyWith(color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(
                                'Credit lands when they join a group.',
                                style: AppText.caption.copyWith(color: const Color(0xFFBFBFC7)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  WhiteCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily check-in · 4 day streak', style: AppText.bodyStrong),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var d = 1; d <= 7; d++)
                              Container(
                                width: 38,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: d <= 4 ? AppColors.success : AppColors.bg,
                                ),
                                child: d <= 4
                                    ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                                    : Text('$d', style: AppText.caption),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader('More deals'),
                  const SizedBox(height: 12),
                  ProductGrid(store.trending.take(4).toList()),
                ],
              );
            },
          ),
        ),
      );
}
