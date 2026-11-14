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
