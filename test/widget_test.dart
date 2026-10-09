import 'package:flutter_test/flutter_test.dart';
import 'package:livetv/main.dart';

void main() {
  testWidgets('LiveTvApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LiveTvApp());
    expect(find.byType(LiveTvApp), findsOneWidget);
  });
}
