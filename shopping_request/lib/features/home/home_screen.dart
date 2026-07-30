import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_network_image.dart';
import '../../providers/grocery_store.dart';
import '../products/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GroceryStore>();
    final filtered = store.products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 24),
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.darkGreen),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deliver to',
                        style: TextStyle(color: AppColors.muted)),
                    Text('Madina, Accra', style: TextStyle(fontSize: 17)),
                  ],
                ),
              ),
              Icon(Icons.notifications_none_rounded),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              hintText: 'Search groceries',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 126,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const AppNetworkImage(
                    url:
                        'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=1200&q=80',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(.35)),
                  const Padding(
                    padding: EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '20% off fresh produce',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This week only, while stock lasts',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 26),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🍍\nFruit', textAlign: TextAlign.center),
              Text('🥦\nVeg', textAlign: TextAlign.center),
              Text('🥛\nDairy', textAlign: TextAlign.center),
              Text('🥐\nBakery', textAlign: TextAlign.center),
              Text('🥩\nMeat', textAlign: TextAlign.center),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Popular near you',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .72,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (_, index) => ProductCard(product: filtered[index]),
          ),
        ],
      ),
    );
  }
}
