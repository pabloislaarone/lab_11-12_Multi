// Editar perfil: formulario modal con CupertinoFormSection.
// Al guardar se actualiza el usuario en todas las pantallas.
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../data/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/gradient_header.dart';
import '../widgets/section_header.dart';

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
        border: null,
        automaticBackgroundVisibility: false,
        brightness: Brightness.dark,
        leading:
            NavTextButton('Cancelar', onPressed: () => Navigator.pop(context)),
        middle: const Text('Editar perfil'),
        trailing: NavTextButton('Listo', onPressed: _guardar, negrita: true),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CupertinoFormSection.insetGrouped(
                backgroundColor: AppColors.background,
                header: const SectionHeader('Datos personales'),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _nombreCtrl,
                    prefix: const _EtiquetaPerfil('Nombre'),
                    placeholder: 'Nombre y apellido',
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().length < 3)
                        ? 'Ingresa tu nombre completo'
                        : null,
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _emailCtrl,
                    prefix: const _EtiquetaPerfil('Email'),
                    placeholder: 'correo@ejemplo.com',
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (v) {
                      final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.]+$');
                      return regex.hasMatch(v?.trim() ?? '')
                          ? null
                          : 'El email no es válido';
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
                    validator: (v) => (v == null || v.length != 9)
                        ? 'Debe tener 9 dígitos'
                        : null,
                  ),
                ],
              ),
              CupertinoFormSection.insetGrouped(
                backgroundColor: AppColors.background,
                header: const SectionHeader('Rol'),
                footer: const Text(
                    'El rol define qué acciones puede realizar en el inventario.'),
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
      child: Text(texto,
          style: const TextStyle(fontSize: 16, color: AppColors.label)),
    );
  }
}
