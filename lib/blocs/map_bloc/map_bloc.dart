import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/bar.dart';
import '../../services/bar_service.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final BarService _barService = BarService();

  MapBloc() : super(const MapState()) {
    on<MapLoadCurrentLocation>(_onLoadCurrentLocation);
    on<MapBarSelected>(_onBarSelected);
  }

  Future<void> _onLoadCurrentLocation(
    MapLoadCurrentLocation event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(status: MapStatus.loading));

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(
            status: MapStatus.locationDenied,
            errorMessage: 'Permisos de localització denegats',
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
          status: MapStatus.locationDenied,
          errorMessage: 'Permisos de localització denegats permanentment',
        ));
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      final bars = await _barService.getNearbyBarsWithMatches(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusKm: 5.0,
      );

      emit(state.copyWith(
        status: MapStatus.success,
        currentLatitude: position.latitude,
        currentLongitude: position.longitude,
        nearbyBars: bars,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: 'Error: $e',
      ));
    }
  }

  void _onBarSelected(MapBarSelected event, Emitter<MapState> emit) {
    emit(state.copyWith(selectedBar: event.bar));
  }
}