part of 'map_bloc.dart';

enum MapStatus { initial, loading, success, error, locationDenied }

class MapState extends Equatable {
  final MapStatus status;
  final double? currentLatitude;
  final double? currentLongitude;
  final List<Bar> nearbyBars;
  final Bar? selectedBar;
  final String? errorMessage;

  const MapState({
    this.status = MapStatus.initial,
    this.currentLatitude,
    this.currentLongitude,
    this.nearbyBars = const [],
    this.selectedBar,
    this.errorMessage,
  });

  MapState copyWith({
    MapStatus? status,
    double? currentLatitude,
    double? currentLongitude,
    List<Bar>? nearbyBars,
    Bar? selectedBar,
    bool clearSelectedBar = false, // ⬅️ Nou paràmetre
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      nearbyBars: nearbyBars ?? this.nearbyBars,
      selectedBar: clearSelectedBar ? null : (selectedBar ?? this.selectedBar), // ⬅️ Lògica millorada
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentLatitude,
        currentLongitude,
        nearbyBars,
        selectedBar,
        errorMessage,
      ];
}