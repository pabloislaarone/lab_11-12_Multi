// Modelo: Producto
import 'package:flutter/widgets.dart';

class Producto {
  final String id;
  final String nombre;
  final String marca;
  final String descripcion;
  final double precio;
  final int stock;
  final String categoria;

  /// URL de la foto del producto (puede ser null si no tiene foto)
  final String? imagenUrl;

  /// Ícono de respaldo: se muestra si no hay foto o si no carga
  final IconData icono;

  const Producto({
    required this.id,
    required this.nombre,
    this.marca = '',
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    this.imagenUrl,
    required this.icono,
  });

  // copyWith crea una copia cambiando solo algunos campos (para EDITAR).
  Producto copyWith({
    String? nombre,
    String? marca,
    String? descripcion,
    double? precio,
    int? stock,
    String? categoria,
    String? imagenUrl,
    IconData? icono,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      icono: icono ?? this.icono,
    );
  }

  /// Precio con formato peruano: "S/ 3,500.00"
  String get precioFormateado => soles(precio);

  /// Da formato de soles a cualquier monto (con comas de miles)
  static String soles(double monto) {
    final partes = monto.toStringAsFixed(2).split('.');
    final entero = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return 'S/ $entero.${partes[1]}';
  }
}
