import 'package:flutter/material.dart';
import 'package:kisanlink/ShopByProduct/productlist.dart';

enum PageType { animal_food, seed, fertilizer, pesticide, other }

class ProductShop extends StatefulWidget {
  const ProductShop({super.key});

  @override
  State<ProductShop> createState() => _ProductShopState();
}

class _ProductShopState extends State<ProductShop> {
  PageType _selectedPage = PageType.animal_food;

  void _navigateToPage(PageType pageType) {
    setState(() {
      _selectedPage = pageType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: Colors.green,
        //centerTitle: true,
        actions: [
          DropdownButton(
            value: _selectedPage,
            onChanged: (value) {
              _navigateToPage(value as PageType);
            },
            items: const [
              DropdownMenuItem(
                value: PageType.animal_food,
                child: Text('Animal Food'),
              ),
              DropdownMenuItem(
                value: PageType.seed,
                child: Text('Seeds'),
              ),
              DropdownMenuItem(
                value: PageType.fertilizer,
                child: Text('Fertilizers'),
              ),
              DropdownMenuItem(
                value: PageType.pesticide,
                child: Text('Pesticides'),
              ),
              DropdownMenuItem(
                value: PageType.other,
                child: Text('Others'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedPage) {
      case PageType.animal_food:
        return const CategoryProductPage(category: 'Animal Food');
      case PageType.seed:
        return const CategoryProductPage(category: 'Seed');
      case PageType.fertilizer:
        return const CategoryProductPage(category: 'Fertilizer');
      case PageType.pesticide:
        return const CategoryProductPage(category: 'Pesticide');
      case PageType.other:
        return const CategoryProductPage(category: 'Other');
    }
  }
}
