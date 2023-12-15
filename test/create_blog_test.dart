// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:blogz/ui/blog/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Verify if all form are empty, display ErrorSnackbar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateBlogPage()));

    expect(find.text('Titre'), findsOneWidget);


    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(
        find.text(
            'Veuillez saisir au moins un titre, un résumé et le contenu du blogz'),
        findsOneWidget);
  });
}
