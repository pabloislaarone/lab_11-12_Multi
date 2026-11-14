// Detalle de un producto (se abre al tocarlo en la lista o en el Inicio)
import 'package:flutter/cupertino.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/icon_box.dart';
import '../widgets/producto_imagen.dart';
import '../widgets/producto_tile.dart';
import '../widgets/section_header.dart';

class DetalleProductoScreen extends StatelessWidget {
  final String productoId;
  const DetalleProductoScreen({super.key, required this.productoId});

  /// Confirma y elimina el producto. Devuelve true si se eliminó.
  static Future<bool> confirmarEliminar(BuildContext context, Producto p) async {
    final ok = await preguntarEliminar(context, p);
    if (!ok) return false;
    if (context.mounted) eliminar(context, p);
    return true;
  }

  /// Elimina el producto y muestra el aviso
  static void eliminar(BuildContext context, Producto p) {
    AppData.eliminarProducto(p.id);
    AppToast.show(
      context,
      '"${p.nombre}" eliminado',
      icono: CupertinoIcons.trash,
      color: AppColors.danger,
    );
  }

  /// Diálogo de confirmación de iOS. Devuelve true si el usuario acepta.
  static Future<bool> preguntarEliminar(BuildContext context, Producto p) async {
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text('¿Eliminar "${p.nombre}"?'),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('El producto se quitará del inventario.'),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  @override
  Widget build(BuildContext context) {
    // Escucha la lista: si el producto se edita, el detalle se actualiza solo
    return ValueListenableBuilder<List<Producto>>(
      valueListenable: AppData.productos,
      builder: (context, lista, _) {
        final encontrados = lista.where((p) => p.id == productoId);
        if (encontrados.isEmpty) {
          return const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text('Producto')),
            child: Center(child: Text('Este producto ya no existe', style: AppText.subhead)),
          );
        }
        final p = encontrados.first;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(p.nombre),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => AppRoutes.abrir(context, AppRoutes.registrarProducto, arguments: p),
              child: const Text('Editar'),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                // Foto grande
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Center(
                    child: Hero(
                      tag: 'producto-${p.id}',
                      child: ProductoImagen(
                        url: p.imagenUrl,
                        iconoRespaldo: p.icono,
                        categoria: p.categoria,
                        size: 220,
                        radius: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _EtiquetaCategoria(texto: p.categoria, color: AppColors.categoria(p.categoria)),
                          const SizedBox(width: 8),
                          StockBadge(stock: p.stock),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (p.marca.isNotEmpty) Text(p.marca, style: AppText.subhead),
                      Text(p.nombre, style: AppText.title),
                      const SizedBox(height: 6),
                      Text(
                        p.precioFormateado,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoListSection.insetGrouped(
                  header: const SectionHeader('Inventario'),
                  children: [
                    CupertinoListTile(
                      leading: const IconBox(icon: CupertinoIcons.tag_fill, color: AppColors.primary),
                      title: const Text('Precio unitario'),
                      additionalInfo: Text(p.precioFormateado),
                    ),
                    CupertinoListTile(
                      leading: const IconBox(icon: CupertinoIcons.cube_box_fill, color: AppColors.blue),
                      title: const Text('Unidades en stock'),
                      additionalInfo: Text('${p.stock}'),
                    ),
                    CupertinoListTile(
                      leading: const IconBox(
                        icon: CupertinoIcons.money_dollar_circle_fill,
                        color: AppColors.success,
                      ),
                      title: const Text('Valor en inventario'),
                      additionalInfo: Text(Producto.soles(p.precio * p.stock)),
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  header: const SectionHeader('Descripción'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        p.descripcion.isEmpty ? 'Sin descripción.' : p.descripcion,
                        style: const TextStyle(fontSize: 15, height: 1.45, color: AppColors.label),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          borderRadius: BorderRadius.circular(14),
                          onPressed: () =>
                              AppRoutes.abrir(context, AppRoutes.registrarProducto, arguments: p),
                          child: const Text('Editar producto'),
                        ),
                      ),
                      const SizedBox(height: 4),
                      CupertinoButton(
                        onPressed: () async {
                          final eliminado = await confirmarEliminar(context, p);
                          if (eliminado && context.mounted) Navigator.pop(context);
                        },
                        child: const Text(
                          'Eliminar producto',
                          style: TextStyle(color: AppColors.danger),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EtiquetaCategoria extends StatelessWidget {
  final String texto;
  final Color color;
  const _EtiquetaCategoria({required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
