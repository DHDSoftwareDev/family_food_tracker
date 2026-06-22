import 'package:flutter/material.dart';
import '../../../common/widgets/responsive_layout.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _PeopleMobile(),
      tablet: _PeopleTablet(),
      desktop: _PeopleDesktop(),
    );
  }
}

//
// ----------------------
// MOBILE LAYOUT
// ----------------------
//
class _PeopleMobile extends StatelessWidget {
  const _PeopleMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("People")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SearchBar(),
          SizedBox(height: 16),
          _AvatarScroller(),
          SizedBox(height: 20),
          _PeopleList(),
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
class _PeopleTablet extends StatelessWidget {
  const _PeopleTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("People")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            _SearchBar(),
            SizedBox(height: 16),
            _AvatarScroller(),
            SizedBox(height: 24),
            Expanded(child: _PeopleList()),
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
class _PeopleDesktop extends StatelessWidget {
  const _PeopleDesktop();

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
                  _AvatarScroller(),
                  SizedBox(height: 24),
                  Expanded(child: _PeopleList()),
                ],
              ),
            ),
            SizedBox(width: 32),
            Expanded(
              flex: 2,
              child: _PersonDetailPanel(),
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
        hintText: "Search people...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AvatarScroller extends StatelessWidget {
  const _AvatarScroller();

  @override
  Widget build(BuildContext context) {
    final people = [
      ("John", Icons.person),
      ("Sarah", Icons.person),
      ("Emma", Icons.person),
      ("Mike", Icons.person),
      ("Olivia", Icons.person),
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: people.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          return Column(
            children: [
              CircleAvatar(
                radius: 26,
                child: Icon(people[i].$2, size: 28),
              ),
              const SizedBox(height: 6),
              Text(people[i].$1),
            ],
          );
        },
      ),
    );
  }
}

class _PeopleList extends StatelessWidget {
  const _PeopleList();

  @override
  Widget build(BuildContext context) {
    final people = [
      ("John", "Loves spicy food", Icons.local_fire_department),
      ("Sarah", "Vegetarian", Icons.eco),
      ("Emma", "Avoids dairy", Icons.no_food),
      ("Mike", "Prefers crunchy textures", Icons.texture),
      ("Olivia", "Sweet tooth", Icons.cake),
    ];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: people.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (_, i) {
        return ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(people[i].$1),
          subtitle: Text(people[i].$2),
          trailing: Icon(people[i].$3),
        );
      },
    );
  }
}

class _PersonDetailPanel extends StatelessWidget {
  const _PersonDetailPanel();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Person Details",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),

            // Placeholder details
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("John"),
              subtitle: Text("Loves spicy food"),
            ),

            const SizedBox(height: 20),
            Text("Preferences",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: const [
                Chip(label: Text("Spicy")),
                Chip(label: Text("Crunchy")),
                Chip(label: Text("Savory")),
              ],
            ),

            const SizedBox(height: 20),
            Text("Avoids",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: const [
                Chip(label: Text("Dairy")),
                Chip(label: Text("Soft textures")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
