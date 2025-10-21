import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'screens/auth/views/welcome_screen.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp({
    required this.userRepository,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: userRepository),
        child: MaterialApp(
          title: 'Trobar',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF004D98), // Barça Blue
              primary: const Color(0xFF004D98),
              secondary: const Color(0xFFA50044), // Barça Red
            ),
            useMaterial3: true,
          ),
          home: const WelcomeScreen(),
        ),
      ),
    );
  }
}