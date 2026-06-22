import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Feature Screens ---
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/foods/presentation/foods_screen.dart';
import 'features/people/presentation/people_screen.dart';
import 'features/attributes/presentation/attributes_screen.dart';
import 'features/admin/presentation/admin_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Family Food Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// ----------------------
// GoRouter Configuration
// ----------------------

final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/foods',
          builder: (context, state) => const FoodsScreen(),
        ),
        GoRoute(
          path: '/people',
          builder: (context, state) => const PeopleScreen(),
        ),
        GoRoute(
          path: '/attributes',
          builder: (context, state) => const AttributesScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminScreen(),
        ),
      ],
    ),
  ],
);

// ----------------------
// Responsive Navigation Shell
// ----------------------

class AppScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  final tabs = [
    '/dashboard',
    '/foods',
    '/people',
    '/attributes',
    '/admin',
  ];

  int _getIndexFromLocation(String location) {
    final index = tabs.indexWhere((t) => location.startsWith(t));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getIndexFromLocation(location);

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => context.go(tabs[i]),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.fastfood_outlined),
                  selectedIcon: Icon(Icons.fastfood),
                  label: Text('Foods'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('People'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category),
                  label: Text('Attributes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Admin'),
                ),
              ],
            ),

          Expanded(child: widget.child),
        ],
      ),

      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => context.go(tabs[i]),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.fastfood_outlined),
                  selectedIcon: Icon(Icons.fastfood),
                  label: 'Foods',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'People',
                ),
                NavigationDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category),
                  label: 'Attributes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Admin',
                ),
              ],
            ),
    );
  }
}
