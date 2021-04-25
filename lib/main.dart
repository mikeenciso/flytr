import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import './src/models/stateVectors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flytr',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flytr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  BitmapDescriptor airplaneIcon;
  Timer timer;
  GoogleMapController _controller;
  LatLng upperLeftCorner;
  LatLng upperRightCorner;
  LatLng lowerLeftCorner;
  LatLng lowerRightCorner;
  List<LatLng> polygonLatLngs = List<LatLng>.empty(growable: true);

  // Initial Camera Position
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(46.8182, 8.2275),
    zoom: 7,
  );

  Future<StateVector> fetchStateVector() async {
    final queryParameters = {
      'lamin': lowerLeftCorner.latitude.toString(),
      'lomin': lowerLeftCorner.longitude.toString(),
      'lamax': upperRightCorner.latitude.toString(),
      'lomax': upperRightCorner.longitude.toString(),
    };

    final response = await http.get(Uri.https(
        'www.opensky-network.org', '/api/states/all', queryParameters));

    if (response.statusCode == 200) {
      return stateVectorFromJson(response.body);
    } else {
      print('Failed to load message');
      return null;
    }
  }

  void plotAirplanes() {
    fetchStateVector().then((futureStateVector) {
      if (futureStateVector != null) {
        setState(() {
          for (dynamic airplane in futureStateVector.states) {
            if (airplane[0] != null &&
                airplane[5] != null &&
                airplane[6] != null &&
                airplane[10] != null) {
              final Marker marker = Marker(
                markerId: MarkerId(airplane[0].toString()),
                position:
                    LatLng(airplane[6].toDouble(), airplane[5].toDouble()),
                icon: airplaneIcon,
                rotation: airplane[10].toDouble(),
              );
              markers[MarkerId(airplane[0].toString())] = marker;
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _initialCameraPosition = CameraPosition(
      target: LatLng(46.8182, 8.2275),
      zoom: 7,
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/airplane-icon-001.png')
        .then((value) => airplaneIcon = value);

    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => plotAirplanes());

    lowerLeftCorner = LatLng(45.8389, 5.9962);
    upperRightCorner = LatLng(47.8229, 10.5226);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<LatLngBounds> getVisibleMapRegion() async {
    return _controller.getVisibleRegion();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////
  // ME: PLEASE DO NOTE DELETE - USED FOR TESTING/DEBUGGING VISIBLE REGION COORDINATES
  // _redrawPolygon() method is used for dynamic display of the visible region
  // Note: Longitude is X, Latitude is Y, maybe fix variables names later to prevent confusion
  // Set<Polygon> _redrawPolygon() {
  //   polygonLatLngs.clear();
  //   if (upperLeftCorner != null) {
  //     polygonLatLngs
  //         .add(LatLng(upperLeftCorner.latitude, upperLeftCorner.longitude));
  //     polygonLatLngs
  //         .add(LatLng(upperRightCorner.latitude, upperRightCorner.longitude));
  //     polygonLatLngs
  //         .add(LatLng(lowerRightCorner.latitude, lowerRightCorner.longitude));
  //     polygonLatLngs
  //         .add(LatLng(lowerLeftCorner.latitude, lowerLeftCorner.longitude));
  //   } else {
  //     polygonLatLngs.add(LatLng(45.8389, 5.9962));
  //     polygonLatLngs.add(LatLng(47.8229, 5.9962));
  //     polygonLatLngs.add(LatLng(47.8229, 10.5226));
  //     polygonLatLngs.add(LatLng(45.8389, 10.5226));
  //   }
  //
  //   polygons[PolygonId("1")] = Polygon(
  //     polygonId: PolygonId("1"),
  //     points: polygonLatLngs,
  //     strokeWidth: 2,
  //     strokeColor: Colors.yellow,
  //     fillColor: Colors.transparent,
  //   );
  //
  //   return Set<Polygon>.of(polygons.values);
  // }
  //////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: Set<Marker>.of(markers.values),
        /////////////////////////////////////////
        //ME: PLEASE DO NOTE DELETE - USED FOR TESTING/DEBUGGING VISIBLE REGION COORDINATES
        //polygons: _redrawPolygon(),
        /////////////////////////////////////////
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        onCameraMove: (CameraPosition position) {
          getVisibleMapRegion().then((visibleRegionLatLng) {
            //upperLeftCorner
            upperLeftCorner = new LatLng(visibleRegionLatLng.northeast.latitude,
                visibleRegionLatLng.southwest.longitude);

            //upperRightCorner
            upperRightCorner = new LatLng(
                visibleRegionLatLng.northeast.latitude,
                visibleRegionLatLng.northeast.longitude);

            //lowerRightCorner
            lowerRightCorner = new LatLng(
                visibleRegionLatLng.southwest.latitude,
                visibleRegionLatLng.northeast.longitude);

            //lowerLeftCorner
            lowerLeftCorner = new LatLng(visibleRegionLatLng.southwest.latitude,
                visibleRegionLatLng.southwest.longitude);

            //////////////////////////////////////////////////////////////////////////////////////////////////
            //ME: PLEASE DO NOTE DELETE - USED FOR TESTING/DEBUGGING VISIBLE REGION COORDINATES
            // print(
            //     "upperLeftCorner: LAT ${upperLeftCorner.latitude}; LONG ${upperLeftCorner.longitude}");
            // print(
            //     "upperRightCorner: LAT ${upperRightCorner.latitude}; LONG ${upperRightCorner.longitude}");
            // print(
            //     "lowerLeftCorner: LAT ${lowerLeftCorner.latitude}; LONG ${lowerLeftCorner.longitude}");
            // print(
            //     "lowerRightCorner: LAT ${lowerRightCorner.latitude}; LONG ${lowerRightCorner.longitude}");
            //
            // _redrawPolygon();
            //////////////////////////////////////////////////////////////////////////////////////////////////
          });
        },
      ),
    );
  }
}
