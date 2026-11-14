// Encabezado con degradado frío y círculos decorativos.
// Va justo debajo de la barra de navegación para continuar su color.
import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

class GradientHeader extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GradientHeader({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          Positioned(top: 24, right: -90, child: _circulo(220, 0.08)),
          Positioned(bottom: -60, left: -40, child: _circulo(160, 0.06)),
          Padding(
            padding: padding,
            child: SizedBox(width: double.infinity, child: child),
          ),
        ],
      ),
    );
  }

  static Widget _circulo(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cyan.withValues(alpha: alpha * 2),
        ),
      );
}

/// Barra de navegación con título grande sobre fondo azul marino
class AppSliverNavBar extends StatelessWidget {
  final String titulo;
  final Widget? leading;
  final Widget? trailing;

  const AppSliverNavBar(
      {super.key, required this.titulo, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text(titulo),
      middle: Text(titulo),
      alwaysShowMiddle: false,
      backgroundColor: AppColors.navy,
      // Siempre azul, aunque el contenido no haya pasado por debajo
      automaticBackgroundVisibility: false,
      brightness: Brightness.dark,
      border: null,
      leading: leading,
      trailing: trailing,
    );
  }
}

/// Botón de texto blanco para las barras oscuras
class NavTextButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final bool negrita;

  const NavTextButton(this.texto,
      {super.key, required this.onPressed, this.negrita = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        texto,
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: 17,
          fontWeight: negrita ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

/// Botón de ícono blanco para las barras oscuras
class NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const NavIconButton(this.icon,
      {super.key, required this.onPressed, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Icon(icon, color: CupertinoColors.white, size: size),
    );
  }
}
