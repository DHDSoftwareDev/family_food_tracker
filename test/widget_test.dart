import 'package:family_food_tracker/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('renders the dashboard route', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Foods'), findsWidgets);
  });
}
