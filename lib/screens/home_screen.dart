// Contenedor principal después del login: barra de pestañas de iOS
// con Inicio (menú), Productos (listar) y Perfil.
import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';
import 'listar_productos_screen.dart';
import 'menu_screen.dart';
import 'perfil_screen.dart';

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
