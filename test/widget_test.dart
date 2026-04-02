import 'package:flutter_test/flutter_test.dart';
import 'package:the_blank/app/app.dart';

void main() {
  testWidgets('shows categories and opens a category screen', (tester) async {
    await tester.pumpWidget(const TheBlankApp());

    expect(find.text('Component Categories'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);

    await tester.tap(find.text('Buttons'));
    await tester.pumpAndSettle();

    expect(find.text('Button'), findsOneWidget);
    expect(find.text('ToggleButtonGroup'), findsOneWidget);
  });
}
