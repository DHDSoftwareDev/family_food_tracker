import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/responsive_layout.dart';

class FoodsScreen extends StatefulWidget {
  const FoodsScreen({super.key});

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  static const _storageKey = 'foods';
  static const _defaultFoods = [
    _FoodItem('Pizza', 'Fast Food', Icons.local_pizza),
    _FoodItem('Burger', 'Meats', Icons.lunch_dining),
    _FoodItem('Salad', 'Healthy', Icons.eco),
    _FoodItem('Pasta', 'Meals', Icons.ramen_dining),
    _FoodItem('Apple', 'Fruit', Icons.apple),
    _FoodItem('Carrots', 'Vegetable', Icons.eco),
    _FoodItem('Tacos', 'Fast Food', Icons.fastfood),
  ];

  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<_FoodItem> _foods = [..._defaultFoods];

  List<_FoodItem> get _filteredFoods {
    final query = _searchQuery.trim().toLowerCase();
    return _foods
        .where(
          (food) =>
              (_selectedCategory == 'All' ||
                  food.category == _selectedCategory) &&
              (query.isEmpty || food.name.toLowerCase().contains(query)),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadFoods());
  }

  Future<void> _loadFoods() async {
    final preferences = await SharedPreferences.getInstance();
    final storedFoods = preferences.getString(_storageKey);
    if (storedFoods == null || !mounted) return;

    try {
      final decoded = jsonDecode(storedFoods) as List<dynamic>;
      final foods = decoded
          .map((food) => _FoodItem.fromJson(food as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        _foods
          ..clear()
          ..addAll(foods);
      });
    } on FormatException {
      await preferences.remove(_storageKey);
    }
  }

  Future<void> _saveFoods() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(_foods.map((food) => food.toJson()).toList()),
    );
  }

  void _searchFoods(String query) {
    setState(() => _searchQuery = query);
  }

  void _selectCategory(String category) {
    setState(() => _selectedCategory = category);
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
      builder: (context) => const _FoodDialog(),
    );

    if (food == null || !mounted) return;

    setState(() => _foods.insert(0, food));
    await _saveFoods();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${food.name} added')));
  }

  Future<void> _editFood(_FoodItem food) async {
    final updatedFood = await showDialog<_FoodItem>(
      context: context,
      builder: (context) => _FoodDialog(food: food),
    );

    if (updatedFood == null || !mounted) return;

    final index = _foods.indexOf(food);
    if (index == -1) return;

    setState(() => _foods[index] = updatedFood);
    await _saveFoods();
  }

  void _deleteFood(_FoodItem food) {
    setState(() => _foods.remove(food));
    unawaited(_saveFoods());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${food.name} deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _filteredFoods;

    return ResponsiveLayout(
      mobile: _FoodsMobile(
        foods: filteredFoods,
        searchController: _searchController,
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        onSearchChanged: _searchFoods,
        onCategorySelected: _selectCategory,
        onClearSearch: _clearSearch,
        onAddFood: _showAddFoodDialog,
        onEditFood: _editFood,
        onDeleteFood: _deleteFood,
      ),
      tablet: _FoodsTablet(
        foods: filteredFoods,
        searchController: _searchController,
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        onSearchChanged: _searchFoods,
        onCategorySelected: _selectCategory,
        onClearSearch: _clearSearch,
        onAddFood: _showAddFoodDialog,
        onEditFood: _editFood,
        onDeleteFood: _deleteFood,
      ),
      desktop: _FoodsDesktop(
        foods: filteredFoods,
        searchController: _searchController,
        searchQuery: _searchQuery,
        selectedCategory: _selectedCategory,
        onSearchChanged: _searchFoods,
        onCategorySelected: _selectCategory,
        onClearSearch: _clearSearch,
        onAddFood: _showAddFoodDialog,
        onEditFood: _editFood,
        onDeleteFood: _deleteFood,
      ),
    );
  }
}

class _FoodsMobile extends StatelessWidget {
  const _FoodsMobile({
    required this.foods,
    required this.searchController,
    required this.searchQuery,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onClearSearch,
    required this.onAddFood,
    required this.onEditFood,
    required this.onDeleteFood,
  });

  final List<_FoodItem> foods;
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onClearSearch;
  final VoidCallback onAddFood;
  final ValueChanged<_FoodItem> onEditFood;
  final ValueChanged<_FoodItem> onDeleteFood;

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
          _CategoryFilters(
            selectedCategory: selectedCategory,
            onSelected: onCategorySelected,
          ),
          const SizedBox(height: 20),
          _FoodsList(
            foods: foods,
            onEditFood: onEditFood,
            onDeleteFood: onDeleteFood,
          ),
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
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onClearSearch,
    required this.onAddFood,
    required this.onEditFood,
    required this.onDeleteFood,
  });

  final List<_FoodItem> foods;
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onClearSearch;
  final VoidCallback onAddFood;
  final ValueChanged<_FoodItem> onEditFood;
  final ValueChanged<_FoodItem> onDeleteFood;

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
            _CategoryFilters(
              selectedCategory: selectedCategory,
              onSelected: onCategorySelected,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _FoodsList(
                foods: foods,
                scrollable: true,
                onEditFood: onEditFood,
                onDeleteFood: onDeleteFood,
              ),
            ),
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
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onClearSearch,
    required this.onAddFood,
    required this.onEditFood,
    required this.onDeleteFood,
  });

  final List<_FoodItem> foods;
  final TextEditingController searchController;
  final String searchQuery;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onClearSearch;
  final VoidCallback onAddFood;
  final ValueChanged<_FoodItem> onEditFood;
  final ValueChanged<_FoodItem> onDeleteFood;

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
              child: Column(
                children: [
                  _SearchBar(
                    controller: searchController,
                    query: searchQuery,
                    onChanged: onSearchChanged,
                    onClear: onClearSearch,
                  ),
                  const SizedBox(height: 16),
                  _CategoryFilters(
                    selectedCategory: selectedCategory,
                    onSelected: onCategorySelected,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _FoodsList(
                      foods: foods,
                      scrollable: true,
                      onEditFood: onEditFood,
                      onDeleteFood: onDeleteFood,
                    ),
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
  const _CategoryFilters({
    required this.selectedCategory,
    required this.onSelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = [
      'All',
      'Healthy',
      'Fast Food',
      'Snacks',
      'Drinks',
      'Meats',
      'Fruit',
      'Vegetable',
      'Meals',
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        key: const Key('food-category-list'),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final category = categories[i];
          return ChoiceChip(
            key: Key('food-category-$category'),
            label: Text(categories[i]),
            selected: category == selectedCategory,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}

class _FoodsList extends StatelessWidget {
  const _FoodsList({
    required this.foods,
    required this.onEditFood,
    required this.onDeleteFood,
    this.scrollable = false,
  });

  final List<_FoodItem> foods;
  final ValueChanged<_FoodItem> onEditFood;
  final ValueChanged<_FoodItem> onDeleteFood;
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
        return _SwipeableFoodCard(
          key: ValueKey('${food.name}-${food.category}'),
          food: food,
          onEdit: () => onEditFood(food),
          onDelete: () => onDeleteFood(food),
        );
      },
    );
  }
}

class _SwipeableFoodCard extends StatefulWidget {
  const _SwipeableFoodCard({
    super.key,
    required this.food,
    required this.onEdit,
    required this.onDelete,
  });

  final _FoodItem food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_SwipeableFoodCard> createState() => _SwipeableFoodCardState();
}

class _SwipeableFoodCardState extends State<_SwipeableFoodCard> {
  static const _actionsWidth = 144.0;
  double _offset = 0;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = (_offset + details.delta.dx)
          .clamp(-_actionsWidth, 0)
          .toDouble();
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _offset = _offset.abs() > _actionsWidth / 3 ? -_actionsWidth : 0;
    });
  }

  void _closeActions() {
    setState(() => _offset = 0);
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final borderRadius = BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          if (_offset < 0)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: _actionsWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: _SwipeAction(
                          key: Key('edit-${food.name}'),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          icon: Icons.edit,
                          label: 'Edit',
                          onPressed: () {
                            _closeActions();
                            widget.onEdit();
                          },
                        ),
                      ),
                      Expanded(
                        child: _SwipeAction(
                          key: Key('delete-${food.name}'),
                          color: Theme.of(context).colorScheme.errorContainer,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: widget.onDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          GestureDetector(
            key: Key('food-card-${food.name}'),
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            onTap: _offset < 0 ? _closeActions : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(_offset, 0, 0),
              child: Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                child: ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Icon(food.icon),
                  title: Text(food.name),
                  trailing: Text(
                    food.category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeAction extends StatelessWidget {
  const _SwipeAction({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 2),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _FoodDialog extends StatefulWidget {
  const _FoodDialog({this.food});

  final _FoodItem? food;

  @override
  State<_FoodDialog> createState() => _FoodDialogState();
}

class _FoodDialogState extends State<_FoodDialog> {
  static const _categories = [
    'Healthy',
    'Fast Food',
    'Snacks',
    'Drinks',
    'Meats',
    'Fruit',
    'Vegetable',
    'Meals',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _category;

  bool get _isEditing => widget.food != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food?.name);
    _category = widget.food?.category ?? _categories.first;
  }

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
      title: Text(_isEditing ? 'Edit food' : 'Add food'),
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
          child: Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

IconData _iconForCategory(String category) {
  return switch (category) {
    'Healthy' => Icons.health_and_safety,
    'Fast Food' => Icons.fastfood,
    'Snacks' => Icons.cookie,
    'Drinks' => Icons.local_drink,
    'Meats' => Icons.set_meal,
    'Fruit' => Icons.apple,
    'Vegetable' => Icons.eco,
    'Meals' => Icons.dinner_dining,
    _ => Icons.restaurant,
  };
}

class _FoodItem {
  const _FoodItem(this.name, this.category, this.icon);

  factory _FoodItem.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final category = _normalizeCategory(json['category'] as String?);
    return _FoodItem(name, category, _iconForCategory(category));
  }

  final String name;
  final String category;
  final IconData icon;

  Map<String, String> toJson() => {'name': name, 'category': category};
}

String _normalizeCategory(String? category) {
  return switch (category) {
    'Healthy' ||
    'Fast Food' ||
    'Snacks' ||
    'Drinks' ||
    'Meats' ||
    'Fruit' ||
    'Vegetable' ||
    'Meals' => category!,
    _ => 'Meals',
  };
}
