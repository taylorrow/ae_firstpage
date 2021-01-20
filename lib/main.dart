import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.green,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AE First Page',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Location _location = Location();
  BitmapDescriptor _customIcon;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getBytesFromAsset('assets/ico_car.png', 80).then((onValue) {
      _customIcon = BitmapDescriptor.fromBytes(onValue);
    });
  }

  _loadMarkers() {
    _markers = {
      Marker(
          markerId: MarkerId('1'),
          icon: _customIcon,
          position: LatLng(49.977505, 36.180908)),
      Marker(
          markerId: MarkerId('2'),
          icon: _customIcon,
          position: LatLng(49.987990, 36.231231)),
      Marker(
          markerId: MarkerId('3'),
          icon: _customIcon,
          position: LatLng(50.013628, 36.247761)),
      Marker(
          markerId: MarkerId('4'),
          icon: _customIcon,
          position: LatLng(49.995381, 36.329032)),
      Marker(
          markerId: MarkerId('5'),
          icon: _customIcon,
          position: LatLng(49.944013, 36.289009))
    };
  }

  static final CameraPosition _startPlace = CameraPosition(
    target: LatLng(49.992717, 36.221271),
    zoom: 12,
  );

  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) async {
    await _setStyle(controller);
    _controller.complete(controller);
    setState(() {
      _loadMarkers();
    });
    _goToCurrentLocation();
  }

  _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: _BottomBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _startPlace,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 110, right: 8),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  mini: true,
                  child: SvgPicture.asset(
                    "assets/ico_burger.svg",
                    height: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      mini: true,
                      child: SvgPicture.asset(
                        "assets/ico_search.svg",
                        height: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    mini: true,
                    child: SvgPicture.asset(
                      "assets/ico_gps.svg",
                      height: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            _InfoField(),
          ],
        ),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    LocationData locationData = await _location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(locationData.latitude, locationData.longitude),
          zoom: 11),
    ));
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/ico_burger.svg",
                  height: 15,
                ),
                Text(
                  'Меню',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/ico_list.svg",
                  height: 15,
                ),
                Text(
                  'Список',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/ico_search.svg",
                  height: 15,
                ),
                Text(
                  'Поиск',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/ico_filter.svg",
                  height: 15,
                ),
                Text(
                  'Фильтр',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 5,
          color: Colors.white.withOpacity(0.5),
        ),
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.white.withOpacity(0.5),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset("assets/ico_car.svg"),
                    Text(
                      '  Автомобилей в системе',
                      style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[900],
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Всего в сети',
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '24',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Доступно к аренде',
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '17',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Арендуются',
                          style: TextStyle(
                            color: Colors.blueGrey[800],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '7',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 4,
          color: Colors.white.withOpacity(0.5),
        ),
      ],
    );
  }
}
