import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final LatLng _actopan = const LatLng(20.2706, -98.9450);
  final Set<Marker> _markers = {};
  int _markerIdCounter = 0;
  final Color _primaryColor = Colors.blue.shade800;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleLongPress(LatLng position) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerFormScreen(position: position),
      ),
    );

    if (result != null) {
      _addNewMarker(result);
    }
  }

  void _addNewMarker(Map<String, dynamic> data) {
    final String markerId = 'marker_${_markerIdCounter++}';

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: data['position'],
          infoWindow: InfoWindow(
            title: data['title'],
            snippet: data['description'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(210),
          onTap: () {
            mapController?.showMarkerInfoWindow(MarkerId(markerId));
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Actopan, Hidalgo'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.center_focus_strong, color: Colors.white),
            onPressed: () => mapController
                ?.animateCamera(CameraUpdate.newLatLngZoom(_actopan, 14)),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onLongPress: _handleLongPress,
        initialCameraPosition: CameraPosition(
          target: _actopan,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        mapType: MapType.hybrid,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        child: Icon(Icons.zoom_out_map, color: Colors.white),
        onPressed: () => mapController?.animateCamera(CameraUpdate.zoomTo(14)),
      ),
    );
  }
}

class MarkerFormScreen extends StatefulWidget {
  final LatLng position;

  const MarkerFormScreen({Key? key, required this.position}) : super(key: key);

  @override
  _MarkerFormScreenState createState() => _MarkerFormScreenState();
}

class _MarkerFormScreenState extends State<MarkerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Color _primaryColor = Colors.blue.shade800;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'position': widget.position,
        'title': _titleController.text,
        'description': _descriptionController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Marcador'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildForm(),
            const SizedBox(height: 20),
            _buildCoordinates(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.place, size: 50, color: _primaryColor),
        const SizedBox(height: 10),
        Text(
          'Agregar nuevo lugar',
          style: TextStyle(
            fontSize: 20,
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Título del lugar',
              prefixIcon: Icon(Icons.title, color: _primaryColor),
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descripción detallada',
              prefixIcon: Icon(Icons.description, color: _primaryColor),
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 3,
            validator: (value) {
              if (value!.isEmpty) return 'Campo requerido';
              if (value.length < 10) return 'Mínimo 10 caracteres';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinates() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_pin, color: _primaryColor),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lat: ${widget.position.latitude.toStringAsFixed(5)}',
                  style: TextStyle(color: _primaryColor)),
              Text('Lon: ${widget.position.longitude.toStringAsFixed(5)}',
                  style: TextStyle(color: _primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _submitForm,
        child: const Text('Guardar Marcador', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
