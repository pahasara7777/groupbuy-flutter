import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../data/categories.dart';
import '../models/product.dart';
import '../state/store.dart';
import '../widgets/widgets.dart';

enum SearchSort { popular, lowestPrice, smallGroups }

/// Search box, sort chips and results. Optionally limited to one [category].
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.category, this.initialQuery = ''});

  final String? category;
  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialQuery);
  SearchSort _sort = SearchSort.popular;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Product> get _results {
    final r = store.search(_controller.text, category: widget.category);
    switch (_sort) {
      case SearchSort.popular:
        r.sort((a, b) => b.sold.compareTo(a.sold));
      case SearchSort.lowestPrice:
        r.sort((a, b) => a.groupPrice.compareTo(b.groupPrice));
      case SearchSort.smallGroups:
        r.sort((a, b) => a.groupSize.compareTo(b.groupSize));
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final query = _controller.text.trim();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _controller,
                    autofocus: widget.category == null && widget.initialQuery.isEmpty,
                    active: true,
                    hint: widget.category == null ? 'Search headphones, serum, gadgets' : 'Search in ${widget.category}',
                    onChanged: (_) => setState(() {}),
                    onClear: () => setState(_controller.clear),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Text('Cancel', style: AppText.bodyStrong.copyWith(color: AppColors.ink2)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                AppChip('Popular', selected: _sort == SearchSort.popular, onTap: () => setState(() => _sort = SearchSort.popular)),
                AppChip('Lowest price', selected: _sort == SearchSort.lowestPrice, onTap: () => setState(() => _sort = SearchSort.lowestPrice)),
                AppChip('Small groups', selected: _sort == SearchSort.smallGroups, onTap: () => setState(() => _sort = SearchSort.smallGroups)),
              ],
            ),
            const SizedBox(height: 16),
            if (query.isEmpty && widget.category == null) ...[
              Text('Browse by category', style: AppText.h3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in categories)
                    AppChip(c.name, onTap: () => setState(() => _controller.text = c.name)),
                ],
              ),
              const SizedBox(height: 20),
            ],
            Text(
              '${results.length} ${results.length == 1 ? 'result' : 'results'}'
              '${widget.category != null ? ' in ${widget.category}' : ''}',
              style: AppText.caption,
            ),
            const SizedBox(height: 12),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('Nothing matches "$query". Try another word.', style: AppText.body.copyWith(color: AppColors.ink2)),
                ),
              )
            else
              ProductGrid(results),
          ],
        ),
      ),
    );
  }
}
