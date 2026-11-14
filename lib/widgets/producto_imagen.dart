// Foto del producto desde internet.
// Mientras carga muestra un CupertinoActivityIndicator y, si no hay foto
// o falla la descarga, muestra el ícono de la categoría.
import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

class ProductoImagen extends StatelessWidget {
  final String? url;
  final IconData iconoRespaldo;
  final String categoria;
  final double size;
  final double radius;

  const ProductoImagen({
    super.key,
    required this.url,
    required this.iconoRespaldo,
    required this.categoria,
    this.size = 64,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoria(categoria);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.fill.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: (url == null || url!.isEmpty)
          ? _respaldo(color)
          : Padding(
              padding: EdgeInsets.all(size * 0.08),
              child: Image.network(
                url!,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progreso) {
                  if (progreso == null) return child;
                  return const Center(child: CupertinoActivityIndicator());
                },
                errorBuilder: (_, __, ___) => _respaldo(color),
              ),
            ),
    );
  }

  Widget _respaldo(Color color) {
    return Container(
      color: color.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(iconoRespaldo, size: size * 0.42, color: color),
    );
  }
}
