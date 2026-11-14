// PANTALLA 4: REGISTRAR / EDITAR PRODUCTO
// Formulario modal de iOS: foto, datos agrupados, selector de categoría
// con CupertinoPicker, stock con botones +/- y vista previa en vivo.
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/producto_imagen.dart';
import '../widgets/producto_tile.dart';
import '../widgets/section_header.dart';

class RegistrarProductoScreen extends StatefulWidget {
  /// Si llega un producto, la pantalla se abre en modo edición
  final Producto? productoEditar;

  const RegistrarProductoScreen({super.key, this.productoEditar});

  @override
  State<RegistrarProductoScreen> createState() => _RegistrarProductoScreenState();
}

class _RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _marcaCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _stockCtrl;
  late String _categoria;
  String? _imagenUrl;
  bool _modificado = false;

  bool get _editando => widget.productoEditar != null;

  @override
  void initState() {
    super.initState();
    final p = widget.productoEditar;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _marcaCtrl = TextEditingController(text: p?.marca ?? '');
    _descCtrl = TextEditingController(text: p?.descripcion ?? '');
    _precioCtrl = TextEditingController(text: p == null ? '' : p.precio.toStringAsFixed(2));
    _stockCtrl = TextEditingController(text: p == null ? '1' : '${p.stock}');
    _categoria = p?.categoria ?? 'Laptops';
    _imagenUrl = p?.imagenUrl;

    for (final c in [_nombreCtrl, _marcaCtrl, _descCtrl, _precioCtrl, _stockCtrl]) {
      c.addListener(_marcarModificado);
    }
  }

  void _marcarModificado() => _modificado = true;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _marcaCtrl.dispose();
    _descCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  int get _stock => int.tryParse(_stockCtrl.text) ?? 0;

  void _cambiarStock(int delta) {
    final nuevo = (_stock + delta).clamp(0, 9999);
    _stockCtrl.text = '$nuevo';
    HapticFeedback.selectionClick();
  }

  /// Producto armado con lo que hay en el formulario
  Producto _productoActual() {
    return Producto(
      id: widget.productoEditar?.id ?? AppData.nuevoId(),
      nombre: _nombreCtrl.text.trim().isEmpty ? 'Nombre del producto' : _nombreCtrl.text.trim(),
      marca: _marcaCtrl.text.trim(),
      descripcion: _descCtrl.text.trim(),
      precio: double.tryParse(_precioCtrl.text) ?? 0,
      stock: _stock,
      categoria: _categoria,
      imagenUrl: _imagenUrl,
      icono: AppData.iconoDe(_categoria),
    );
  }

  void _guardar() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      return;
    }

    final producto = _productoActual();
    if (_editando) {
      AppData.actualizarProducto(producto);
    } else {
      AppData.agregarProducto(producto);
    }

    HapticFeedback.lightImpact();
    AppToast.show(
      context,
      _editando ? 'Cambios guardados' : '"${producto.nombre}" registrado',
    );
    Navigator.pop(context);
  }

  /// Si hay cambios sin guardar, pregunta antes de salir
  void _cancelar() {
    if (!_modificado) {
      Navigator.pop(context);
      return;
    }
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        message: const Text('Tienes cambios sin guardar.'),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Descartar cambios'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Seguir editando'),
        ),
      ),
    );
  }

  // ---------- Foto ----------

  void _opcionesFoto() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Foto del producto'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _elegirDeGaleria();
            },
            child: const Text('Elegir de la galería'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _pegarUrl();
            },
            child: const Text('Pegar URL de imagen'),
          ),
          if (_imagenUrl != null && _imagenUrl!.isNotEmpty)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _imagenUrl = null;
                  _modificado = true;
                });
              },
              child: const Text('Quitar foto'),
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

  Future<void> _elegirDeGaleria() async {
    final foto = await showCupertinoModalPopup<ImagenCatalogo>(
      context: context,
      builder: (_) => _GaleriaSheet(categoriaActual: _categoria),
    );
    if (foto == null) return;
    setState(() {
      _imagenUrl = foto.url;
      _categoria = foto.categoria;
      _modificado = true;
    });
  }

  Future<void> _pegarUrl() async {
    final ctrl = TextEditingController(text: _imagenUrl ?? '');
    final url = await showCupertinoDialog<String>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('URL de la imagen'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: ctrl,
            placeholder: 'https://...',
            keyboardType: TextInputType.url,
            autocorrect: false,
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Usar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (url == null || url.isEmpty) return;
    setState(() {
      _imagenUrl = url;
      _modificado = true;
    });
  }

  // ---------- Categoría ----------

  void _elegirCategoria() {
    final categorias = AppData.categorias.keys.toList();
    var indice = categorias.indexOf(_categoria);
    if (indice < 0) indice = 0;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancelar'),
                  ),
                  const Spacer(),
                  const Text('Categoría', style: AppText.headline),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _categoria = categorias[indice];
                        _modificado = true;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Listo', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              Container(height: 0.5, color: AppColors.separator),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(initialItem: indice),
                  onSelectedItemChanged: (i) => indice = i,
                  children: [
                    for (final c in categorias)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(AppData.iconoDe(c), size: 20, color: AppColors.categoria(c)),
                          const SizedBox(width: 10),
                          Text(c),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Vista ----------

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _cancelar,
          child: const Text('Cancelar'),
        ),
        middle: Text(_editando ? 'Editar producto' : 'Nuevo producto'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _guardar,
          child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                _selectorFoto(),

                CupertinoFormSection.insetGrouped(
                  header: const SectionHeader('Información'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _nombreCtrl,
                      prefix: const _Etiqueta('Nombre'),
                      placeholder: 'Ej. MacBook Air 13"',
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
                        if (v.trim().length < 3) return 'Mínimo 3 caracteres';
                        return null;
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _marcaCtrl,
                      prefix: const _Etiqueta('Marca'),
                      placeholder: 'Apple, Samsung, Lenovo...',
                      textInputAction: TextInputAction.next,
                    ),
                    CupertinoFormRow(
                      prefix: const _Etiqueta('Categoría'),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _elegirCategoria,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              AppData.iconoDe(_categoria),
                              size: 18,
                              color: AppColors.categoria(_categoria),
                            ),
                            const SizedBox(width: 6),
                            Text(_categoria, style: const TextStyle(color: AppColors.label)),
                            const SizedBox(width: 4),
                            const Icon(
                              CupertinoIcons.chevron_up_chevron_down,
                              size: 14,
                              color: AppColors.tertiaryLabel,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _descCtrl,
                      prefix: const _Etiqueta('Descripción'),
                      placeholder: 'Características principales',
                      minLines: 1,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),

                CupertinoFormSection.insetGrouped(
                  header: const SectionHeader('Precio y stock'),
                  footer: const Text('El precio se registra en soles (S/).'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _precioCtrl,
                      prefix: const _Etiqueta('Precio'),
                      placeholder: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      validator: (v) {
                        final precio = double.tryParse(v ?? '');
                        if (precio == null) return 'Ingresa un precio válido';
                        if (precio <= 0) return 'El precio debe ser mayor a 0';
                        return null;
                      },
                    ),
                    CupertinoFormRow(
                      prefix: const _Etiqueta('Stock'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _BotonPaso(icon: CupertinoIcons.minus, onTap: () => _cambiarStock(-1)),
                          SizedBox(
                            width: 64,
                            child: CupertinoTextField.borderless(
                              controller: _stockCtrl,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              style: AppText.headline,
                            ),
                          ),
                          _BotonPaso(icon: CupertinoIcons.plus, onTap: () => _cambiarStock(1)),
                        ],
                      ),
                    ),
                  ],
                ),

                // Vista previa: se actualiza mientras escribes
                CupertinoListSection.insetGrouped(
                  header: const SectionHeader('Vista previa'),
                  backgroundColor: AppColors.background,
                  decoration: const BoxDecoration(),
                  children: [
                    ListenableBuilder(
                      listenable: Listenable.merge(
                        [_nombreCtrl, _marcaCtrl, _precioCtrl, _stockCtrl],
                      ),
                      builder: (_, __) => ProductoTile(
                        producto: _productoActual(),
                        onTap: () {},
                        onMas: () {},
                        conHero: false,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(14),
                      onPressed: _guardar,
                      child: Text(
                        _editando ? 'Guardar cambios' : 'Registrar producto',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectorFoto() {
    final tieneFoto = _imagenUrl != null && _imagenUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: _opcionesFoto,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppColors.softShadow,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: tieneFoto
                      ? ProductoImagen(
                          url: _imagenUrl,
                          iconoRespaldo: AppData.iconoDe(_categoria),
                          categoria: _categoria,
                          size: 140,
                          radius: 20,
                        )
                      : Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            CupertinoIcons.camera_fill,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                ),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 3),
                    ),
                    child: Icon(
                      tieneFoto ? CupertinoIcons.pencil : CupertinoIcons.plus,
                      size: 18,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _opcionesFoto,
            child: Text(
              tieneFoto ? 'Cambiar foto' : 'Agregar foto',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// Texto de la izquierda en cada fila del formulario (ancho fijo para alinear)
class _Etiqueta extends StatelessWidget {
  final String texto;
  const _Etiqueta(this.texto);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Text(texto, style: const TextStyle(fontSize: 16, color: AppColors.label)),
    );
  }
}

/// Botón redondo de - / + para el stock
class _BotonPaso extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BotonPaso({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.fill,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

/// Hoja con las fotos del catálogo para elegir
class _GaleriaSheet extends StatefulWidget {
  final String categoriaActual;
  const _GaleriaSheet({required this.categoriaActual});

  @override
  State<_GaleriaSheet> createState() => _GaleriaSheetState();
}

class _GaleriaSheetState extends State<_GaleriaSheet> {
  late String _filtro;

  @override
  void initState() {
    super.initState();
    final hayFotos = AppData.galeria.any((f) => f.categoria == widget.categoriaActual);
    _filtro = hayFotos ? widget.categoriaActual : 'Todas';
  }

  @override
  Widget build(BuildContext context) {
    final cats = ['Todas', ...{for (final f in AppData.galeria) f.categoria}];
    final fotos = AppData.galeria
        .where((f) => _filtro == 'Todas' || f.categoria == _filtro)
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.tertiaryLabel,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
              child: Row(
                children: [
                  const Text('Galería', style: AppText.title),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final activa = cats[i] == _filtro;
                  return GestureDetector(
                    onTap: () => setState(() => _filtro = cats[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: activa ? AppColors.label : AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        cats[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: activa ? CupertinoColors.white : AppColors.label,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: fotos.length,
                itemBuilder: (_, i) {
                  final foto = fotos[i];
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, foto),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (_, c) => ProductoImagen(
                                url: foto.url,
                                iconoRespaldo: AppData.iconoDe(foto.categoria),
                                categoria: foto.categoria,
                                size: c.maxWidth < c.maxHeight ? c.maxWidth : c.maxHeight,
                                radius: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            foto.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
