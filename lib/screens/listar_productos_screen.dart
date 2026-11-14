// PANTALLA 3: LISTAR PRODUCTOS (pestaña Productos)
// Título grande, buscador, filtros, orden, deslizar para eliminar
// y "jalar para actualizar" al estilo iOS.
import 'package:flutter/cupertino.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/gradient_header.dart';
import '../widgets/producto_tile.dart';
import 'detalle_producto_screen.dart';

/// Formas de ordenar la lista
enum Orden { nombre, precioMayor, precioMenor, stock }

extension on Orden {
  String get texto => switch (this) {
        Orden.nombre => 'Nombre (A-Z)',
        Orden.precioMayor => 'Precio: mayor a menor',
        Orden.precioMenor => 'Precio: menor a mayor',
        Orden.stock => 'Menos stock primero',
      };
}

class ListarProductosScreen extends StatefulWidget {
  const ListarProductosScreen({super.key});

  @override
  State<ListarProductosScreen> createState() => _ListarProductosScreenState();
}

class _ListarProductosScreenState extends State<ListarProductosScreen> {
  final _buscarCtrl = TextEditingController();
  String _busqueda = '';
  String _categoria = 'Todas';
  int _filtroStock = 0; // 0 = todos, 1 = disponibles, 2 = stock bajo
  Orden _orden = Orden.nombre;

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  List<Producto> _filtrar(List<Producto> todos) {
    final q = _busqueda.trim().toLowerCase();
    final lista = todos.where((p) {
      final coincide = q.isEmpty ||
          p.nombre.toLowerCase().contains(q) ||
          p.marca.toLowerCase().contains(q);
      final enCategoria = _categoria == 'Todas' || p.categoria == _categoria;
      final enStock = switch (_filtroStock) {
        1 => p.stock > 8,
        2 => p.stock <= 8,
        _ => true,
      };
      return coincide && enCategoria && enStock;
    }).toList();

    switch (_orden) {
      case Orden.nombre:
        lista.sort(
            (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
      case Orden.precioMayor:
        lista.sort((a, b) => b.precio.compareTo(a.precio));
      case Orden.precioMenor:
        lista.sort((a, b) => a.precio.compareTo(b.precio));
      case Orden.stock:
        lista.sort((a, b) => a.stock.compareTo(b.stock));
    }
    return lista;
  }

  void _abrirDetalle(Producto p) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => DetalleProductoScreen(productoId: p.id),
      ),
    );
  }

  /// Hoja de acciones al tocar los "..." de un producto
  void _opciones(Producto p) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(p.nombre),
        message: Text('${p.marca} · ${p.precioFormateado} · ${p.stock} uds.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _abrirDetalle(p);
            },
            child: const Text('Ver detalle'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              AppRoutes.abrir(context, AppRoutes.registrarProducto,
                  arguments: p);
            },
            child: const Text('Editar'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              DetalleProductoScreen.confirmarEliminar(context, p);
            },
            child: const Text('Eliminar'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  /// Hoja de acciones para elegir el orden
  void _elegirOrden() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Ordenar productos'),
        actions: [
          for (final o in Orden.values)
            CupertinoActionSheetAction(
              isDefaultAction: o == _orden,
              onPressed: () {
                setState(() => _orden = o);
                Navigator.pop(ctx);
              },
              child: Text(o == _orden ? '✓  ${o.texto}' : o.texto),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  /// Texto del filtro: oscuro si está elegido, blanco si no
  Widget _segmento(String texto, int valor) {
    final activo = _filtroStock == valor;
    return Text(
      texto,
      style: TextStyle(
        fontSize: 14,
        fontWeight: activo ? FontWeight.w600 : FontWeight.w500,
        color: activo ? AppColors.navy : CupertinoColors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ['Todas', ...AppData.categorias.keys];

    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<Producto>>(
        valueListenable: AppData.productos,
        builder: (context, todos, _) {
          final lista = _filtrar(todos);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              AppSliverNavBar(
                titulo: 'Productos',
                leading: NavIconButton(
                  CupertinoIcons.arrow_up_arrow_down,
                  size: 22,
                  onPressed: _elegirOrden,
                ),
                trailing: NavIconButton(
                  CupertinoIcons.plus_circle_fill,
                  size: 28,
                  onPressed: () =>
                      AppRoutes.abrir(context, AppRoutes.registrarProducto),
                ),
              ),

              // Jalar hacia abajo para actualizar
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 900));
                  if (context.mounted)
                    AppToast.show(context, 'Inventario actualizado');
                },
              ),

              // Encabezado azul con buscador y filtro de stock
              SliverToBoxAdapter(
                child: GradientHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${todos.length} productos · ${AppData.totalUnidades} unidades',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CupertinoSearchTextField(
                        controller: _buscarCtrl,
                        placeholder: 'Buscar por nombre o marca',
                        backgroundColor:
                            CupertinoColors.white.withValues(alpha: 0.14),
                        style: const TextStyle(color: CupertinoColors.white),
                        placeholderStyle: TextStyle(
                          color: CupertinoColors.white.withValues(alpha: 0.6),
                        ),
                        itemColor:
                            CupertinoColors.white.withValues(alpha: 0.75),
                        onChanged: (v) => setState(() => _busqueda = v),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<int>(
                          groupValue: _filtroStock,
                          backgroundColor:
                              CupertinoColors.white.withValues(alpha: 0.14),
                          thumbColor: CupertinoColors.white,
                          onValueChanged: (v) =>
                              setState(() => _filtroStock = v ?? 0),
                          children: {
                            0: _segmento('Todos', 0),
                            1: _segmento('Disponibles', 1),
                            2: _segmento('Stock bajo', 2),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categorías en "píldoras" horizontales
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    itemCount: categorias.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _Pildora(
                      texto: categorias[i],
                      activa: categorias[i] == _categoria,
                      onTap: () => setState(() => _categoria = categorias[i]),
                    ),
                  ),
                ),
              ),

              if (lista.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ListaVacia(
                    hayFiltros: todos.isNotEmpty,
                    onRegistrar: () =>
                        AppRoutes.abrir(context, AppRoutes.registrarProducto),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    MediaQuery.of(context).padding.bottom + 24,
                  ),
                  sliver: SliverList.separated(
                    itemCount: lista.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final p = lista[i];
                      // Deslizar hacia la izquierda para eliminar
                      return Dismissible(
                        key: ValueKey(p.id),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) =>
                            DetalleProductoScreen.preguntarEliminar(context, p),
                        onDismissed: (_) =>
                            DetalleProductoScreen.eliminar(context, p),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.trash,
                                  color: CupertinoColors.white),
                              SizedBox(height: 2),
                              Text(
                                'Eliminar',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: ProductoTile(
                          producto: p,
                          onTap: () => _abrirDetalle(p),
                          onMas: () => _opciones(p),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Pildora extends StatelessWidget {
  final String texto;
  final bool activa;
  final VoidCallback onTap;

  const _Pildora(
      {required this.texto, required this.activa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: activa ? AppColors.brandGradient : null,
          color: activa ? null : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: activa ? const Color(0x00000000) : AppColors.separator),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: activa ? CupertinoColors.white : AppColors.label,
          ),
        ),
      ),
    );
  }
}

class _ListaVacia extends StatelessWidget {
  final bool hayFiltros;
  final VoidCallback onRegistrar;

  const _ListaVacia({required this.hayFiltros, required this.onRegistrar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hayFiltros ? CupertinoIcons.search : CupertinoIcons.tray_fill,
            size: 52,
            color: AppColors.tertiaryLabel,
          ),
          const SizedBox(height: 14),
          Text(
            hayFiltros ? 'Sin resultados' : 'Aún no hay productos',
            style: AppText.headline,
          ),
          const SizedBox(height: 6),
          Text(
            hayFiltros
                ? 'Prueba con otra búsqueda o cambia los filtros.'
                : 'Registra tu primer producto para empezar.',
            textAlign: TextAlign.center,
            style: AppText.subhead,
          ),
          if (!hayFiltros) ...[
            const SizedBox(height: 18),
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(14),
              onPressed: onRegistrar,
              child: const Text('Registrar producto'),
            ),
          ],
        ],
      ),
    );
  }
}
