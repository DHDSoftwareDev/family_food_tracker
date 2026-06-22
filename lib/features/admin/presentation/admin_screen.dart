import 'package:flutter/material.dart';
import '../../../common/widgets/responsive_layout.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _AdminMobile(),
      tablet: _AdminTablet(),
      desktop: _AdminDesktop(),
    );
  }
}

//
// ----------------------
// MOBILE LAYOUT
// ----------------------
//
class _AdminMobile extends StatelessWidget {
  const _AdminMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SettingsCard(),
          SizedBox(height: 20),
          _SystemInfoCard(),
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
class _AdminTablet extends StatelessWidget {
  const _AdminTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: const [
            Expanded(flex: 2, child: _SettingsCard()),
            SizedBox(width: 24),
            Expanded(flex: 3, child: _SystemInfoCard()),
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
class _AdminDesktop extends StatelessWidget {
  const _AdminDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: const [
            Expanded(flex: 2, child: _SettingsCard()),
            SizedBox(width: 32),
            Expanded(flex: 3, child: _SystemInfoCard()),
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

class _SettingsCard extends StatefulWidget {
  const _SettingsCard();

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  bool notifications = true;
  bool darkMode = false;
  bool autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Settings",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text("Enable Notifications"),
              value: notifications,
              onChanged: (v) => setState(() => notifications = v),
            ),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
            ),
            SwitchListTile(
              title: const Text("Auto Sync Data"),
              value: autoSync,
              onChanged: (v) => setState(() => autoSync = v),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text("Reset App Data"),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemInfoCard extends StatelessWidget {
  const _SystemInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("System Info",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),

            const ListTile(
              leading: Icon(Icons.info),
              title: Text("App Version"),
              subtitle: Text("1.0.0"),
            ),
            const ListTile(
              leading: Icon(Icons.storage),
              title: Text("Storage Used"),
              subtitle: Text("128 MB"),
            ),
            const ListTile(
              leading: Icon(Icons.cloud_sync),
              title: Text("Last Sync"),
              subtitle: Text("Today at 3:45 PM"),
            ),

            const SizedBox(height: 20),
            Text("Environment",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 12,
              children: [
                Chip(label: Text("Production")),
                Chip(label: Text("AWS Lambda")),
                Chip(label: Text("DynamoDB")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
