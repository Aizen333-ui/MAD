import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mad/main.dart';

void main() {
  testWidgets('selects multiple dishes and orders them', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MadRestaurantApp());

    expect(find.text('Restaurant Menu'), findsOneWidget);
    expect(find.text('Margherita Pizza'), findsOneWidget);
    expect(find.text('Classic Burger'), findsOneWidget);
    expect(find.text('Creamy Alfredo Pasta'), findsOneWidget);
    expect(find.text('Crispy Chicken'), findsOneWidget);
    expect(find.text('Select dishes to order'), findsOneWidget);
    expect(find.text('299'), findsOneWidget);

    await tester.tap(find.text('Classic Burger'));
    await tester.pump();
    expect(find.text('Order 1 dish · 349'), findsOneWidget);

    await tester.tap(find.text('Margherita Pizza'));
    await tester.pump();
    expect(find.text('Order 2 dishes · 648'), findsOneWidget);

    await tester.tap(find.text('Order 2 dishes · 648'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Your food has been ordered!'), findsOneWidget);
    expect(find.text('Select dishes to order'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Chocolate Brownie'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Garden Salad'), findsOneWidget);
    expect(find.text('Chocolate Brownie'), findsOneWidget);
  });
}
