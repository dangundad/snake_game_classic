import 'package:flutter_test/flutter_test.dart';
import 'package:snake_game_classic/main.dart';

void main() {
  testWidgets('snake_game_classic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SnakeGameClassicApp());

    expect(find.byType(SnakeGameClassicApp), findsOneWidget);
  });
}
