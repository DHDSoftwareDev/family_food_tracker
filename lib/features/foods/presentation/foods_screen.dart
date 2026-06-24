import 'package:flutter/material.dart';

import '../../../common/widgets/responsive_layout.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<_FoodItem> _foods = [
    const _FoodItem('Pizza', 'Fast Food', Icons.local_pizza),
    const _FoodItem('Burger', 'Fast Food', Icons.lunch_dining),
    const _FoodItem('Salad', 'Healthy', Icons.eco),
    const _FoodItem('Pasta', 'Meals', Icons.ramen_dining),
    const _FoodItem('Fruit', 'Healthy', Icons.apple),
    const _FoodItem('Tacos', 'Fast Food', Icons.fastfood),
  ];

  List<_FoodItem> get _filteredFoods {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _foods;

    return _foods
        .where((food) => food.name.toLowerCase().contains(query))
        .toList();
  }

  void _searchFoods(String query) {
    setState(() => _searchQuery = query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddFoodDialog() async {
    final food = await showDialog<_FoodItem>(
      context: context,
      builder: (context) => const _AddFoodDialog(),
    );

    if (food == null || !mounted) return;

    setState(() => _foods.insert(0, food));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${food.name} added')));
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _filteredFoods;

    return ResponsiveLayout(
      mobile: _FoodsMobile(
        foods: filteredFoods,
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchChanged: _searchFoods,
        onClearSearch: _clearSearch,
        onAddFood: _showAddFoodDialog,
      ),
      tablet: _FoodsTablet(
        foods: filteredFoods,
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchChanged: _searchFoods,
        onClearSearch: _clearSearch,
        onAddFood: _showAddFoodDialog,
      ),
      desktop: _FoodsDesktop(
        foods: filteredFoods,
        searchController: _searchController,
        searchQuery: _searchQuery,
        onSearchChanged: _searchFoods,
        onClearSearch: _clearSearch,
        onAddFood: _showAddFoodDialog,
      ),
    );
  }
}

class _FoodsMobile extends StatelessWidget {
  const _FoodsMobile({
    required this.foods,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onAddFood,
  });

  final List<_FoodItem> foods;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onAddFood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foods')),
      floatingActionButton: FloatingActionButton(
        key: const Key('add-food-button'),
        onPressed: onAddFood,
        tooltip: 'Add food',
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SearchBar(
            controller: searchController,
            query: searchQuery,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),
          const SizedBox(height: 16),
          const _CategoryFilters(),
          const SizedBox(height: 20),
          _FoodsList(foods: foods),
          const SizedBox(height: 20),
          _RecentFoodsList(foods: foods),
        ],
      ),
    );
  }
}

class _FoodsTablet extends StatelessWidget {
  const _FoodsTablet({
    required this.foods,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onAddFood,
  });

  final List<_FoodItem> foods;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onAddFood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foods'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              key: const Key('add-food-button'),
              onPressed: onAddFood,
              icon: const Icon(Icons.add),
              label: const Text('Add food'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _SearchBar(
              controller: searchController,
              query: searchQuery,
              onChanged: onSearchChanged,
              onClear: onClearSearch,
            ),
            const SizedBox(height: 16),
            const _CategoryFilters(),
            const SizedBox(height: 24),
            Expanded(child: _FoodsList(foods: foods, scrollable: true)),
          ],
        ),
      ),
    );
  }
}

class _FoodsDesktop extends StatelessWidget {
  const _FoodsDesktop({
    required this.foods,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onAddFood,
  });

  final List<_FoodItem> foods;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onAddFood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Foods',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                FilledButton.icon(
                  key: const Key('add-food-button'),
                  onPressed: onAddFood,
                  icon: const Icon(Icons.add),
                  label: const Text('Add food'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _SearchBar(
                          controller: searchController,
                          query: searchQuery,
                          onChanged: onSearchChanged,
                          onClear: onClearSearch,
                        ),
                        const SizedBox(height: 16),
                        const _CategoryFilters(),
                        const SizedBox(height: 24),
                        Expanded(
                          child: _FoodsList(foods: foods, scrollable: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: _RecentFoodsList(foods: foods, scrollable: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('food-search-field'),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search foods...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: query.isEmpty
            ? null
            : IconButton(
                key: const Key('clear-food-search'),
                onPressed: onClear,
                tooltip: 'Clear search',
                icon: const Icon(Icons.clear),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters();

  @override
  Widget build(BuildContext context) {
    const categories = ['All', 'Healthy', 'Fast Food', 'Snacks', 'Drinks'];

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

class _FoodsList extends StatelessWidget {
  const _FoodsList({required this.foods, this.scrollable = false});

  final List<_FoodItem> foods;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return const Center(
        key: Key('foods-list'),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48),
              SizedBox(height: 12),
              Text('No foods found'),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      key: const Key('foods-list'),
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final food = foods[i];
        return Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CircleAvatar(child: Icon(food.icon)),
            title: Text(food.name),
            subtitle: Text(food.category),
          ),
        );
      },
    );
  }
}

class _RecentFoodsList extends StatelessWidget {
  const _RecentFoodsList({required this.foods, this.scrollable = false});

  final List<_FoodItem> foods;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final recent = foods.take(3).toList();

    return Card(
      elevation: 3,
      child: ListView.separated(
        shrinkWrap: !scrollable,
        physics: scrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: recent.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (_, i) {
          final food = recent[i];
          return ListTile(
            leading: Icon(food.icon),
            title: Text(food.name),
            subtitle: Text(i == 0 ? 'Added today' : food.category),
          );
        },
      ),
    );
  }
}

class _AddFoodDialog extends StatefulWidget {
  const _AddFoodDialog();

  @override
  State<_AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<_AddFoodDialog> {
  static const _categories = [
    'Healthy',
    'Fast Food',
    'Snacks',
    'Drinks',
    'Meals',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _category = _categories.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      _FoodItem(
        _nameController.text.trim(),
        _category,
        _iconForCategory(_category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add food'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('food-name-field'),
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Food name',
                  hintText: 'e.g. Grilled chicken',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a food name';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('save-food-button'),
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

IconData _iconForCategory(String category) {
  return switch (category) {
    'Healthy' => Icons.eco,
    'Fast Food' => Icons.fastfood,
    'Snacks' => Icons.cookie,
    'Drinks' => Icons.local_drink,
    'Meals' => Icons.dinner_dining,
    _ => Icons.restaurant,
  };
}

class _FoodItem {
  const _FoodItem(this.name, this.category, this.icon);

  final String name;
  final String category;
  final IconData icon;
}
