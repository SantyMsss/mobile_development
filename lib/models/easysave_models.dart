/// Modelos para EasySave Service - Gestión de Ingresos y Gastos

/// Modelo de Ingreso
class Ingreso {
  final int? id;
  final String nombreIngreso;
  final double valorIngreso;
  final String estadoIngreso; // "fijo" o "variable"

  Ingreso({
    this.id,
    required this.nombreIngreso,
    required this.valorIngreso,
    required this.estadoIngreso,
  });

  factory Ingreso.fromJson(Map<String, dynamic> json) {
    return Ingreso(
      id: json['id'] as int?,
      nombreIngreso: json['nombreIngreso'] as String,
      valorIngreso: (json['valorIngreso'] as num).toDouble(),
      estadoIngreso: json['estadoIngreso'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombreIngreso': nombreIngreso,
      'valorIngreso': valorIngreso,
      'estadoIngreso': estadoIngreso,
    };
  }
}

/// Modelo de Gasto
class Gasto {
  final int? id;
  final String nombreGasto;
  final double valorGasto;
  final String estadoGasto; // "fijo" o "variable"

  Gasto({
    this.id,
    required this.nombreGasto,
    required this.valorGasto,
    required this.estadoGasto,
  });

  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: json['id'] as int?,
      nombreGasto: json['nombreGasto'] as String,
      valorGasto: (json['valorGasto'] as num).toDouble(),
      estadoGasto: json['estadoGasto'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombreGasto': nombreGasto,
      'valorGasto': valorGasto,
      'estadoGasto': estadoGasto,
    };
  }
}

/// Modelo de Usuario con ingresos y gastos
class UsuarioCompleto {
  final int id;
  final String username;
  final String correo;
  final String rol;
  final List<Ingreso> ingresos;
  final List<Gasto> gastos;

  UsuarioCompleto({
    required this.id,
    required this.username,
    required this.correo,
    required this.rol,
    required this.ingresos,
    required this.gastos,
  });

  factory UsuarioCompleto.fromJson(Map<String, dynamic> json) {
    return UsuarioCompleto(
      id: json['id'] as int,
      username: json['username'] as String,
      correo: json['correo'] as String,
      rol: json['rol'] as String,
      ingresos: (json['ingresos'] as List?)
              ?.map((i) => Ingreso.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      gastos: (json['gastos'] as List?)
              ?.map((g) => Gasto.fromJson(g as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Calcular total de ingresos
  double get totalIngresos {
    return ingresos.fold(0, (sum, ingreso) => sum + ingreso.valorIngreso);
  }

  // Calcular total de gastos
  double get totalGastos {
    return gastos.fold(0, (sum, gasto) => sum + gasto.valorGasto);
  }

  // Calcular balance (ingresos - gastos)
  double get balance {
    return totalIngresos - totalGastos;
  }

  // Obtener ingresos fijos
  List<Ingreso> get ingresosFijos {
    return ingresos.where((i) => i.estadoIngreso == 'fijo').toList();
  }

  // Obtener ingresos variables
  List<Ingreso> get ingresosVariables {
    return ingresos.where((i) => i.estadoIngreso == 'variable').toList();
  }

  // Obtener gastos fijos
  List<Gasto> get gastosFijos {
    return gastos.where((g) => g.estadoGasto == 'fijo').toList();
  }

  // Obtener gastos variables
  List<Gasto> get gastosVariables {
    return gastos.where((g) => g.estadoGasto == 'variable').toList();
  }
}
