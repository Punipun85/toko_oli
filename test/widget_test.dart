import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/features/home/presentation/pages/dashboard_page.dart';
import 'package:toko_oli/core/theme/app_theme.dart';

const _sharedPreferencesChannel = MethodChannel(
  'plugins.flutter.io/shared_preferences',
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_sharedPreferencesChannel, (
          methodCall,
        ) async {
          if (methodCall.method == 'getAll') {
            return <String, Object>{};
          }

          return true;
        });
  });

  testWidgets('dashboard shows navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: buildTokoOliTheme(), home: const DashboardPage()),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('dashboard can switch to cart tab', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: buildTokoOliTheme(), home: const DashboardPage()),
      ),
    );

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Cart Overview'), findsOneWidget);
    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });
}
