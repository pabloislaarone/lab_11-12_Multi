// Rutas de la aplicación (navegación centralizada con CupertinoPageRoute)
import 'package:flutter/cupertino.dart';

import '../models/producto.dart';
import '../screens/editar_perfil_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/registrar_producto_screen.dart';

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
