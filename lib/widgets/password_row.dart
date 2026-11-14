// Fila de formulario para contraseñas con botón para mostrar u ocultar.
// Se arma con FormField + CupertinoFormRow para poder validar con el Form.
import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

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
