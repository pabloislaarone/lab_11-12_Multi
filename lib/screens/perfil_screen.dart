// PANTALLA 5: PERFIL (pestaña Perfil)
// Datos del usuario en listas agrupadas, preferencias con
// CupertinoSwitch y acciones de la cuenta.
import 'package:flutter/cupertino.dart';

import '../data/app_data.dart';
import '../models/producto.dart';
import '../models/usuario.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/gradient_header.dart';
import '../widgets/icon_box.dart';
import '../widgets/section_header.dart';

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
            AppSliverNavBar(
              titulo: 'Perfil',
              trailing: NavTextButton('Editar', onPressed: _editar),
            ),

            // Encabezado azul con el avatar y el resumen de actividad
            SliverToBoxAdapter(
              child: GradientHeader(
                child: Column(
                  children: [
                    _Encabezado(usuario: u),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<List<Producto>>(
                      valueListenable: AppData.productos,
                      builder: (_, lista, __) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color:
                                CupertinoColors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            _Resumen(
                                valor: '${lista.length}',
                                etiqueta: 'Productos'),
                            _divisor(),
                            _Resumen(
                                valor: '${AppData.totalUnidades}',
                                etiqueta: 'Unidades'),
                            _divisor(),
                            _Resumen(
                              valor: _compacto(AppData.valorInventario),
                              etiqueta: 'Inventario',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                backgroundColor: AppColors.background,
                header: const SectionHeader('Información personal'),
                children: [
                  CupertinoListTile(
                    leading: const IconBox(
                        icon: CupertinoIcons.person_fill,
                        color: AppColors.primary),
                    title: const Text('Nombre'),
                    additionalInfo: _Info(u.nombre),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(
                        icon: CupertinoIcons.envelope_fill,
                        color: AppColors.primary),
                    title: const Text('Email'),
                    additionalInfo: _Info(u.email),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(
                        icon: CupertinoIcons.phone_fill,
                        color: AppColors.success),
                    title: const Text('Teléfono'),
                    additionalInfo: _Info(u.telefono),
                  ),
                  CupertinoListTile(
                    leading: const IconBox(
                        icon: CupertinoIcons.shield_fill,
                        color: AppColors.warning),
                    title: const Text('Rol'),
                    additionalInfo: _Info(u.rol),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                backgroundColor: AppColors.background,
                header: const SectionHeader('Preferencias'),
                children: [
                  CupertinoListTile(
                    leading: const IconBox(
                        icon: CupertinoIcons.bell_fill,
                        color: AppColors.danger),
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
                          v
                              ? 'Alertas de stock activadas'
                              : 'Alertas de stock desactivadas',
                          icono: CupertinoIcons.bell_fill,
                          color: v ? AppColors.success : AppColors.slate,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                backgroundColor: AppColors.background,
                header: const SectionHeader('Cuenta'),
                children: [
                  CupertinoListTile(
                    leading: const IconBox(
                        icon: CupertinoIcons.pencil, color: AppColors.slate),
                    title: const Text('Editar perfil'),
                    trailing: const CupertinoListTileChevron(),
                    onTap: _editar,
                  ),
                  CupertinoListTile(
                    leading: const IconBox(
                      icon: CupertinoIcons.square_arrow_right,
                      color: AppColors.danger,
                    ),
                    title: const Text('Cerrar sesión',
                        style: TextStyle(color: AppColors.danger)),
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

  Widget _divisor() => Container(
        width: 0.5,
        height: 34,
        color: CupertinoColors.white.withValues(alpha: 0.25),
      );
}

class _Encabezado extends StatelessWidget {
  final Usuario usuario;
  const _Encabezado({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            shape: BoxShape.circle,
            border: Border.all(
                color: CupertinoColors.white.withValues(alpha: 0.7), width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.4),
                blurRadius: 24,
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
        Text(
          usuario.nombre,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          usuario.email,
          style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.white.withValues(alpha: 0.75)),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.checkmark_seal_fill,
                  size: 14, color: Color(0xFF67E8F9)),
              const SizedBox(width: 4),
              Text(
                usuario.rol,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF67E8F9),
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
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.white.withValues(alpha: 0.65)),
          ),
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
