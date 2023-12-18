import 'package:blogz/ui/blog/create_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'Verify if all form is generated and if we display ErrorSnackbar when there is no image',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.view.physicalSize = const Size(2000, 2000);

    await tester.pumpWidget(const MaterialApp(home: CreateBlogPage()));

    expect(find.text('Titre'), findsOneWidget);
    expect(find.text('Sommaire'), findsOneWidget);
    expect(find.text('Contenu'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);

    final Finder createBlogButton = find.byKey(const Key('CreateBlog'));

    await tester.ensureVisible(createBlogButton);
    await tester.tap(createBlogButton);

    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(find.text("Vous n'avez mis aucune image"), findsOneWidget);
  });
}
