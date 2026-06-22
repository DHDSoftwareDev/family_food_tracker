import 'package:flutter/material.dart';
import '../../../common/widgets/responsive_layout.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: _DashboardMobile(),
      tablet: _DashboardTablet(),
      desktop: _DashboardDesktop(),
    );
  }
}

//
// ----------------------
// MOBILE LAYOUT
// ----------------------
//
class _DashboardMobile extends StatelessWidget {
  const _DashboardMobile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HeroCard(),
          SizedBox(height: 20),
          _QuickStatsGrid(),
          SizedBox(height: 20),
          _WeeklyChart(),
          SizedBox(height: 20),
          _RecentActivityList(),
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
class _DashboardTablet extends StatelessWidget {
  const _DashboardTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: const [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _HeroCard(),
                    SizedBox(height: 20),
                    _QuickStatsGrid(),
                    SizedBox(height: 20),
                    _RecentActivityList(),
                  ],
                ),
              ),
            ),
            SizedBox(width: 24),
            Expanded(flex: 3, child: _WeeklyChart()),
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
class _DashboardDesktop extends StatelessWidget {
  const _DashboardDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: const [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _HeroCard(),
                  SizedBox(height: 20),
                  _QuickStatsGrid(),
                  SizedBox(height: 20),
                  Expanded(child: _RecentActivityList()),
                ],
              ),
            ),
            SizedBox(width: 32),
            Expanded(flex: 3, child: _WeeklyChart()),
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

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(Icons.fastfood, size: 48),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back, DHD!",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Here’s your food activity summary",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
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

class _QuickStatsGrid extends StatelessWidget {
  const _QuickStatsGrid();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 4 : 2,
      childAspectRatio: isDesktop ? 1.8 : 1.2,
      children: const [
        _StatCard(label: "Foods Logged", value: "42", icon: Icons.list),
        _StatCard(label: "People", value: "6", icon: Icons.people),
        _StatCard(label: "Attributes", value: "18", icon: Icons.category),
        _StatCard(label: "Favorites", value: "9", icon: Icons.favorite),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3)]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4)]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 6)]),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        ListTile(
          leading: Icon(Icons.local_pizza),
          title: Text("Pizza added"),
          subtitle: Text("Today"),
        ),
        ListTile(
          leading: Icon(Icons.eco),
          title: Text("Salad added"),
          subtitle: Text("Yesterday"),
        ),
        ListTile(
          leading: Icon(Icons.lunch_dining),
          title: Text("Burger added"),
          subtitle: Text("2 days ago"),
        ),
      ],
    );
  }
}
