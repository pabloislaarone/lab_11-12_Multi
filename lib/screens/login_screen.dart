// PANTALLA 1: LOGIN
// Formulario agrupado estilo iOS que valida email y contraseña.
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../data/app_data.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/password_row.dart';

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
    await Future.delayed(
        const Duration(milliseconds: 900)); // simula el servidor
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
          child: Text(
              'El email o la contraseña no son correctos. Inténtalo otra vez.'),
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
      backgroundColor: AppColors.navy,
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: Stack(
          children: [
            // Círculos decorativos de fondo
            Positioned(top: -90, right: -70, child: _circulo(260, 0.14)),
            Positioned(top: 260, left: -110, child: _circulo(220, 0.08)),
            Positioned(bottom: -80, right: -60, child: _circulo(240, 0.12)),
            GestureDetector(
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
                              backgroundColor: const Color(0x00000000),
                              header: Text(
                                'CREDENCIALES',
                                style: TextStyle(
                                    color: CupertinoColors.white
                                        .withValues(alpha: 0.7)),
                              ),
                              footer: Row(
                                children: [
                                  const Spacer(),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: _olvideContrasena,
                                    child: const Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF67E8F9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                CupertinoTextFormFieldRow(
                                  controller: _emailCtrl,
                                  prefix: const _Prefijo(
                                      CupertinoIcons.envelope_fill,
                                      AppColors.primary),
                                  placeholder: 'correo@ejemplo.com',
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return 'Ingresa tu email';
                                    final regex =
                                        RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.]+$');
                                    if (!regex.hasMatch(v.trim()))
                                      return 'El email no es válido';
                                    return null;
                                  },
                                ),
                                PasswordRow(
                                  controller: _passCtrl,
                                  prefix: const _Prefijo(
                                      CupertinoIcons.lock_fill,
                                      AppColors.slate),
                                  onSubmitted: (_) => _iniciarSesion(),
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Ingresa tu contraseña';
                                    if (v.length < 6)
                                      return 'Mínimo 6 caracteres';
                                    return null;
                                  },
                                ),
                                CupertinoFormRow(
                                  prefix: const Text('Recordarme'),
                                  child: CupertinoSwitch(
                                    value: _recordarme,
                                    activeTrackColor: AppColors.primary,
                                    onChanged: (v) =>
                                        setState(() => _recordarme = v),
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
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _cargando ? null : _iniciarSesion,
                                child: Container(
                                  height: 54,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.brandGradient,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.cyan
                                            .withValues(alpha: 0.35),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: _cargando
                                      ? const CupertinoActivityIndicator(
                                          color: CupertinoColors.white)
                                      : const Text(
                                          'Iniciar sesión',
                                          style: TextStyle(
                                            color: CupertinoColors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
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
          ],
        ),
      ),
    );
  }

  Widget _circulo(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cyan.withValues(alpha: alpha),
        ),
      );

  Widget _encabezado() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.35),
                width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.4),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(CupertinoIcons.bag_fill,
              color: CupertinoColors.white, size: 44),
        ),
        const SizedBox(height: 18),
        const Text('TechStore', style: AppText.navLarge),
        const SizedBox(height: 6),
        Text(
          'Inicia sesión para gestionar tu inventario',
          style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.white.withValues(alpha: 0.75)),
        ),
      ],
    );
  }

  Widget _cuentaDemo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: CupertinoColors.white.withValues(alpha: 0.15)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.info_circle_fill,
              size: 16, color: Color(0xFF67E8F9)),
          SizedBox(width: 6),
          Text(
            'Demo: ${AppData.demoEmail} · ${AppData.demoPassword}',
            style: TextStyle(fontSize: 12, color: CupertinoColors.white),
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
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
      child: Icon(icon, size: 16, color: CupertinoColors.white),
    );
  }
}
