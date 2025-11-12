import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/map_bloc/map_bloc.dart';
import 'screens/map/map_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trobar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004D98), // Barça blue
          secondary: const Color(0xFFFDB827), // Barça gold
          tertiary: const Color(0xFFDC0030), // Red accent
          brightness: Brightness.light,
        ),
      ),
      home: BlocProvider(
        create: (context) => MapBloc(),
        child: const MapScreen(),
      ),
    );
  }
}
