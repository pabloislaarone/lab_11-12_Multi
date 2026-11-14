// PANTALLA 2: MENÚ PRINCIPAL (pestaña Inicio)
// Saludo, resumen del inventario, accesos a cada pantalla,
// productos con stock bajo y carrusel de destacados.
import 'package:flutter/cupertino.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/icon_box.dart';
import '../widgets/producto_imagen.dart';
import '../widgets/producto_tile.dart';
import '../widgets/section_header.dart';
import 'detalle_producto_screen.dart';

class MenuScreen extends StatelessWidget {
  final VoidCallback onVerProductos;
  final VoidCallback onVerPerfil;

  const MenuScreen({
    super.key,
    required this.onVerProductos,
    required this.onVerPerfil,
  });

  /// Fecha en español sin librerías: "Sábado, 14 de noviembre"
  static String fechaHoy() {
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    const meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    final h = DateTime.now();
    return '${dias[h.weekday - 1]}, ${h.day} de ${meses[h.month - 1]}';
  }

  void _abrirDetalle(BuildContext context, Producto p) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => DetalleProductoScreen(productoId: p.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<Producto>>(
        valueListenable: AppData.productos,
        builder: (context, productos, _) {
          final bajos = AppData.stockBajo;
          final destacados = [...productos]..sort((a, b) => b.precio.compareTo(a.precio));

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Inicio'),
                middle: const Text('Inicio'),
                alwaysShowMiddle: false,
                border: null,
                backgroundColor: AppColors.background.withValues(alpha: 0.9),
                trailing: _AvatarBoton(onTap: onVerPerfil),
              ),
              SliverToBoxAdapter(child: _Saludo(fecha: fechaHoy())),
              SliverToBoxAdapter(
                child: _ResumenCard(
                  productos: productos.length,
                  unidades: AppData.totalUnidades,
                  valor: AppData.valorInventario,
                  stockBajo: bajos.length,
                ),
              ),

              // Accesos a cada pantalla del laboratorio
              SliverToBoxAdapter(
                child: CupertinoListSection.insetGrouped(
                  header: const SectionHeader('Accesos rápidos'),
                  children: [
                    CupertinoListTile(
                      leading: const IconBox(icon: CupertinoIcons.plus, color: AppColors.primary),
                      title: const Text('Registrar producto'),
                      subtitle: const Text('Agregar al inventario'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: () => AppRoutes.abrir(context, AppRoutes.registrarProducto),
                    ),
                    CupertinoListTile(
                      leading: const IconBox(icon: CupertinoIcons.list_bullet, color: AppColors.blue),
                      title: const Text('Listar productos'),
                      subtitle: const Text('Buscar, editar y eliminar'),
                      additionalInfo: Text('${productos.length}'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: onVerProductos,
                    ),
                    CupertinoListTile(
                      leading: const IconBox(icon: CupertinoIcons.person_fill, color: AppColors.teal),
                      title: const Text('Mi perfil'),
                      subtitle: const Text('Datos de la cuenta'),
                      trailing: const CupertinoListTileChevron(),
                      onTap: onVerPerfil,
                    ),
                    CupertinoListTile(
                      leading: const IconBox(
                        icon: CupertinoIcons.square_arrow_right,
                        color: AppColors.danger,
                      ),
                      title: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: AppColors.danger),
                      ),
                      onTap: () => AppRoutes.cerrarSesion(context),
                    ),
                  ],
                ),
              ),

              // Productos que se están acabando
              if (bajos.isNotEmpty)
                SliverToBoxAdapter(
                  child: CupertinoListSection.insetGrouped(
                    header: const SectionHeader('Stock bajo'),
                    footer: const Text('Productos con 8 unidades o menos.'),
                    children: [
                      for (final p in bajos.take(4))
                        CupertinoListTile(
                          leadingSize: 40,
                          leading: ProductoImagen(
                            url: p.imagenUrl,
                            iconoRespaldo: p.icono,
                            categoria: p.categoria,
                            size: 40,
                            radius: 9,
                          ),
                          title: Text(p.nombre),
                          subtitle: Text(p.marca),
                          additionalInfo: StockBadge(stock: p.stock),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => _abrirDetalle(context, p),
                        ),
                    ],
                  ),
                ),

              // Carrusel horizontal con los productos de mayor precio
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 8, 10),
                  child: Row(
                    children: [
                      const Text('Destacados', style: AppText.section),
                      const Spacer(),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: onVerProductos,
                        child: const Text('Ver todos', style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 224,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    clipBehavior: Clip.none,
                    itemCount: destacados.length < 6 ? destacados.length : 6,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => _DestacadoCard(
                      producto: destacados[i],
                      onTap: () => _abrirDetalle(context, destacados[i]),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Avatar con las iniciales del usuario (abre la pestaña Perfil)
class _AvatarBoton extends StatelessWidget {
  final VoidCallback onTap;
  const _AvatarBoton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Usuario>(
      valueListenable: AppData.usuario,
      builder: (_, u, __) => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
          ),
          child: Text(
            u.iniciales,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Saludo extends StatelessWidget {
  final String fecha;
  const _Saludo({required this.fecha});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Usuario>(
      valueListenable: AppData.usuario,
      builder: (_, u, __) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fecha.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: AppColors.secondaryLabel,
              ),
            ),
            const SizedBox(height: 4),
            Text('Hola, ${u.nombre.split(' ').first}', style: AppText.title),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta oscura con el valor total del inventario
class _ResumenCard extends StatelessWidget {
  final int productos;
  final int unidades;
  final double valor;
  final int stockBajo;

  const _ResumenCard({
    required this.productos,
    required this.unidades,
    required this.valor,
    required this.stockBajo,
  });

  @override
  Widget build(BuildContext context) {
    final valorTexto = Producto.soles(valor);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Valor del inventario',
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.white.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Icon(
                CupertinoIcons.chart_bar_alt_fill,
                size: 18,
                color: CupertinoColors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              valorTexto,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 0.5, color: CupertinoColors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 14),
          Row(
            children: [
              _Dato(valor: '$productos', etiqueta: 'Productos'),
              _Dato(valor: '$unidades', etiqueta: 'Unidades'),
              _Dato(
                valor: '$stockBajo',
                etiqueta: 'Stock bajo',
                color: stockBajo > 0 ? const Color(0xFFFFB340) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final Color? color;
  const _Dato({required this.valor, required this.etiqueta, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color ?? CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 12,
              color: CupertinoColors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta del carrusel de destacados
class _DestacadoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  const _DestacadoCard({required this.producto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductoImagen(
              url: producto.imagenUrl,
              iconoRespaldo: producto.icono,
              categoria: producto.categoria,
              size: 130,
              radius: 12,
            ),
            const SizedBox(height: 10),
            Text(producto.marca, style: AppText.caption),
            Text(
              producto.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.label),
            ),
            const SizedBox(height: 2),
            Text(
              producto.precioFormateado,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
