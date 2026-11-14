// Prueba básica: la app abre en el Login y entra al Inicio con la cuenta demo
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techstore_app/main.dart';

void main() {
  testWidgets('Login -> Inicio con credenciales demo', (tester) async {
    await tester.pumpWidget(const TechStoreApp());
    expect(find.text('TechStore'), findsOneWidget);

    await tester.enterText(find.byType(CupertinoTextField).at(0), 'admin@techstore.com');
    await tester.enterText(find.byType(CupertinoTextField).at(1), '123456');
    await tester.tap(find.text('Iniciar sesión'));
    // pump con tiempo fijo: el indicador de carga de iOS gira sin parar
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Accesos rápidos'), findsOneWidget);
  });
}
