// Aviso flotante que aparece arriba y se oculta solo (como los avisos de iOS).
// Cupertino no trae SnackBar, así que se arma con un OverlayEntry.
import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

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
