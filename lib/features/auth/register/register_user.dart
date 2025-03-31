import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/features/auth/terms_and_conditions_screen.dart';
import 'package:psicologia_app_liid/features/home/controllers/home_controller.dart';
import '../services/auth_service.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final AuthService _authService = AuthService();
  late final HomeController _homeController = Get.find<HomeController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final user = await _authService.registerWithEmailPassword(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        Get.snackbar("Registro Exitoso", "Bienvenido, ${user.displayName ?? 'Usuario'}");
        _homeController.goToTematicasP(); 
      } else {
        Get.snackbar("Error", "No se pudo registrar el usuario");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF398AD5), // Color superior
              Color(0xFFF8F8F8), // Color inferior
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2FmarcianoLogin.png?alt=media&token=18eb7af9-c30b-4dd8-b134-2abcf42ae056',
                width: 220, // Imagen más pequeña que en el login
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 48,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Registro',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(hintText: "Ingresa tu nombre"),
                          validator: (value) => value!.isEmpty ? "El nombre es obligatorio" : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(hintText: "Ingresa tu correo"),
                          validator: (value) => value!.isEmpty || !value.contains("@") ? "Correo inválido" : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: "Ingresa tu contraseña"),
                          validator: (value) => value!.length < 6 ? "Debe tener al menos 6 caracteres" : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: "Confirma tu contraseña"),
                          validator: (value) =>
                              value != _passwordController.text ? "Las contraseñas no coinciden" : null,
                        ),
                        const SizedBox(height: 30),

                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3284FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                  ),
                                  child: const Text(
                                    "Registrarse",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 10),
                        Center(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                          ),
                        ),

                        const SizedBox(height: 30),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
                            );
                          },
                          child: const Text(
                            "Leer términos y condiciones",
                            style: TextStyle(decoration: TextDecoration.underline),
                          ),
                        )

                      ],
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
}
