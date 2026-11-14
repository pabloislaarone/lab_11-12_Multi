// Ícono blanco dentro de un cuadrado de color, como en Ajustes de iOS.
import 'package:flutter/cupertino.dart';

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
