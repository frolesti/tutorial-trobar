import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../blocs/map_bloc/map_bloc.dart';
import '../../../models/bar.dart';

class BarDetailsCard extends StatelessWidget {
  final Bar bar;

  const BarDetailsCard({super.key, required this.bar});

  Future<void> _openMapsNavigation(BuildContext context) async {
    final state = context.read<MapBloc>().state;
    final userLat = state.currentLatitude;
    final userLng = state.currentLongitude;

    // URL per Google Maps (Android, Web i per defecte)
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLng&destination=${bar.latitude},${bar.longitude}&travelmode=walking'
    );

    // URL per Apple Maps (iOS)
    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?saddr=$userLat,$userLng&daddr=${bar.latitude},${bar.longitude}&dirflg=w'
    );

    try {
      Uri urlToLaunch;
      
      // Per Web sempre Google Maps
      if (kIsWeb) {
        urlToLaunch = googleMapsUrl;
      } else {
        // Per mòbil, intentar detectar la plataforma
        // Si està en iOS, usar Apple Maps, sinó Google Maps
        urlToLaunch = Theme.of(context).platform == TargetPlatform.iOS
            ? appleMapsUrl
            : googleMapsUrl;
      }

      if (await canLaunchUrl(urlToLaunch)) {
        await launchUrl(
          urlToLaunch,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'No es pot obrir el mapa';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error obrint el mapa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // ⬅️ CANVIAT
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle per arrossegar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4), // ⬅️ CANVIAT
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, colorScheme),
                const SizedBox(height: 16),
                _buildAddress(context, colorScheme),
                const SizedBox(height: 8),
                if (bar.phoneNumber.isNotEmpty) _buildPhone(context, colorScheme),
                const SizedBox(height: 16),
                if (bar.amenities.isNotEmpty) ...[
                  _buildAmenities(colorScheme),
                  const SizedBox(height: 16),
                ],
                if (bar.todaysMatches.isNotEmpty) ...[
                  _buildMatchesSection(context, colorScheme),
                  const SizedBox(height: 16),
                ],
                _buildActionButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.sports_bar,
            color: colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bar.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    '${bar.rating} (${bar.reviewCount} valoracions)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<MapBloc>().add(const MapBarSelected(null));
          },
        ),
      ],
    );
  }

  Widget _buildAddress(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${bar.address}, ${bar.city}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildPhone(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(Icons.phone, size: 16, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          bar.phoneNumber,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAmenities(ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: bar.amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            amenity,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMatchesSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚽ Partits d\'avui',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...bar.todaysMatches.map((match) {
          final hours = match.dateTime.hour.toString().padLeft(2, '0');
          final minutes = match.dateTime.minute.toString().padLeft(2, '0');
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest, // ⬅️ CANVIAT
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$hours:$minutes',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${match.homeTeam} vs ${match.awayTeam}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${match.competition} • ${match.tvChannel ?? "TV local"}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => _openMapsNavigation(context),
            icon: const Icon(Icons.directions),
            label: const Text('Com arribar'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pròximament: Detalls complets')),
            );
          },
          icon: const Icon(Icons.info_outline),
          label: const Text(''),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}