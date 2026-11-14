// PANTALLA 2: MENÚ PRINCIPAL (pestaña Inicio)
// Saludo, resumen del inventario, accesos a cada pantalla,
// productos con stock bajo y carrusel de destacados.
import 'package:flutter/cupertino.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_header.dart';
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
    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
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
          final destacados = [...productos]
            ..sort((a, b) => b.precio.compareTo(a.precio));

          return CustomScrollView(
            slivers: [
              AppSliverNavBar(
                titulo: 'Inicio',
                trailing: _AvatarBoton(onTap: onVerPerfil),
              ),

              // Encabezado azul: saludo y resumen del inventario
              SliverToBoxAdapter(
                child: GradientHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Saludo(fecha: fechaHoy()),
                      const SizedBox(height: 18),
                      _ResumenInventario(
                        productos: productos.length,
                        unidades: AppData.totalUnidades,
                        valor: AppData.valorInventario,
                        stockBajo: bajos.length,
                      ),
                    ],
                  ),
                ),
              ),

              // Accesos a cada pantalla del laboratorio
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text('Accesos rápidos', style: AppText.section),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: [
                    _Acceso(
                      icono: CupertinoIcons.plus_app_fill,
                      titulo: 'Registrar',
                      subtitulo: 'Nuevo producto',
                      degradado: AppColors.accesos[0],
                      onTap: () =>
                          AppRoutes.abrir(context, AppRoutes.registrarProducto),
                    ),
                    _Acceso(
                      icono: CupertinoIcons.square_list_fill,
                      titulo: 'Productos',
                      subtitulo: '${productos.length} en inventario',
                      degradado: AppColors.accesos[1],
                      onTap: onVerProductos,
                    ),
                    _Acceso(
                      icono: CupertinoIcons.person_crop_circle_fill,
                      titulo: 'Mi perfil',
                      subtitulo: 'Datos de cuenta',
                      degradado: AppColors.accesos[2],
                      onTap: onVerPerfil,
                    ),
                    _Acceso(
                      icono: CupertinoIcons.square_arrow_right,
                      titulo: 'Cerrar sesión',
                      subtitulo: 'Salir de la app',
                      degradado: AppColors.accesos[3],
                      onTap: () => AppRoutes.cerrarSesion(context),
                    ),
                  ],
                ),
              ),

              // Productos que se están acabando
              if (bajos.isNotEmpty)
                SliverToBoxAdapter(
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: AppColors.background,
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
                            radius: 10,
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
                        child: const Text('Ver todos',
                            style: TextStyle(fontSize: 15)),
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
                child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 32),
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
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
            border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.6),
                width: 1.5),
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
      builder: (_, u, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fecha.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFF67E8F9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hola, ${u.nombre.split(' ').first}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta translúcida con el valor total del inventario
class _ResumenInventario extends StatelessWidget {
  final int productos;
  final int unidades;
  final double valor;
  final int stockBajo;

  const _ResumenInventario({
    required this.productos,
    required this.unidades,
    required this.valor,
    required this.stockBajo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(22),
        border:
            Border.all(color: CupertinoColors.white.withValues(alpha: 0.15)),
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
                  color: CupertinoColors.white.withValues(alpha: 0.75),
                ),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.chart_bar_alt_fill,
                  size: 18, color: Color(0xFF67E8F9)),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Producto.soles(valor),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Dato(
                  valor: '$productos',
                  etiqueta: 'Productos',
                  icono: CupertinoIcons.cube_box_fill),
              _Dato(
                  valor: '$unidades',
                  etiqueta: 'Unidades',
                  icono: CupertinoIcons.layers_alt_fill),
              _Dato(
                valor: '$stockBajo',
                etiqueta: 'Stock bajo',
                icono: CupertinoIcons.exclamationmark_triangle_fill,
                color: stockBajo > 0 ? const Color(0xFFFCD34D) : null,
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
  final IconData icono;
  final Color? color;
  const _Dato(
      {required this.valor,
      required this.etiqueta,
      required this.icono,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: CupertinoColors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child:
                Icon(icono, size: 15, color: color ?? const Color(0xFF67E8F9)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: color ?? CupertinoColors.white,
                  ),
                ),
                Text(
                  etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: CupertinoColors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Acceso rápido con degradado frío
class _Acceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final LinearGradient degradado;
  final VoidCallback onTap;

  const _Acceso({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.degradado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.75,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: degradado,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: degradado.colors.last.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icono, color: CupertinoColors.white, size: 20),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.arrow_up_right,
                  size: 16,
                  color: CupertinoColors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
            const Spacer(),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.white,
              ),
            ),
            Text(
              subtitulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.white.withValues(alpha: 0.8)),
            ),
          ],
        ),
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
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.7,
      onPressed: onTap,
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
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.label),
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
