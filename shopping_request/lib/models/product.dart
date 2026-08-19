import 'package:flutter/material.dart';

/// A grocery category, e.g. Fruit, Dairy, Bakery.
class Category {
  const Category({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}

/// Shared model - agreed with the rest of the team before coding.
/// id, name, image, price, category, unit, rating (image is a category
/// icon glyph for now since we're on local mock data, no real assets yet).
class Product {
  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    this.discountPercent,
    this.description = '',
    this.availableUnits = const [],
    this.isFavourite = false,
  });

  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String unit;
  final double rating;
  final int reviewCount;
  final int stock;
  final double? discountPercent;
  final String description;
  final List<String> availableUnits;
  bool isFavourite;

  bool get inStock => stock > 0;
  bool get onSale => discountPercent != null && discountPercent! > 0;

  double get discountedPrice => onSale ? price * (1 - discountPercent! / 100) : price;
}
