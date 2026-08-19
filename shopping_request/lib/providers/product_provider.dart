// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

enum SortOption { relevance, priceLowHigh, priceHighLow, ratingHighLow }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.priceLowHigh:
        return 'Price: low to high';
      case SortOption.priceHighLow:
        return 'Price: high to low';
      case SortOption.ratingHighLow:
        return 'Top rated';
    }
  }
}

/// Owns the product catalogue: categories, mock product data, search,
/// category filtering, sorting, and favourite toggling. Members 3/4:
/// read [favouriteProducts] for the favourites screen, and use
/// [productById] when building order line items from a cart entry.
class ProductProvider extends ChangeNotifier {
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategoryId;
  SortOption _sortOption = SortOption.relevance;

  final List<Category> categories = const [
    Category(id: 'fruit', name: 'Fruit', icon: Icons.local_florist),
    Category(id: 'veg', name: 'Veg', icon: Icons.eco),
    Category(id: 'dairy', name: 'Dairy', icon: Icons.icecream),
    Category(id: 'bakery', name: 'Bakery', icon: Icons.bakery_dining),
    Category(id: 'meat', name: 'Meat & Fish', icon: Icons.set_meal),
    Category(id: 'snacks', name: 'Snacks', icon: Icons.cookie),
    Category(id: 'drinks', name: 'Drinks', icon: Icons.local_drink),
  ];

  late final List<Product> _allProducts = [
    Product(
      id: 'p1',
      name: 'Ripe bananas',
      categoryId: 'fruit',
      price: 8.50,
      unit: '1 kg bunch',
      rating: 4.8,
      reviewCount: 214,
      stock: 40,
      discountPercent: 15,
      description: 'Sweet, ready-to-eat bananas sourced from local farms this week.',
      availableUnits: ['1 kg', '2 kg'],
    ),
    Product(
      id: 'p2',
      name: 'Pineapple',
      categoryId: 'fruit',
      price: 12.00,
      unit: '1 whole',
      rating: 4.6,
      reviewCount: 98,
      stock: 18,
      description: 'Juicy, golden pineapple - hand-picked at peak ripeness.',
      availableUnits: ['1 whole'],
    ),
    Product(
      id: 'p3',
      name: 'Watermelon',
      categoryId: 'fruit',
      price: 18.00,
      unit: '1 whole',
      rating: 4.7,
      reviewCount: 76,
      stock: 0,
      description: 'Large, seedless watermelon - a hot-day favourite.',
      availableUnits: ['1 whole', 'Half'],
    ),
    Product(
      id: 'p4',
      name: 'Navel oranges',
      categoryId: 'fruit',
      price: 10.00,
      unit: '1 kg bag',
      rating: 4.5,
      reviewCount: 61,
      stock: 32,
      availableUnits: ['1 kg', '2 kg'],
    ),
    Product(
      id: 'p5',
      name: 'Organic baby spinach',
      categoryId: 'veg',
      price: 12.00,
      unit: '200g pack',
      rating: 4.8,
      reviewCount: 212,
      stock: 25,
      description: 'Hand-picked leaves from local growers, washed and ready to eat. '
          'Rich in iron and vitamin C, best kept chilled.',
      availableUnits: ['200g', '500g', '1kg'],
    ),
    Product(
      id: 'p6',
      name: 'Vine tomatoes',
      categoryId: 'veg',
      price: 9.00,
      unit: '1 kg',
      rating: 4.4,
      reviewCount: 143,
      stock: 50,
      discountPercent: 10,
      availableUnits: ['500g', '1 kg'],
    ),
    Product(
      id: 'p7',
      name: 'Carrots',
      categoryId: 'veg',
      price: 6.50,
      unit: '1 kg bag',
      rating: 4.3,
      reviewCount: 54,
      stock: 60,
      availableUnits: ['1 kg'],
    ),
    Product(
      id: 'p8',
      name: 'Garden eggs',
      categoryId: 'veg',
      price: 7.00,
      unit: '1 kg',
      rating: 4.2,
      reviewCount: 29,
      stock: 20,
      availableUnits: ['500g', '1 kg'],
    ),
    Product(
      id: 'p9',
      name: 'Fresh whole milk',
      categoryId: 'dairy',
      price: 14.50,
      unit: '1 litre',
      rating: 4.6,
      reviewCount: 187,
      stock: 45,
      availableUnits: ['500ml', '1 litre'],
    ),
    Product(
      id: 'p10',
      name: 'Cheddar cheese block',
      categoryId: 'dairy',
      price: 28.00,
      unit: '250g',
      rating: 4.7,
      reviewCount: 88,
      stock: 15,
      discountPercent: 20,
      availableUnits: ['250g', '500g'],
    ),
    Product(
      id: 'p11',
      name: 'Natural yoghurt',
      categoryId: 'dairy',
      price: 11.00,
      unit: '500g tub',
      rating: 4.5,
      reviewCount: 66,
      stock: 30,
      availableUnits: ['500g'],
    ),
    Product(
      id: 'p12',
      name: 'Whole wheat bread',
      categoryId: 'bakery',
      price: 15.00,
      unit: '1 loaf',
      rating: 4.4,
      reviewCount: 121,
      stock: 22,
      availableUnits: ['1 loaf'],
    ),
    Product(
      id: 'p13',
      name: 'Butter croissants',
      categoryId: 'bakery',
      price: 18.00,
      unit: 'Pack of 4',
      rating: 4.8,
      reviewCount: 74,
      stock: 12,
      availableUnits: ['Pack of 4', 'Pack of 8'],
    ),
    Product(
      id: 'p14',
      name: 'Chicken breast',
      categoryId: 'meat',
      price: 32.00,
      unit: '1 kg',
      rating: 4.6,
      reviewCount: 156,
      stock: 28,
      availableUnits: ['500g', '1 kg'],
    ),
    Product(
      id: 'p15',
      name: 'Fresh tilapia fillet',
      categoryId: 'meat',
      price: 26.00,
      unit: '500g',
      rating: 4.5,
      reviewCount: 47,
      stock: 0,
      availableUnits: ['500g', '1 kg'],
    ),
    Product(
      id: 'p16',
      name: 'Plantain chips',
      categoryId: 'snacks',
      price: 9.50,
      unit: '150g bag',
      rating: 4.7,
      reviewCount: 203,
      stock: 70,
      discountPercent: 10,
      availableUnits: ['150g', '300g'],
    ),
    Product(
      id: 'p17',
      name: 'Roasted groundnuts',
      categoryId: 'snacks',
      price: 6.00,
      unit: '200g bag',
      rating: 4.3,
      reviewCount: 58,
      stock: 55,
      availableUnits: ['200g'],
    ),
    Product(
      id: 'p18',
      name: 'Bottled water',
      categoryId: 'drinks',
      price: 4.00,
      unit: 'Pack of 6',
      rating: 4.6,
      reviewCount: 302,
      stock: 90,
      availableUnits: ['Pack of 6', 'Pack of 12'],
    ),
    Product(
      id: 'p19',
      name: 'Fresh orange juice',
      categoryId: 'drinks',
      price: 13.00,
      unit: '1 litre',
      rating: 4.5,
      reviewCount: 91,
      stock: 24,
      availableUnits: ['500ml', '1 litre'],
    ),
  ];

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  SortOption get sortOption => _sortOption;

  List<Product> get allProducts => List.unmodifiable(_allProducts);

  List<Product> get favouriteProducts =>
      _allProducts.where((p) => p.isFavourite).toList(growable: false);

  /// Simulates an initial network fetch for the catalogue.
  Future<void> bootstrap() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }

  Category? categoryById(String id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Product? productById(String id) {
    for (final p in _allProducts) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<Product> productsByCategory(String categoryId) =>
      _allProducts.where((p) => p.categoryId == categoryId).toList(growable: false);

  /// Highest-rated in-stock products, for the home dashboard's
  /// "Popular near you" section.
  List<Product> get popularProducts {
    final list = _allProducts.where((p) => p.inStock).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(8).toList(growable: false);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void toggleFavourite(String productId) {
    final product = productById(productId);
    if (product == null) return;
    product.isFavourite = !product.isFavourite;
    notifyListeners();
  }

  /// Full search + filter + sort pipeline, used by the search screen.
  List<Product> get searchResults {
    Iterable<Product> results = _allProducts;

    if (_selectedCategoryId != null) {
      results = results.where((p) => p.categoryId == _selectedCategoryId);
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      results = results.where((p) => p.name.toLowerCase().contains(q));
    }

    final list = results.toList();
    switch (_sortOption) {
      case SortOption.relevance:
        break;
      case SortOption.priceLowHigh:
        list.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case SortOption.priceHighLow:
        list.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case SortOption.ratingHighLow:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }
}