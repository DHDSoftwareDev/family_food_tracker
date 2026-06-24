import 'package:family_food_tracker/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
    expect(find.text('Salad'), findsNothing);

    await tester.enterText(find.byKey(const Key('food-search-field')), 'sushi');
    await tester.pump();

    expect(find.text('No foods found'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clear-food-search')));
    await tester.pump();

    expect(find.text('Salad'), findsWidgets);
    expect(find.text('No foods found'), findsNothing);
  });
}
