/// Modelos para autenticación JWT - EasySave Service

/// Modelo para la solicitud de registro
class RegisterRequest {
  final String username;
  final String correo;
  final String password;
  final String rol;

  RegisterRequest({
    required this.username,
    required this.correo,
    required this.password,
    this.rol = 'USER',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'correo': correo,
      'password': password,
      'rol': rol,
    };
  }
}

/// Modelo para la solicitud de login
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

/// Modelo para la respuesta de autenticación (login y registro)
class AuthResponse {
  final String token;
  final String type;
  final int id;
  final String username;
  final String correo;
  final String rol;

  AuthResponse({
    required this.token,
    required this.type,
    required this.id,
    required this.username,
    required this.correo,
    required this.rol,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      type: json['type'] as String,
      id: json['id'] as int,
      username: json['username'] as String,
      correo: json['correo'] as String,
      rol: json['rol'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'type': type,
      'id': id,
      'username': username,
      'correo': correo,
      'rol': rol,
    };
  }
}

/// Modelo de usuario autenticado
class User {
  final int id;
  final String username;
  final String correo;
  final String rol;

  User({
    required this.id,
    required this.username,
    required this.correo,
    required this.rol,
  });

  factory User.fromAuthResponse(AuthResponse response) {
    return User(
      id: response.id,
      username: response.username,
      correo: response.correo,
      rol: response.rol,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      correo: json['correo'] as String,
      rol: json['rol'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'correo': correo,
      'rol': rol,
    };
  }
}
