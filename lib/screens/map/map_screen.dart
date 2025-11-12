import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/map_bloc/map_bloc.dart';
import '../../config/map_style.dart';
import 'widgets/bar_details_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor? _userIcon;
  BitmapDescriptor? _barIcon;

  @override
  void initState() {
    super.initState();
    _createCustomMarkers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MapBloc>().add(const MapLoadCurrentLocation());
      }
    });
  }

  Future<void> _createCustomMarkers() async {
    _userIcon = await _createMarkerIcon(
      const Color(0xFF2196F3),
      Icons.person_pin_circle,
      60.0,
    );
    _barIcon = await _createMarkerIcon(
      const Color(0xFFE53935),
      Icons.sports_bar,
      60.0,
    );
    if (mounted) {
      setState(() {});
    }
  }

  Future<BitmapDescriptor> _createMarkerIcon(
    Color color,
    IconData icon,
    double size,
  ) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      Offset(size / 2 + 2, size / 2 + 2),
      size / 2 - 4,
      shadowPaint,
    );
    
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 2, borderPaint);
    
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 5, paint);
    
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.5,
        fontFamily: icon.fontFamily,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );
    
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }

  void _updateMarkers(MapState state) {
    if (!mounted) return;
    
    final newMarkers = <Marker>{};

    if (state.currentLatitude != null && state.currentLongitude != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(state.currentLatitude!, state.currentLongitude!),
          icon: _userIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: '📍 Tu estàs aquí',
            snippet: 'La teva ubicació actual',
          ),
          anchor: const Offset(0.5, 0.5),
          zIndex: 999,
        ),
      );
    }

    for (var bar in state.nearbyBars) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(bar.id),
          position: LatLng(bar.latitude, bar.longitude),
          icon: _barIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: '🍺 ${bar.name}',
            snippet: '${bar.todaysMatches.length} partit${bar.todaysMatches.length != 1 ? 's' : ''} • ${bar.rating}⭐',
          ),
          anchor: const Offset(0.5, 0.5),
          onTap: () {
            if (mounted) {
              context.read<MapBloc>().add(MapBarSelected(bar));
            }
          },
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _mapController = null;
        }
      },
      child: Scaffold(
        body: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (!mounted) return;
            
            if (state.status == MapStatus.success) {
              _updateMarkers(state);
              
              if (state.currentLatitude != null &&
                  state.currentLongitude != null &&
                  _mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(state.currentLatitude!, state.currentLongitude!),
                    14.5,
                  ),
                );
              }
            }
            
            if (state.status == MapStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Error desconegut'),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Tornar a intentar',
                    textColor: Colors.white,
                    onPressed: () {
                      if (mounted) {
                        context.read<MapBloc>().add(const MapLoadCurrentLocation());
                      }
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == MapStatus.loading || _userIcon == null || _barIcon == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Carregant ubicació i bars...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            if (state.status == MapStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 24),
                      Text(
                        'Ups! Alguna cosa ha anat malament',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? 'Error desconegut',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<MapBloc>().add(const MapLoadCurrentLocation());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tornar a intentar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    if (mounted) {
                      _mapController = controller;
                      controller.setMapStyle(MapStyle.minimal);
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      state.currentLatitude ?? 41.3851,
                      state.currentLongitude ?? 2.1734,
                    ),
                    zoom: 14.5,
                  ),
                  markers: _markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
                ),

                // Barra superior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.sports_bar,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trobar',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                ),
                                Text(
                                  state.nearbyBars.isEmpty 
                                      ? 'No hi ha bars amb partits avui'
                                      : '${state.nearbyBars.length} bar${state.nearbyBars.length != 1 ? 's' : ''} amb partit avui',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: colorScheme.error),
                            tooltip: 'Tancar sessió',
                            onPressed: () {
                              _mapController = null;
                              context.read<AuthenticationBloc>().add(const AuthenticationLogoutRequested());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botó per centrar ubicació
                Positioned(
                  right: 16,
                  bottom: state.selectedBar != null ? 240 : 100,
                  child: FloatingActionButton(
                    heroTag: 'location_btn',
                    tooltip: 'Centrar la meva ubicació',
                    onPressed: () {
                      if (!mounted) return;
                      
                      if (state.currentLatitude != null && state.currentLongitude != null) {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(state.currentLatitude!, state.currentLongitude!),
                            15.5,
                          ),
                        );
                      } else {
                        context.read<MapBloc>().add(const MapLoadCurrentLocation());
                      }
                    },
                    backgroundColor: colorScheme.surface,
                    elevation: 4,
                    child: Icon(Icons.my_location, color: colorScheme.primary),
                  ),
                ),

                // Targeta de detalls
                if (state.selectedBar != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: BarDetailsCard(bar: state.selectedBar!),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}