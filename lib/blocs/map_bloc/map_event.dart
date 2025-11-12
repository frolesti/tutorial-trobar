part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class MapLoadCurrentLocation extends MapEvent {
  const MapLoadCurrentLocation();
}

class MapBarSelected extends MapEvent {
  final Bar? bar; // ⬅️ Ara pot ser null

  const MapBarSelected(this.bar);

  @override
  List<Object?> get props => [bar];
}