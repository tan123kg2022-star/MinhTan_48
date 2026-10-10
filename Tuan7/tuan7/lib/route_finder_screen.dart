import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class RouteFinderScreen extends StatefulWidget {
  const RouteFinderScreen({super.key});

  @override
  _RouteFinderScreenState createState() => _RouteFinderScreenState();
}

class _RouteFinderScreenState extends State<RouteFinderScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();

  LatLng? _startLatLng;
  LatLng? _endLatLng;

  // Biến lưu khoảng cách và thời gian
  String _distance = "";
  String _duration = "";

  // Tọa độ mặc định
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.7769, 106.7009),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Lấy vị trí hiện tại gán vào ô Xuất phát
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _startLatLng = LatLng(position.latitude, position.longitude);
      _addMarker(_startLatLng!, "Xuất phát");
      _moveCamera(_startLatLng!);
      _startController.text = "${position.latitude}, ${position.longitude}";
    });
  }

  // 1. Chức năng: Nút lấy vị trí hiện tại làm điểm đích
  Future<void> _setDestinationToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _endLatLng = LatLng(position.latitude, position.longitude);
      _endController.text = "${position.latitude}, ${position.longitude}";
      _markers.removeWhere((m) => m.markerId.value == "Đích đến");
      _addMarker(_endLatLng!, "Đích đến");
      _moveCamera(_endLatLng!);
    });
  }

  // Hàm thêm marker
  void _addMarker(LatLng position, String markerId) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          infoWindow: InfoWindow(title: markerId),
        ),
      );
    });
  }

  // Hàm di chuyển camera
  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  // 2. Chức năng: Cho phép chọn điểm bằng cách click trên bản đồ
  void _onMapTapped(LatLng position) {
    setState(() {
      _endLatLng = position;
      _endController.text = "${position.latitude}, ${position.longitude}";

      // Xóa điểm đích cũ (nếu có) và thêm điểm mới
      _markers.removeWhere((marker) => marker.markerId.value == "Đích đến");
      _addMarker(position, "Đích đến");
    });
  }

  // 3. Chức năng: Tìm kiếm các địa điểm xung quanh (Google Places API)
  Future<void> _searchPlaces(String keyword) async {
    if (_startLatLng == null) return;

    String apiKey = "AIzaSyA5lvDBCyx1GmTNg9ZppaiqY5-CyMNc4FE"; // THAY API KEY CỦA BẠN VÀO ĐÂY
    // Gọi Places API (Text Search)
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$keyword&location=${_startLatLng!.latitude},${_startLatLng!.longitude}&radius=5000&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['results'] != null) {
        setState(() {
          _markers.clear();
          _polylines.clear(); // Xóa đường đi cũ
          _distance = "";
          _duration = "";

          _addMarker(_startLatLng!, "Xuất phát"); // Giữ lại điểm xuất phát

          // Thêm marker cho các địa điểm tìm được
          for (var place in data['results']) {
            var location = place['geometry']['location'];
            LatLng pos = LatLng(location['lat'], location['lng']);
            _markers.add(
              Marker(
                markerId: MarkerId(place['place_id']),
                position: pos,
                infoWindow: InfoWindow(title: place['name']),
                // Đổi màu marker để dễ phân biệt
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
            );
          }
        });
      }
    }
  }

  // 4. Chức năng: Lấy thông tin tìm đường, kèm khoảng cách & thời gian
  Future<void> _findRoute() async {
    if (_startController.text.isEmpty || _endController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng nhập điểm đi và đến!')));
      return;
    }

    try {
      List<String> start = _startController.text.split(',');
      List<String> end = _endController.text.split(',');

      _startLatLng = LatLng(
        double.parse(start[0].trim()),
        double.parse(start[1].trim()),
      );
      _endLatLng = LatLng(
        double.parse(end[0].trim()),
        double.parse(end[1].trim()),
      );

      String apiKey = "YOUR_API_KEY_HERE"; // THAY API KEY CỦA BẠN VÀO ĐÂY
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${_startLatLng!.latitude},${_startLatLng!.longitude}&destination=${_endLatLng!.latitude},${_endLatLng!.longitude}&key=$apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          // Lấy Khoảng cách và Thời gian từ JSON của Google Maps
          var leg = data['routes'][0]['legs'][0];
          String distance = leg['distance']['text'];
          String duration = leg['duration']['text'];

          String polylinePoints =
              data['routes'][0]['overview_polyline']['points'];
          List<LatLng> points = _decodePolyline(polylinePoints);

          setState(() {
            _distance = distance;
            _duration = duration;
            _markers.clear();
            _addMarker(_startLatLng!, "Xuất phát");
            _addMarker(_endLatLng!, "Đích đến");
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                points: points,
                color: Colors.blue,
                width: 5,
              ),
            );
          });
          _moveCamera(_startLatLng!);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không tìm thấy tuyến đường nào!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tọa độ lỗi. Vui lòng nhập: lat, lng')),
      );
    }
  }

  // Giải mã polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route & Place Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _startController,
                  decoration: InputDecoration(
                    labelText: 'Xuất phát (lat, lng)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _endController,
                  decoration: InputDecoration(
                    labelText: 'Đích đến (lat, lng)',
                    border: OutlineInputBorder(),
                    // Thêm nút lấy vị trí hiện tại làm đích
                    suffixIcon: IconButton(
                      icon: Icon(Icons.my_location, color: Colors.red),
                      onPressed: _setDestinationToCurrentLocation,
                      tooltip: 'Lấy vị trí hiện tại làm đích',
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Hàng nút chức năng tìm đường và tìm địa điểm
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _findRoute,
                        icon: Icon(Icons.directions),
                        label: Text('Chỉ đường'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _searchPlaces('Khách sạn'),
                        child: Text('Khách sạn'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _searchPlaces('Quán ăn'),
                        child: Text('Quán ăn'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _searchPlaces('Bệnh viện'),
                        child: Text('Bệnh viện'),
                      ),
                    ],
                  ),
                ),

                // Hiển thị khoảng cách và thời gian
                if (_distance.isNotEmpty && _duration.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Khoảng cách: $_distance  |  Thời gian: $_duration',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              polylines: _polylines,
              // Kích hoạt sự kiện bấm vào bản đồ để chọn điểm
              onTap: _onMapTapped,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
