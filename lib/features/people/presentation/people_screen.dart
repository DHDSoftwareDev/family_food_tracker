import 'package:flutter/material.dart';
import '../../../common/widgets/responsive_layout.dart';
import '../data/people_data.dart';

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
            Expanded(flex: 2, child: _PersonDetailPanel()),
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
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: peopleProfiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final person = peopleProfiles[i];
          return Column(
            children: [
              CircleAvatar(radius: 26, child: Icon(person.icon, size: 28)),
              const SizedBox(height: 6),
              Text(person.name),
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
    return ListView.separated(
      shrinkWrap: true,
      itemCount: peopleProfiles.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (_, i) {
        final person = peopleProfiles[i];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(person.name),
          subtitle: Text(person.summary),
          trailing: Icon(person.icon),
        );
      },
    );
  }
}

class _PersonDetailPanel extends StatelessWidget {
  const _PersonDetailPanel();

  @override
  Widget build(BuildContext context) {
    final person = peopleProfiles.first;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Person Details",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Placeholder details
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(person.name),
              subtitle: Text(person.summary),
            ),

            const SizedBox(height: 20),
            Text("Preferences", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: person.preferences
                  .map((preference) => Chip(label: Text(preference)))
                  .toList(),
            ),

            const SizedBox(height: 20),
            Text("Avoids", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: person.dislikes
                  .map((dislike) => Chip(label: Text(dislike)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
