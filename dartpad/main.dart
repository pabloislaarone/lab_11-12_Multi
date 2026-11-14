// TechStore (Lab S11-12, widgets Cupertino): versión en un solo archivo para DartPad.
// Pega todo en https://dartpad.dev y presiona Run.
// Usuario de prueba: admin@techstore.com / 123456
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// ===== lib/main.dart =====
// TechStore App · Laboratorio S11-12 (versión con widgets Cupertino)
// Punto de entrada de la aplicación.


void main() {
  runApp(const TechStoreApp());
}

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'TechStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

// ===== lib/theme/app_theme.dart =====
// Colores, estilos de texto y tema Cupertino de toda la app.
// Se usa la paleta del sistema de iOS para que la app se sienta nativa.

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
    letterSpacing: -0.2,
    color: AppColors.label,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.label,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.label,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.label,
  );

  static const TextStyle subhead = TextStyle(
    fontSize: 14,
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
    letterSpacing: -0.1,
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

// ===== lib/routes/app_routes.dart =====
// Rutas de la aplicación (navegación centralizada con CupertinoPageRoute)


class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String home = '/home';
  static const String registrarProducto = '/productos/registrar';
  static const String editarPerfil = '/perfil/editar';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return CupertinoPageRoute(settings: settings, builder: (_) => const LoginScreen());
      case home:
        return CupertinoPageRoute(settings: settings, builder: (_) => const HomeScreen());
      case registrarProducto:
        // La misma pantalla registra o edita: si llega un Producto, edita.
        // fullscreenDialog: se abre desde abajo como un formulario modal de iOS.
        final producto = settings.arguments as Producto?;
        return CupertinoPageRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => RegistrarProductoScreen(productoEditar: producto),
        );
      case editarPerfil:
        return CupertinoPageRoute(
          settings: settings,
          fullscreenDialog: true,
          builder: (_) => const EditarPerfilScreen(),
        );
      default:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const CupertinoPageScaffold(
            child: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }

  /// Abre una ruta en el navegador principal (por encima de las pestañas)
  static Future<T?> abrir<T>(BuildContext context, String ruta, {Object? arguments}) {
    return Navigator.of(context, rootNavigator: true).pushNamed<T>(ruta, arguments: arguments);
  }

  /// Pide confirmación y vuelve al login borrando el historial
  static Future<void> cerrarSesion(BuildContext context) async {
    final salir = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('¿Seguro que deseas salir de TechStore?'),
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
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (salir == true && context.mounted) {
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil(login, (route) => false);
    }
  }
}

// ===== lib/models/producto.dart =====
// Modelo: Producto

class Producto {
  final String id;
  final String nombre;
  final String marca;
  final String descripcion;
  final double precio;
  final int stock;
  final String categoria;

  /// URL de la foto del producto (puede ser null si no tiene foto)
  final String? imagenUrl;

  /// Ícono de respaldo: se muestra si no hay foto o si no carga
  final IconData icono;

  const Producto({
    required this.id,
    required this.nombre,
    this.marca = '',
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    this.imagenUrl,
    required this.icono,
  });

  // copyWith crea una copia cambiando solo algunos campos (para EDITAR).
  Producto copyWith({
    String? nombre,
    String? marca,
    String? descripcion,
    double? precio,
    int? stock,
    String? categoria,
    String? imagenUrl,
    IconData? icono,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      icono: icono ?? this.icono,
    );
  }

  /// Precio con formato peruano: "S/ 3,500.00"
  String get precioFormateado => soles(precio);

  /// Da formato de soles a cualquier monto (con comas de miles)
  static String soles(double monto) {
    final partes = monto.toStringAsFixed(2).split('.');
    final entero = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return 'S/ $entero.${partes[1]}';
  }
}

// ===== lib/models/usuario.dart =====
// Modelo: Usuario
class Usuario {
  final String nombre;
  final String email;
  final String telefono;
  final String rol;

  const Usuario({
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.rol,
  });

  /// Iniciales para el avatar (ej. "Juan Pérez" -> "JP")
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  Usuario copyWith({String? nombre, String? email, String? telefono, String? rol}) {
    return Usuario(
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
    );
  }
}

// ===== lib/data/app_data.dart =====
// Datos de la app (en memoria, sin base de datos)
// Productos reales con fotos del catálogo público DummyJSON
// (https://dummyjson.com). Precios referenciales en soles.


/// Imagen del catálogo que se puede elegir al registrar un producto
class ImagenCatalogo {
  final String nombre;
  final String categoria;
  final String url;
  const ImagenCatalogo(this.nombre, this.categoria, this.url);
}

/// Estado compartido de la app con ValueNotifier: cuando cambia `.value`,
/// todas las pantallas que lo escuchan se redibujan solas.
class AppData {
  AppData._(); // constructor privado: no se crean instancias

  // Credenciales de prueba para el login
  static const String demoEmail = 'admin@techstore.com';
  static const String demoPassword = '123456';

  // Base de las URLs de las fotos
  static const String _cdn = 'https://cdn.dummyjson.com/product-images';

  /// Usuario que inició sesión
  static final ValueNotifier<Usuario> usuario = ValueNotifier(
    const Usuario(
      nombre: 'Juan Pérez',
      email: 'juan.perez@correo.com',
      telefono: '987654321',
      rol: 'Administrador',
    ),
  );

  /// Categorías con su ícono de respaldo
  static const Map<String, IconData> categorias = {
    'Laptops': CupertinoIcons.device_laptop,
    'Celulares': CupertinoIcons.device_phone_portrait,
    'Tablets': CupertinoIcons.rectangle,
    'Audio': CupertinoIcons.headphones,
    'Wearables': CupertinoIcons.clock,
    'Accesorios': CupertinoIcons.bolt,
    'Otro': CupertinoIcons.cube_box,
  };

  static IconData iconoDe(String categoria) =>
      categorias[categoria] ?? CupertinoIcons.cube_box;

  /// Lista de productos inicial
  static final ValueNotifier<List<Producto>> productos = ValueNotifier([
    const Producto(
      id: '1',
      nombre: 'MacBook Pro 14"',
      marca: 'Apple',
      categoria: 'Laptops',
      descripcion: 'Chip M1 Pro, pantalla Liquid Retina XDR de 14", 16 GB RAM y 512 GB SSD. Color gris espacial.',
      precio: 7499,
      stock: 24,
      imagenUrl: '$_cdn/laptops/apple-macbook-pro-14-inch-space-grey/thumbnail.webp',
      icono: CupertinoIcons.device_laptop,
    ),
    const Producto(
      id: '2',
      nombre: 'XPS 13 9300',
      marca: 'Dell',
      categoria: 'Laptops',
      descripcion: 'Ultrabook de 13.4" con bordes mínimos, Intel Core i7 y 16 GB RAM. Ideal para llevar a clases.',
      precio: 5599,
      stock: 9,
      imagenUrl: '$_cdn/laptops/new-dell-xps-13-9300-laptop/thumbnail.webp',
      icono: CupertinoIcons.device_laptop,
    ),
    const Producto(
      id: '3',
      nombre: 'Yoga 920',
      marca: 'Lenovo',
      categoria: 'Laptops',
      descripcion: 'Convertible 2 en 1 con bisagra de 360°: úsala como laptop o como tablet táctil.',
      precio: 4099,
      stock: 40,
      imagenUrl: '$_cdn/laptops/lenovo-yoga-920/thumbnail.webp',
      icono: CupertinoIcons.device_laptop,
    ),
    const Producto(
      id: '4',
      nombre: 'Zenbook Pro Duo',
      marca: 'Asus',
      categoria: 'Laptops',
      descripcion: 'Laptop de doble pantalla para diseño, edición de video y multitarea intensa.',
      precio: 6699,
      stock: 6,
      imagenUrl: '$_cdn/laptops/asus-zenbook-pro-dual-screen-laptop/thumbnail.webp',
      icono: CupertinoIcons.device_laptop,
    ),
    const Producto(
      id: '5',
      nombre: 'iPhone 13 Pro',
      marca: 'Apple',
      categoria: 'Celulares',
      descripcion: 'Triple cámara de 12 MP, chip A15 Bionic y pantalla ProMotion de 120 Hz.',
      precio: 4099,
      stock: 18,
      imagenUrl: '$_cdn/smartphones/iphone-13-pro/thumbnail.webp',
      icono: CupertinoIcons.device_phone_portrait,
    ),
    const Producto(
      id: '6',
      nombre: 'Galaxy S10',
      marca: 'Samsung',
      categoria: 'Celulares',
      descripcion: 'Pantalla Dynamic AMOLED de 6.1", triple cámara y lector de huella en pantalla.',
      precio: 2599,
      stock: 19,
      imagenUrl: '$_cdn/smartphones/samsung-galaxy-s10/thumbnail.webp',
      icono: CupertinoIcons.device_phone_portrait,
    ),
    const Producto(
      id: '7',
      nombre: 'iPad Mini 2021',
      marca: 'Apple',
      categoria: 'Tablets',
      descripcion: 'Tablet compacta de 8.3" con chip A15, compatible con Apple Pencil. Color blanco estelar.',
      precio: 1899,
      stock: 47,
      imagenUrl: '$_cdn/tablets/ipad-mini-2021-starlight/thumbnail.webp',
      icono: CupertinoIcons.rectangle,
    ),
    const Producto(
      id: '8',
      nombre: 'Galaxy Tab S8+',
      marca: 'Samsung',
      categoria: 'Tablets',
      descripcion: 'Pantalla Super AMOLED de 12.4" con S Pen incluido, ideal para tomar apuntes.',
      precio: 2249,
      stock: 12,
      imagenUrl: '$_cdn/tablets/samsung-galaxy-tab-s8-plus-grey/thumbnail.webp',
      icono: CupertinoIcons.rectangle,
    ),
    const Producto(
      id: '9',
      nombre: 'AirPods',
      marca: 'Apple',
      categoria: 'Audio',
      descripcion: 'Audífonos inalámbricos con emparejamiento instantáneo y estuche de carga.',
      precio: 489,
      stock: 35,
      imagenUrl: '$_cdn/mobile-accessories/apple-airpods/thumbnail.webp',
      icono: CupertinoIcons.headphones,
    ),
    const Producto(
      id: '10',
      nombre: 'AirPods Max',
      marca: 'Apple',
      categoria: 'Audio',
      descripcion: 'Audífonos over-ear con cancelación activa de ruido y audio espacial.',
      precio: 2059,
      stock: 4,
      imagenUrl: '$_cdn/mobile-accessories/apple-airpods-max-silver/thumbnail.webp',
      icono: CupertinoIcons.headphones,
    ),
    const Producto(
      id: '11',
      nombre: 'Beats Flex',
      marca: 'Beats',
      categoria: 'Audio',
      descripcion: 'Audífonos inalámbricos con auriculares magnéticos y hasta 12 horas de batería.',
      precio: 189,
      stock: 50,
      imagenUrl: '$_cdn/mobile-accessories/beats-flex-wireless-earphones/thumbnail.webp',
      icono: CupertinoIcons.headphones,
    ),
    const Producto(
      id: '12',
      nombre: 'Apple Watch Series 4',
      marca: 'Apple',
      categoria: 'Wearables',
      descripcion: 'Smartwatch dorado con monitor de ritmo cardiaco, GPS y seguimiento de actividad.',
      precio: 1299,
      stock: 8,
      imagenUrl: '$_cdn/mobile-accessories/apple-watch-series-4-gold/thumbnail.webp',
      icono: CupertinoIcons.clock,
    ),
  ]);

  /// Galería de fotos para elegir al REGISTRAR un producto nuevo
  static const List<ImagenCatalogo> galeria = [
    ImagenCatalogo('MacBook Pro', 'Laptops', '$_cdn/laptops/apple-macbook-pro-14-inch-space-grey/thumbnail.webp'),
    ImagenCatalogo('Matebook X Pro', 'Laptops', '$_cdn/laptops/huawei-matebook-x-pro/thumbnail.webp'),
    ImagenCatalogo('Dell XPS 13', 'Laptops', '$_cdn/laptops/new-dell-xps-13-9300-laptop/thumbnail.webp'),
    ImagenCatalogo('Lenovo Yoga', 'Laptops', '$_cdn/laptops/lenovo-yoga-920/thumbnail.webp'),
    ImagenCatalogo('iPhone 13 Pro', 'Celulares', '$_cdn/smartphones/iphone-13-pro/thumbnail.webp'),
    ImagenCatalogo('iPhone X', 'Celulares', '$_cdn/smartphones/iphone-x/thumbnail.webp'),
    ImagenCatalogo('Galaxy S10', 'Celulares', '$_cdn/smartphones/samsung-galaxy-s10/thumbnail.webp'),
    ImagenCatalogo('Oppo F19 Pro+', 'Celulares', '$_cdn/smartphones/oppo-f19-pro-plus/thumbnail.webp'),
    ImagenCatalogo('iPad Mini', 'Tablets', '$_cdn/tablets/ipad-mini-2021-starlight/thumbnail.webp'),
    ImagenCatalogo('Galaxy Tab', 'Tablets', '$_cdn/tablets/samsung-galaxy-tab-white/thumbnail.webp'),
    ImagenCatalogo('AirPods', 'Audio', '$_cdn/mobile-accessories/apple-airpods/thumbnail.webp'),
    ImagenCatalogo('AirPods Max', 'Audio', '$_cdn/mobile-accessories/apple-airpods-max-silver/thumbnail.webp'),
    ImagenCatalogo('HomePod Mini', 'Audio', '$_cdn/mobile-accessories/apple-homepod-mini-cosmic-grey/thumbnail.webp'),
    ImagenCatalogo('Echo Plus', 'Audio', '$_cdn/mobile-accessories/amazon-echo-plus/thumbnail.webp'),
    ImagenCatalogo('Apple Watch', 'Wearables', '$_cdn/mobile-accessories/apple-watch-series-4-gold/thumbnail.webp'),
    ImagenCatalogo('MagSafe Battery', 'Accesorios', '$_cdn/mobile-accessories/apple-magsafe-battery-pack/thumbnail.webp'),
    ImagenCatalogo('Cargador iPhone', 'Accesorios', '$_cdn/mobile-accessories/apple-iphone-charger/thumbnail.webp'),
    ImagenCatalogo('Funda MagSafe', 'Accesorios', '$_cdn/mobile-accessories/iphone-12-silicone-case-with-magsafe-plum/thumbnail.webp'),
  ];

  // Operaciones CRUD

  /// Total de unidades en stock
  static int get totalUnidades =>
      productos.value.fold<int>(0, (suma, p) => suma + p.stock);

  /// Valor total del inventario (precio x stock)
  static double get valorInventario =>
      productos.value.fold<double>(0.0, (suma, p) => suma + p.precio * p.stock);

  static void agregarProducto(Producto p) {
    // Se crea una lista NUEVA para que el ValueNotifier detecte el cambio
    productos.value = [...productos.value, p];
  }

  static void actualizarProducto(Producto p) {
    productos.value = [
      for (final item in productos.value) item.id == p.id ? p : item,
    ];
  }

  static void eliminarProducto(String id) {
    productos.value = productos.value.where((p) => p.id != id).toList();
  }

  /// Productos con 8 unidades o menos
  static List<Producto> get stockBajo =>
      productos.value.where((p) => p.stock <= 8).toList()
        ..sort((a, b) => a.stock.compareTo(b.stock));

  static String nuevoId() => DateTime.now().millisecondsSinceEpoch.toString();
}

// ===== lib/widgets/app_toast.dart =====
// Aviso flotante que aparece arriba y se oculta solo (como los avisos de iOS).
// Cupertino no trae SnackBar, así que se arma con un OverlayEntry.


class AppToast {
  AppToast._();

  static OverlayEntry? _actual;

  static void show(
    BuildContext context,
    String mensaje, {
    IconData icono = CupertinoIcons.checkmark_circle_fill,
    Color color = AppColors.success,
  }) {
    _actual?.remove();
    _actual = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _Toast(
        mensaje: mensaje,
        icono: icono,
        color: color,
        onFin: () {
          if (_actual == entry) _actual = null;
          if (entry.mounted) entry.remove();
        },
      ),
    );
    _actual = entry;
    overlay.insert(entry);
  }
}

class _Toast extends StatefulWidget {
  final String mensaje;
  final IconData icono;
  final Color color;
  final VoidCallback onFin;

  const _Toast({
    required this.mensaje,
    required this.icono,
    required this.color,
    required this.onFin,
  });

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Aparece, espera y se oculta
    Future.delayed(const Duration(milliseconds: 20), () {
      if (mounted) setState(() => _visible = true);
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _visible = false);
    });
    Future.delayed(const Duration(milliseconds: 2600), widget.onFin);
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 10;

    return Positioned(
      top: top,
      left: 20,
      right: 20,
      child: IgnorePointer(
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, -0.6),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.label.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icono, color: widget.color, size: 20),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.mensaje,
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===== lib/widgets/icon_box.dart =====
// Ícono blanco dentro de un cuadrado de color, como en Ajustes de iOS.

class IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const IconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(icon, color: CupertinoColors.white, size: size * 0.6),
    );
  }
}

// ===== lib/widgets/password_row.dart =====
// Fila de formulario para contraseñas con botón para mostrar u ocultar.
// Se arma con FormField + CupertinoFormRow para poder validar con el Form.


class PasswordRow extends StatefulWidget {
  final TextEditingController controller;
  final Widget prefix;
  final String placeholder;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  const PasswordRow({
    super.key,
    required this.controller,
    required this.prefix,
    this.placeholder = 'Contraseña',
    this.validator,
    this.onSubmitted,
  });

  @override
  State<PasswordRow> createState() => _PasswordRowState();
}

class _PasswordRowState extends State<PasswordRow> {
  bool _oculta = true;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => widget.validator?.call(widget.controller.text),
      builder: (state) => CupertinoFormRow(
        prefix: widget.prefix,
        error: state.hasError ? Text(state.errorText!) : null,
        child: CupertinoTextField.borderless(
          controller: widget.controller,
          placeholder: widget.placeholder,
          obscureText: _oculta,
          textInputAction: TextInputAction.done,
          onChanged: state.didChange,
          onSubmitted: widget.onSubmitted,
          suffix: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            onPressed: () => setState(() => _oculta = !_oculta),
            child: Icon(
              _oculta ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
              size: 20,
              color: AppColors.tertiaryLabel,
            ),
          ),
        ),
      ),
    );
  }
}

// ===== lib/widgets/producto_imagen.dart =====
// Foto del producto desde internet.
// Mientras carga muestra un CupertinoActivityIndicator y, si no hay foto
// o falla la descarga, muestra el ícono de la categoría.


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
                // Si la foto no carga, se muestra solo el ícono de la categoría
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(iconoRespaldo, size: size * 0.42, color: color),
                ),
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

// ===== lib/widgets/producto_tile.dart =====
// Fila de un producto en la lista: foto, marca, nombre, precio y stock.


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

// ===== lib/widgets/section_header.dart =====
// Título de una sección agrupada (CupertinoListSection / CupertinoFormSection)


class SectionHeader extends StatelessWidget {
  final String texto;
  const SectionHeader(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(texto, style: AppText.section),
    );
  }
}

// ===== lib/screens/detalle_producto_screen.dart =====
// Detalle de un producto (se abre al tocarlo en la lista o en el Inicio)


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

// ===== lib/screens/editar_perfil_screen.dart =====
// Editar perfil: formulario modal con CupertinoFormSection.
// Al guardar se actualiza el usuario en todas las pantallas.


class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _telefonoCtrl;
  late String _rol;

  static const _roles = ['Administrador', 'Vendedor', 'Almacenero'];

  @override
  void initState() {
    super.initState();
    final u = AppData.usuario.value;
    _nombreCtrl = TextEditingController(text: u.nombre);
    _emailCtrl = TextEditingController(text: u.email);
    _telefonoCtrl = TextEditingController(text: u.telefono);
    _rol = _roles.contains(u.rol) ? u.rol : _roles.first;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    AppData.usuario.value = AppData.usuario.value.copyWith(
      nombre: _nombreCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
      rol: _rol,
    );
    AppToast.show(context, 'Perfil actualizado');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        middle: const Text('Editar perfil'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _guardar,
          child: const Text('Listo', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CupertinoFormSection.insetGrouped(
                header: const SectionHeader('Datos personales'),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _nombreCtrl,
                    prefix: const _EtiquetaPerfil('Nombre'),
                    placeholder: 'Nombre y apellido',
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().length < 3) ? 'Ingresa tu nombre completo' : null,
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _emailCtrl,
                    prefix: const _EtiquetaPerfil('Email'),
                    placeholder: 'correo@ejemplo.com',
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (v) {
                      final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.]+$');
                      return regex.hasMatch(v?.trim() ?? '') ? null : 'El email no es válido';
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _telefonoCtrl,
                    prefix: const _EtiquetaPerfil('Teléfono'),
                    placeholder: '9 dígitos',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    validator: (v) => (v == null || v.length != 9) ? 'Debe tener 9 dígitos' : null,
                  ),
                ],
              ),
              CupertinoFormSection.insetGrouped(
                header: const SectionHeader('Rol'),
                footer: const Text('El rol define qué acciones puede realizar en el inventario.'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoSlidingSegmentedControl<String>(
                        groupValue: _rol,
                        onValueChanged: (v) => setState(() => _rol = v ?? _rol),
                        children: {for (final r in _roles) r: Text(r)},
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EtiquetaPerfil extends StatelessWidget {
  final String texto;
  const _EtiquetaPerfil(this.texto);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Text(texto, style: const TextStyle(fontSize: 16, color: AppColors.label)),
    );
  }
}

// ===== lib/screens/home_screen.dart =====
// Contenedor principal después del login: barra de pestañas de iOS
// con Inicio (menú), Productos (listar) y Perfil.


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Permite cambiar de pestaña desde el código (por ejemplo, desde el Menú)
  final _tabs = CupertinoTabController();

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _irA(int indice) => _tabs.index = indice;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabs,
      tabBar: CupertinoTabBar(
        activeColor: AppColors.primary,
        iconSize: 26,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cube_box),
            activeIcon: Icon(CupertinoIcons.cube_box_fill),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_crop_circle),
            activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),
            label: 'Perfil',
          ),
        ],
      ),
      // Cada pestaña tiene su propio historial de navegación (CupertinoTabView)
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              defaultTitle: 'Inicio',
              builder: (_) => MenuScreen(
                onVerProductos: () => _irA(1),
                onVerPerfil: () => _irA(2),
              ),
            );
          case 1:
            return CupertinoTabView(
              defaultTitle: 'Productos',
              builder: (_) => const ListarProductosScreen(),
            );
          default:
            return CupertinoTabView(
              defaultTitle: 'Perfil',
              builder: (_) => const PerfilScreen(),
            );
        }
      },
    );
  }
}

// ===== lib/screens/listar_productos_screen.dart =====
// PANTALLA 3: LISTAR PRODUCTOS (pestaña Productos)
// Título grande, buscador, filtros, orden, deslizar para eliminar
// y "jalar para actualizar" al estilo iOS.


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
        lista.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
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
              AppRoutes.abrir(context, AppRoutes.registrarProducto, arguments: p);
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

  @override
  Widget build(BuildContext context) {
    final categorias = ['Todas', ...AppData.categorias.keys];

    return CupertinoPageScaffold(
      child: ValueListenableBuilder<List<Producto>>(
        valueListenable: AppData.productos,
        builder: (context, todos, _) {
          final lista = _filtrar(todos);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Productos'),
                middle: const Text('Productos'),
                alwaysShowMiddle: false,
                backgroundColor: AppColors.background.withValues(alpha: 0.9),
                border: null,
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _elegirOrden,
                  child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 22),
                ),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => AppRoutes.abrir(context, AppRoutes.registrarProducto),
                  child: const Icon(CupertinoIcons.plus_circle_fill, size: 28),
                ),
              ),

              // Jalar hacia abajo para actualizar
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 900));
                  if (context.mounted) AppToast.show(context, 'Inventario actualizado');
                },
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 10),
                        child: Text(
                          '${todos.length} productos · ${AppData.totalUnidades} unidades',
                          style: AppText.subhead,
                        ),
                      ),
                      CupertinoSearchTextField(
                        controller: _buscarCtrl,
                        placeholder: 'Buscar por nombre o marca',
                        onChanged: (v) => setState(() => _busqueda = v),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<int>(
                          groupValue: _filtroStock,
                          onValueChanged: (v) => setState(() => _filtroStock = v ?? 0),
                          children: const {
                            0: Text('Todos'),
                            1: Text('Disponibles'),
                            2: Text('Stock bajo'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    onRegistrar: () => AppRoutes.abrir(context, AppRoutes.registrarProducto),
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
                        confirmDismiss: (_) => DetalleProductoScreen.preguntarEliminar(context, p),
                        onDismissed: (_) => DetalleProductoScreen.eliminar(context, p),
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
                              Icon(CupertinoIcons.trash, color: CupertinoColors.white),
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

  const _Pildora({required this.texto, required this.activa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activa ? AppColors.label : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activa ? AppColors.label : AppColors.separator),
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

// ===== lib/screens/login_screen.dart =====
// PANTALLA 1: LOGIN
// Formulario agrupado estilo iOS que valida email y contraseña.


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _cargando = false;
  bool _recordarme = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    await Future.delayed(const Duration(milliseconds: 900)); // simula el servidor
    if (!mounted) return;
    setState(() => _cargando = false);

    final ok = _emailCtrl.text.trim() == AppData.demoEmail &&
        _passCtrl.text == AppData.demoPassword;

    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    HapticFeedback.mediumImpact();
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('No se pudo iniciar sesión'),
        content: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('El email o la contraseña no son correctos. Inténtalo otra vez.'),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  /// Hoja de acciones de iOS con la ayuda para la contraseña
  void _olvideContrasena() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('¿Olvidaste tu contraseña?'),
        message: const Text(
          'Para este laboratorio puedes usar la cuenta de prueba:\n'
          '${AppData.demoEmail} · ${AppData.demoPassword}',
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              _emailCtrl.text = AppData.demoEmail;
              _passCtrl.text = AppData.demoPassword;
              Navigator.pop(ctx);
            },
            child: const Text('Usar cuenta de prueba'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: GestureDetector(
        // Tocar fuera de los campos cierra el teclado
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  children: [
                    _encabezado(),
                    const SizedBox(height: 28),
                    Form(
                      key: _formKey,
                      child: CupertinoFormSection.insetGrouped(
                        header: const Text('CREDENCIALES'),
                        footer: Row(
                          children: [
                            const Spacer(),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _olvideContrasena,
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          CupertinoTextFormFieldRow(
                            controller: _emailCtrl,
                            prefix: const _Prefijo(CupertinoIcons.envelope_fill, AppColors.blue),
                            placeholder: 'correo@ejemplo.com',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Ingresa tu email';
                              final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.]+$');
                              if (!regex.hasMatch(v.trim())) return 'El email no es válido';
                              return null;
                            },
                          ),
                          PasswordRow(
                            controller: _passCtrl,
                            prefix: const _Prefijo(CupertinoIcons.lock_fill, AppColors.grey),
                            onSubmitted: (_) => _iniciarSesion(),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                              if (v.length < 6) return 'Mínimo 6 caracteres';
                              return null;
                            },
                          ),
                          CupertinoFormRow(
                            prefix: const Text('Recordarme'),
                            child: CupertinoSwitch(
                              value: _recordarme,
                              activeTrackColor: AppColors.primary,
                              onChanged: (v) => setState(() => _recordarme = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          borderRadius: BorderRadius.circular(14),
                          onPressed: _cargando ? null : _iniciarSesion,
                          child: _cargando
                              ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                              : const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _cuentaDemo(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _encabezado() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(CupertinoIcons.bag_fill, color: CupertinoColors.white, size: 44),
        ),
        const SizedBox(height: 18),
        const Text('TechStore', style: AppText.largeTitle),
        const SizedBox(height: 6),
        const Text(
          'Inicia sesión para gestionar tu inventario',
          style: TextStyle(fontSize: 15, color: AppColors.secondaryLabel),
        ),
      ],
    );
  }

  Widget _cuentaDemo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.info_circle_fill, size: 16, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            'Demo: ${AppData.demoEmail} · ${AppData.demoPassword}',
            style: TextStyle(fontSize: 12, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

/// Ícono de color al inicio de cada fila del formulario
class _Prefijo extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _Prefijo(this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
      child: Icon(icon, size: 16, color: CupertinoColors.white),
    );
  }
}

// ===== lib/screens/menu_screen.dart =====
// PANTALLA 2: MENÚ PRINCIPAL (pestaña Inicio)
// Saludo, resumen del inventario, accesos a cada pantalla,
// productos con stock bajo y carrusel de destacados.


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

// ===== lib/screens/perfil_screen.dart =====
// PANTALLA 5: PERFIL (pestaña Perfil)
// Datos del usuario en listas agrupadas, preferencias con
// CupertinoSwitch y acciones de la cuenta.


class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _notificaciones = true;
  bool _alertasStock = true;

  void _editar() => AppRoutes.abrir(context, AppRoutes.editarPerfil);

  /// 45600 -> "S/ 45.6k"
  static String _compacto(double v) {
    if (v >= 1000000) return 'S/ ${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return 'S/ ${(v / 1000).toStringAsFixed(1)}k';
    return 'S/ ${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ValueListenableBuilder<Usuario>(
        valueListenable: AppData.usuario,
        builder: (context, u, _) => CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Perfil'),
              middle: const Text('Perfil'),
              alwaysShowMiddle: false,
              border: null,
              backgroundColor: AppColors.background.withValues(alpha: 0.9),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _editar,
                child: const Text('Editar'),
              ),
            ),
            SliverToBoxAdapter(child: _Encabezado(usuario: u)),

            // Resumen de actividad
            SliverToBoxAdapter(
              child: ValueListenableBuilder<List<Producto>>(
                valueListenable: AppData.productos,
                builder: (_, lista, __) => Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _Resumen(valor: '${lista.length}', etiqueta: 'Productos'),
                      _divisor(),
                      _Resumen(valor: '${AppData.totalUnidades}', etiqueta: 'Unidades'),
                      _divisor(),
                      _Resumen(valor: _compacto(AppData.valorInventario), etiqueta: 'Inventario'),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                header: const SectionHeader('Información personal'),
                children: [
                  CupertinoListTile(
                    leading: const IconBox(icon: CupertinoIcons.person_fill, color: AppColors.primary),
                    title: const Text('Nombre'),
                    additionalInfo: _Info(u.nombre),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(icon: CupertinoIcons.envelope_fill, color: AppColors.blue),
                    title: const Text('Email'),
                    additionalInfo: _Info(u.email),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(icon: CupertinoIcons.phone_fill, color: AppColors.success),
                    title: const Text('Teléfono'),
                    additionalInfo: _Info(u.telefono),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(icon: CupertinoIcons.shield_fill, color: AppColors.warning),
                    title: const Text('Rol'),
                    additionalInfo: _Info(u.rol),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                header: const SectionHeader('Preferencias'),
                children: [
                  CupertinoListTile(
                    leading: const IconBox(icon: CupertinoIcons.bell_fill, color: AppColors.danger),
                    title: const Text('Notificaciones'),
                    trailing: CupertinoSwitch(
                      value: _notificaciones,
                      activeTrackColor: AppColors.success,
                      onChanged: (v) => setState(() => _notificaciones = v),
                    ),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(
                      icon: CupertinoIcons.exclamationmark_triangle_fill,
                      color: AppColors.warning,
                    ),
                    title: const Text('Alertas de stock bajo'),
                    trailing: CupertinoSwitch(
                      value: _alertasStock,
                      activeTrackColor: AppColors.success,
                      onChanged: (v) {
                        setState(() => _alertasStock = v);
                        AppToast.show(
                          context,
                          v ? 'Alertas de stock activadas' : 'Alertas de stock desactivadas',
                          icono: CupertinoIcons.bell_fill,
                          color: v ? AppColors.success : AppColors.grey,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                header: const SectionHeader('Cuenta'),
                children: [
                  CupertinoListTile(
                    leading: const IconBox(icon: CupertinoIcons.pencil, color: AppColors.grey),
                    title: const Text('Editar perfil'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: _editar,
                  ),
                  CupertinoListTile(
                    leading: const IconBox(
                      icon: CupertinoIcons.square_arrow_right,
                      color: AppColors.danger,
                    ),
                    title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.danger)),
                    onTap: () => AppRoutes.cerrarSesion(context),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: MediaQuery.of(context).padding.bottom + 28,
                ),
                child: const Text(
                  'TechStore 2.0 · Laboratorio S11-12',
                  textAlign: TextAlign.center,
                  style: AppText.caption,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divisor() => Container(width: 0.5, height: 34, color: AppColors.separator);
}

class _Encabezado extends StatelessWidget {
  final Usuario usuario;
  const _Encabezado({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 96,
          height: 96,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            usuario.iniciales,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(usuario.nombre, style: AppText.title),
        const SizedBox(height: 2),
        Text(usuario.email, style: AppText.subhead),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.checkmark_seal_fill, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                usuario.rol,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Resumen extends StatelessWidget {
  final String valor;
  final String etiqueta;
  const _Resumen({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(valor, style: AppText.headline),
          ),
          const SizedBox(height: 2),
          Text(etiqueta, style: AppText.caption),
        ],
      ),
    );
  }
}

/// Valor a la derecha de cada fila (se corta con "..." si es muy largo)
class _Info extends StatelessWidget {
  final String texto;
  const _Info(this.texto);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 190),
      child: Text(texto, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

// ===== lib/screens/registrar_producto_screen.dart =====
// PANTALLA 4: REGISTRAR / EDITAR PRODUCTO
// Formulario modal de iOS: foto, datos agrupados, selector de categoría
// con CupertinoPicker, stock con botones +/- y vista previa en vivo.


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
