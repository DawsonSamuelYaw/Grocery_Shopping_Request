import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../providers/product_provider.dart';
import '../../theme/app_colors.dart';

/// Local mock data has no real product photos yet, so every thumbnail is
/// the product's category glyph on a tinted background. Swap the
/// container's child for an Image.network/asset once real photos exist -
/// every call site already goes through this one widget.
class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({super.key, required this.product, required this.categories, this.size});

  final Product product;
  final List<Category> categories;
  final double? size;

  @override
  Widget build(BuildContext context) {
    Category? category;
    for (final c in categories) {
      if (c.id == product.categoryId) category = c;
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.mistFill, borderRadius: BorderRadius.circular(12)),
      child: Icon(category?.icon ?? Icons.eco, size: size ?? 32, color: AppColors.leafDark),
    );
  }
}
