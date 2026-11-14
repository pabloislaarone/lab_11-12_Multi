// Título de una sección agrupada (CupertinoListSection / CupertinoFormSection)
import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String texto;
  const SectionHeader(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(texto, style: AppText.section),
    );
  }
}
