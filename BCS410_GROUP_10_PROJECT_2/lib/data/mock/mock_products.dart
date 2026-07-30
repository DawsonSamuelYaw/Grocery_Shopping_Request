import '../models/product.dart';

const mockProducts = <Product>[
  Product(
    id: 'banana',
    name: 'Ripe bananas',
    price: 8.50,
    unit: '1 kg bunch',
    category: 'Fruit',
    discount: 15,
    imageUrl:
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=800&q=80',
    description:
        'Sweet, naturally ripened bananas selected for snacking, smoothies and breakfast.',
  ),
  Product(
    id: 'spinach',
    name: 'Organic baby spinach',
    price: 12.00,
    unit: '200g pack',
    category: 'Veg',
    imageUrl:
        'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=800&q=80',
    description:
        'Hand-picked leaves from local growers, washed and ready to eat. Rich in iron and vitamin C, best kept chilled.',
  ),
  Product(
    id: 'bread',
    name: 'Whole wheat bread',
    price: 15.00,
    unit: '1 loaf',
    category: 'Bakery',
    imageUrl:
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=800&q=80',
    description:
        'Soft whole wheat bread baked fresh with a light crust and wholesome grains.',
  ),
  Product(
    id: 'milk',
    name: 'Fresh dairy milk',
    price: 18.00,
    unit: '1 litre',
    category: 'Dairy',
    imageUrl:
        'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=800&q=80',
    description:
        'Fresh, creamy full-fat milk suitable for breakfast, baking and everyday use.',
  ),
  Product(
    id: 'meat',
    name: 'Lean beef cuts',
    price: 42.00,
    unit: '500g pack',
    category: 'Meat',
    imageUrl:
        'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?auto=format&fit=crop&w=800&q=80',
    description:
        'Carefully selected lean beef cuts, trimmed and packed for convenient cooking.',
  ),
  Product(
    id: 'tomato',
    name: 'Fresh tomatoes',
    price: 10.00,
    unit: '1 kg',
    category: 'Veg',
    imageUrl:
        'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?auto=format&fit=crop&w=800&q=80',
    description:
        'Firm, juicy tomatoes sourced from local farms and selected for freshness.',
  ),
];
