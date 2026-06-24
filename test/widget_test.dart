import 'package:family_food_tracker/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders the dashboard route', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Foods'), findsWidgets);
  });

  testWidgets('adds a food from the foods screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Foods').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('foods-list')), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-food-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('food-name-field')),
      'Grilled chicken',
    );
    await tester.tap(find.byKey(const Key('save-food-button')));
    await tester.pumpAndSettle();

    expect(find.text('Grilled chicken'), findsWidgets);
    expect(find.text('Grilled chicken added'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('foods'), contains('Grilled chicken'));
  });

  testWidgets('searches foods by name and clears the search', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Foods').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('food-search-field')), 'pIz');
    await tester.pump();

    expect(find.text('Pizza'), findsWidgets);
    expect(find.text('Fast Food'), findsWidgets);
    expect(find.text('Salad'), findsNothing);

    await tester.enterText(find.byKey(const Key('food-search-field')), 'sushi');
    await tester.pump();

    expect(find.text('No foods found'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clear-food-search')));
    await tester.pump();

    expect(find.text('Salad'), findsWidgets);
    expect(find.text('No foods found'), findsNothing);
  });

  testWidgets('shows each food once and reveals actions on swipe', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Foods').last);
    await tester.pumpAndSettle();

    expect(find.text('Pizza'), findsOneWidget);
    expect(find.text('Added today'), findsNothing);
    expect(find.byKey(const Key('edit-Pizza')), findsNothing);

    await tester.drag(
      find.byKey(const Key('food-card-Pizza')),
      const Offset(-180, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('edit-Pizza')), findsOneWidget);
    expect(find.byKey(const Key('delete-Pizza')), findsOneWidget);
  });

  testWidgets('filters foods by category', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Foods').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('food-category-Fruit')));
    await tester.pump();

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Pizza'), findsNothing);

    await tester.tap(find.byKey(const Key('food-category-All')));
    await tester.pump();

    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Pizza'), findsOneWidget);
  });
}
