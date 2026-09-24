import 'package:flutter_test/flutter_test.dart';
import 'package:smog_risk_prediction_system/main.dart';

void main() {
  testWidgets('Smog Risk Prediction System loads', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmogRiskApp());

    expect(find.text('Smog Risk Prediction System'), findsOneWidget);
  });
}