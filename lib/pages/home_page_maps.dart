import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:projeto_final/helpers/database_helper.dart';
import 'package:projeto_final/models/pessoa.dart';

class AppMaps extends StatefulWidget {
  @override
  _AppMapsState createState() => _AppMapsState();
}

class _AppMapsState extends State<AppMaps> {
  StreamSubscription _locationSubscription;
  GoogleMapController mapController;
  LatLng latlng;

  DatabaseHelper db = DatabaseHelper();
  List<Pessoa> pessoas = List<Pessoa>();

  final LatLng _center = const LatLng(-5.088551, -42.811188);
  Location _locationTracker = Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    allPoints();
  }

  void allPoints() {
    db.getPessoas().then((lista) {
      pessoas = lista;
      for (int i = 0; i <= pessoas.length; i++) {
        double latitude = double.tryParse(pessoas[i].latitude);
        double longitude = double.tryParse(pessoas[i].longitude);
        LatLng location = new LatLng(latitude, longitude);
        String name = pessoas[i].nome;

        _addMarker(location, name);
      }
    });
  }

  void _addMarker(LatLng latlng, String nome) {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }
    final MarkerId markerId = MarkerId(nome);

    final Marker marker = Marker(
      markerId: markerId,
      position: (latlng),
      infoWindow: InfoWindow(title: nome, snippet: latlng.toString()),
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void updateMarkerAndCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      _addMarker(latlng, 'Local Atual');
    });
  }

  void getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps App'),
        backgroundColor: Colors.green[500],
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 18.0,
        ),
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () {
          getCurrentLocation();
        },
      ),
    );
  }
}
