import 'package:flutter/material.dart';
import '../../../common/widgets/responsive_layout.dart';

class AttributesScreen extends StatelessWidget {
  const AttributesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _AttributesMobile(),
      tablet: _AttributesTablet(),
      desktop: _AttributesDesktop(),
    );
  }
}

//
// ----------------------
// MOBILE LAYOUT
// ----------------------
//
class _AttributesMobile extends StatelessWidget {
  const _AttributesMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attributes")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SearchBar(),
          SizedBox(height: 16),
          _CategoryFilters(),
          SizedBox(height: 20),
          _AttributesGrid(),
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
class _AttributesTablet extends StatelessWidget {
  const _AttributesTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attributes")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            _SearchBar(),
            SizedBox(height: 16),
            _CategoryFilters(),
            SizedBox(height: 24),
            Expanded(child: _AttributesGrid()),
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
class _AttributesDesktop extends StatelessWidget {
  const _AttributesDesktop();

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
                  Expanded(child: _AttributesGrid()),
                ],
              ),
            ),
            SizedBox(width: 32),
            Expanded(
              flex: 2,
              child: _AttributeDetailPanel(),
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
        hintText: "Search attributes...",
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
    final categories = [
      "Texture",
      "Flavor",
      "Visual",
      "Temperature",
      "Other",
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          return Chip(
            label: Text(categories[i]),
            backgroundColor: Colors.grey.shade200,
          );
        },
      ),
    );
  }
}

class _AttributesGrid extends StatelessWidget {
  const _AttributesGrid();

  @override
  Widget build(BuildContext context) {
    final attributes = [
      "Crunchy",
      "Soft",
      "Chewy",
      "Sweet",
      "Sour",
      "Bitter",
      "Spicy",
      "Cold",
      "Warm",
      "Smooth",
      "Creamy",
      "Dry",
      "Juicy",
      "Sticky",
    ];

    final crossAxisCount = ResponsiveLayout.isDesktop(context)
        ? 4
        : ResponsiveLayout.isTablet(context)
            ? 3
            : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attributes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (_, i) {
        return Card(
          elevation: 2,
          child: Center(
            child: Text(
              attributes[i],
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

class _AttributeDetailPanel extends StatelessWidget {
  const _AttributeDetailPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Attribute Details",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),

            // Placeholder detail
            const ListTile(
              leading: Icon(Icons.texture),
              title: Text("Crunchy"),
              subtitle: Text("Texture attribute"),
            ),

            const SizedBox(height: 20),
            Text("Foods with this attribute",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 12,
              children: [
                Chip(label: Text("Chips")),
                Chip(label: Text("Carrots")),
                Chip(label: Text("Granola")),
              ],
            ),

            const SizedBox(height: 20),
            Text("People who prefer this",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 12,
              children: [
                Chip(label: Text("John")),
                Chip(label: Text("Mike")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
