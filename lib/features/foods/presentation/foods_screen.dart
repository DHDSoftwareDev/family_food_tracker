import 'package:flutter/material.dart';
import '../../../common/widgets/responsive_layout.dart';

class FoodsScreen extends StatelessWidget {
  const FoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _FoodsMobile(),
      tablet: _FoodsTablet(),
      desktop: _FoodsDesktop(),
    );
  }
}

//
// ----------------------
// MOBILE LAYOUT
// ----------------------
//
class _FoodsMobile extends StatelessWidget {
  const _FoodsMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foods")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SearchBar(),
          SizedBox(height: 16),
          _CategoryFilters(),
          SizedBox(height: 20),
          _FoodsGrid(),
          SizedBox(height: 20),
          _RecentFoodsList(),
        ],
      ),
    );
  }
}

//
// ----------------------
// TABLET LAYOUT
// ----------------------
//
class _FoodsTablet extends StatelessWidget {
  const _FoodsTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foods")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            _SearchBar(),
            SizedBox(height: 16),
            _CategoryFilters(),
            SizedBox(height: 24),
            Expanded(child: _FoodsGrid()),
          ],
        ),
      ),
    );
  }
}

//
// ----------------------
// DESKTOP LAYOUT
// ----------------------
//
class _FoodsDesktop extends StatelessWidget {
  const _FoodsDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: const [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  _SearchBar(),
                  SizedBox(height: 16),
                  _CategoryFilters(),
                  SizedBox(height: 24),
                  Expanded(child: _FoodsGrid()),
                ],
              ),
            ),
            SizedBox(width: 32),
            Expanded(
              flex: 2,
              child: _RecentFoodsList(),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ----------------------
// COMPONENTS
// ----------------------
//

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search foods...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters();

  @override
  Widget build(BuildContext context) {
    final categories = ["All", "Healthy", "Fast Food", "Snacks", "Drinks"];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          return Chip(
            label: Text(categories[i]),
            backgroundColor: Colors.grey.shade200,
          );
        },
      ),
    );
  }
}

class _FoodsGrid extends StatelessWidget {
  const _FoodsGrid();

  @override
  Widget build(BuildContext context) {
    final foods = [
      ("Pizza", Icons.local_pizza),
      ("Burger", Icons.lunch_dining),
      ("Salad", Icons.eco),
      ("Pasta", Icons.ramen_dining),
      ("Fruit", Icons.apple),
      ("Tacos", Icons.fastfood),
    ];

    final crossAxisCount = ResponsiveLayout.isDesktop(context)
        ? 4
        : ResponsiveLayout.isTablet(context)
            ? 3
            : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, i) {
        return Card(
          elevation: 2,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(foods[i].$2, size: 40),
                const SizedBox(height: 8),
                Text(foods[i].$1),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecentFoodsList extends StatelessWidget {
  const _RecentFoodsList();

  @override
  Widget build(BuildContext context) {
    final recent = [
      ("Pizza", "Added today", Icons.local_pizza),
      ("Salad", "Added yesterday", Icons.eco),
      ("Burger", "Added 2 days ago", Icons.lunch_dining),
    ];

    return Card(
      elevation: 3,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: recent.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (_, i) {
          return ListTile(
            leading: Icon(recent[i].$3),
            title: Text(recent[i].$1),
            subtitle: Text(recent[i].$2),
          );
        },
      ),
    );
  }
}
