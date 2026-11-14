// Fila de un producto en la lista: foto, marca, nombre, precio y stock.
import 'package:flutter/cupertino.dart';

import '../models/producto.dart';
import '../theme/app_theme.dart';
import 'producto_imagen.dart';

class ProductoTile extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  final VoidCallback onMas;

  /// Animación Hero hacia el detalle (se desactiva en la vista previa)
  final bool conHero;

  const ProductoTile({
    super.key,
    required this.producto,
    required this.onTap,
    required this.onMas,
    this.conHero = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            HeroMode(
              enabled: conHero,
              child: Hero(
                tag: 'producto-${producto.id}',
                child: ProductoImagen(
                  url: producto.imagenUrl,
                  iconoRespaldo: producto.icono,
                  categoria: producto.categoria,
                  size: 68,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.marca.isEmpty
                        ? producto.categoria.toUpperCase()
                        : '${producto.marca.toUpperCase()} · ${producto.categoria.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: AppColors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    producto.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.headline,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        producto.precioFormateado,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      StockBadge(stock: producto.stock),
                    ],
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onPressed: onMas,
              child: const Icon(
                CupertinoIcons.ellipsis,
                color: AppColors.tertiaryLabel,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Etiqueta de color con las unidades disponibles
class StockBadge extends StatelessWidget {
  final int stock;
  const StockBadge({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.stock(stock);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            stock == 1 ? '1 ud.' : '$stock uds.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
