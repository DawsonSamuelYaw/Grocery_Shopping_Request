import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/product/product_card.dart';
import '../../providers/product_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start each visit from a clean slate rather than the last search.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      provider.setSearchQuery('');
      provider.setCategoryFilter(null);
      provider.setSortOption(SortOption.relevance);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final results = products.searchResults;
    final hasQuery = products.searchQuery.trim().isNotEmpty || products.selectedCategoryId != null;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search groceries',
            border: InputBorder.none,
            isDense: true,
          ),
          onChanged: (value) => context.read<ProductProvider>().setSearchQuery(value),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: products.selectedCategoryId == null,
                  onTap: () => context.read<ProductProvider>().setCategoryFilter(null),
                ),
                const SizedBox(width: 8),
                ...products.categories.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: c.name,
                      selected: products.selectedCategoryId == c.id,
                      onTap: () => context.read<ProductProvider>().setCategoryFilter(c.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Text(
                  hasQuery ? '${results.length} results' : 'Search or pick a category',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                if (hasQuery)
                  DropdownButton<SortOption>(
                    value: products.sortOption,
                    underline: const SizedBox.shrink(),
                    items: SortOption.values
                        .map((o) => DropdownMenuItem(value: o, child: Text(o.label, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => context.read<ProductProvider>().setSortOption(v ?? SortOption.relevance),
                  ),
              ],
            ),
          ),
          Expanded(
            child: !hasQuery
                ? const EmptyState(
                    icon: Icons.search,
                    title: 'Find what you need',
                    message: 'Type a product name or pick a category to browse.',
                  )
                : results.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No matches',
                        message: "We couldn't find anything for that search. Try a different term or category.",
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: results.length,
                        itemBuilder: (context, i) => ProductCard(product: results[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.leaf,
      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.charcoal, fontSize: 13),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: selected ? AppColors.leaf : AppColors.mist),
      ),
    );
  }
}
