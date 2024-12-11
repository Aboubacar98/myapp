import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelayPointsPage extends StatefulWidget {
  @override
  _RelayPointsPageState createState() => _RelayPointsPageState();
}

class _RelayPointsPageState extends State<RelayPointsPage> {
  GoogleMapController? mapController;
  Position? currentPosition;
  List<Marker> relayPointMarkers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationForWeb(); 
  }

  Future<void> _getCurrentLocationForWeb() async {
    try {
      // Vérifier si le service de localisation est activé (uniquement si nécessaire)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog(
          'Le service de localisation est désactivé. Veuillez l\'activer dans votre navigateur.',
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Demander la position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        isLoading = false;
      });

      // Centrer la carte sur la position
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );

      _addRelayPoints();
    } catch (e) {
      print('Erreur lors de la récupération de la position : $e');
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(
        'Impossible de récupérer votre position. Vérifiez les permissions dans votre navigateur.',
      );
    }
  }

  void _addRelayPoints() {
    setState(() {
      relayPointMarkers = [
        Marker(
          markerId: const MarkerId('relay1'),
          position: LatLng(currentPosition!.latitude + 0.01,
              currentPosition!.longitude + 0.01),
          infoWindow: const InfoWindow(title: 'Point Relais 1'),
        ),
        Marker(
          markerId: const MarkerId('relay2'),
          position: LatLng(currentPosition!.latitude - 0.01,
              currentPosition!.longitude - 0.01),
          infoWindow: const InfoWindow(title: 'Point Relais 2'),
        ),
      ];
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points relais'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentPosition == null
              ? const Center(child: Text('Position non disponible'))
              : GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    ),
                    zoom: 14,
                  ),
                  markers: Set<Marker>.of(relayPointMarkers),
                ),
    );
  }
}
