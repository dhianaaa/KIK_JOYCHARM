import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:joycharm/main.dart';

void main() {
  testWidgets('JoyCharm app loads correctly',
      (WidgetTester tester) async {

    // Build app
    await tester.pumpWidget(const JoyCharmApp());

    // Verify MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify SplashScreen loaded
    expect(find.byType(Scaffold), findsWidgets);

  });
}