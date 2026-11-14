// Colores, estilos de texto y tema Cupertino de toda la app.
// Se usa la paleta del sistema de iOS para que la app se sienta nativa.
import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  // Color de marca (índigo de iOS)
  static const Color primary = Color(0xFF5856D6);
  static const Color primaryDark = Color(0xFF3634A3);

  // Fondos estilo "Ajustes" de iOS
  static const Color background = Color(0xFFF2F2F7); // systemGroupedBackground
  static const Color card = Color(0xFFFFFFFF);
  static const Color fill = Color(0xFFEFEFF4);
  static const Color separator = Color(0xFFE5E5EA);

  // Texto
  static const Color label = Color(0xFF1C1C1E);
  static const Color secondaryLabel = Color(0xFF6E6E73);
  static const Color tertiaryLabel = Color(0xFFAEAEB2);

  // Estados
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color danger = Color(0xFFFF3B30);
  static const Color blue = Color(0xFF007AFF);
  static const Color teal = Color(0xFF30B0C7);
  static const Color pink = Color(0xFFFF2D55);
  static const Color grey = Color(0xFF8E8E93);

  /// Tarjeta oscura del resumen del inventario
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1C1C2E), Color(0xFF34336B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ícono de la app en el login
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF7D7AFF), Color(0xFF5856D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Color de cada categoría (para íconos y etiquetas)
  static Color categoria(String categoria) {
    switch (categoria) {
      case 'Laptops':
        return primary;
      case 'Celulares':
        return blue;
      case 'Tablets':
        return teal;
      case 'Audio':
        return pink;
      case 'Wearables':
        return warning;
      case 'Accesorios':
        return success;
      default:
        return grey;
    }
  }

  /// Color según el stock disponible
  static Color stock(int unidades) {
    if (unidades <= 5) return danger;
    if (unidades <= 12) return warning;
    return success;
  }

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}

/// Estilos de texto basados en la tipografía de iOS
class AppText {
  AppText._();

  static const TextStyle largeTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    color: AppColors.label,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.label,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.label,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    letterSpacing: -0.2,
    color: AppColors.label,
  );

  static const TextStyle subhead = TextStyle(
    fontSize: 14,
    letterSpacing: -0.1,
    color: AppColors.secondaryLabel,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryLabel,
  );

  /// Título de sección (como en Ajustes de iOS)
  static const TextStyle section = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.label,
  );
}

class AppTheme {
  AppTheme._();

  static const CupertinoThemeData light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    barBackgroundColor: Color(0xF0F9F9F9),
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.primary,
      textStyle: AppText.body,
      navLargeTitleTextStyle: AppText.largeTitle,
    ),
  );
}
