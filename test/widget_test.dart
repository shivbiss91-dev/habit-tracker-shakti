import 'package:flutter_test/flutter_test.dart';
import 'package:habitrack/main.dart';

void main() {
  testWidgets('HabiTrack app smoke test', (WidgetTester tester) async {
    // Basic widget tree test
    await tester.pumpWidget(const HabiTrackApp());
  });
}
