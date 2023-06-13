import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'directions_model.dart';
import 'directions_reposiroty.dart';
import 'latest_data.dart';
import 'popup_alert.dart';
import 'home.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 11.5,
  );
  final dbRef = FirebaseDatabase.instance.ref().child("locations");
  List<Map<dynamic,dynamic>> dataList = [];
  List<Map<dynamic,dynamic>> tempDataList = [];


  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  Directions? _info;
  List<Polyline> _polylines = [];
  int totalDistance = 0;
  List<int> totalDuration = [0, 0];

  String _selectedOption = 'All';
  String _selectedOptionTemp = 'All';


  @override
  void initState(){
    super.initState();
    
    dbRef.onValue.listen((event) {
      dataList.clear();
      Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, values) {
        dataList.add(values);
      });
      _updateMarker();

    });
    dbRef.orderByChild('timestamp').limitToLast(1).onChildAdded.listen((event) {
        if (event.snapshot.value != null){
          Map<dynamic,dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          bool isManual = data['manualTemp'];
          if(isManual){
            LatestData latestData = LatestData(
              latitude: double.parse(data['latitude']),
              longitude: double.parse(data['longitude']),
              timestamp: DateTime.parse(data['timestamp']),
              phoneNumber: data['phone number'].toString(),
              isManual: data['manualTemp'],
            );
            dbRef.child(event.snapshot.key!).child('manualTemp').set(false).then((_){
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => PopupAlert(latestData: latestData,)),
                (route) => false
              );
            }
             );
          }
        }
      });
  }

void _updateMarker() async {
  _markers.clear();
  _polylines.clear();

  dataList.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

  for (var i = 0; i < dataList.length; i++) {
    double lat = double.parse(dataList[i]['latitude']);
    double lng = double.parse(dataList[i]['longitude']);
    Marker marker;
    int j = i+1;

    switch (dataList[i]['manual']) {
      case true:
        if (_selectedOption == 'Manual' || _selectedOption == 'All') {
          marker = Marker(
            markerId: MarkerId(j.toString()),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: 'Marker ${i + 1}'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          );
          _markers.add(marker);
        }
        break;
      default:
        if (_selectedOption == 'Auto' || _selectedOption == 'All') {
          marker = Marker(
            markerId: MarkerId(j.toString()),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: 'Marker ${i + 1}'),
            icon: BitmapDescriptor.defaultMarker,
          );
          _markers.add(marker);
        }
    }
  }

  for (var i = 0; i < _markers.length - 1; i++) {
    final directions = await DirectionsRepository().getDirections(
      origin: _markers.elementAt(i).position,
      destination: _markers.elementAt(i + 1).position,
    );
    if (directions != null) {
      setState(() {
        _info = directions;
        _polylines.add(
          Polyline(
            polylineId: PolylineId("Polyline $i"),
            color: Colors.blue,
            width: 5,
            points: _info!.polylinePoints.map(
              (e) => LatLng(e.latitude, e.longitude),
            ).toList(),
          ),
        );
      });
    }
  }
}



List<Map<dynamic, dynamic>> _getFilteredDataList() {
  switch (_selectedOption) {
    case 'Manual':
      return dataList.where((data) => data['manual'] == true).toList();
    case 'Auto':
      return dataList.where((data) => data['manual'] == false).toList();
    default:
      return dataList;
  }
}
void _showFilterDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String selectedValue = _selectedOption;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Color(0xFF0f0b53),
            title: Text(
              'Filter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                fontSize: 20.0,
                color: Color(0xFFff5fff),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  dropdownColor: Color(0xFF0f0b53),
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      _selectedOption = newValue;
                      _updateMarker();
                    });
                  },
                  items: <String>['All', 'Auto', 'Manual']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15.0,
                              color: Color(0xFFff5fff),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}




List<String> _getUniquePhoneNumbers() {
  List<String> phoneNumbers = [];

  for (var data in _getFilteredDataList()) {
    String phoneNumber = data['phone number'].toString();

    // Check if the phone number is not already in the list
    if (!phoneNumbers.contains(phoneNumber)) {
      phoneNumbers.add(phoneNumber);
    }
  }

  return phoneNumbers;
}




  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: Icon(Icons.filter_list,
            color: Color(0xFFff5fff),
            
            ),
          ),
        ],
        backgroundColor:const Color(0xFF0f0b53),
        title: const Text('History',
        style: TextStyle(color: Color(0xFFff5fff), 
        fontFamily: 'Poppins', 
        fontWeight: FontWeight.bold,
        fontSize: 20,
        
        ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>  const HomePage(),
            ),
            (route) => false
           
          ),
          color: Color(0xFFff5fff),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.55,
            
        alignment: Alignment.center,
        child: 
          GoogleMap(
            myLocationEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers,
            polylines: Set<Polyline>.of(_polylines),

            ),
        
      ),
      Expanded(
        child: Container(
        color:const  Color(0xFF0f0b53),
        
        child: 
      ListView.builder(
  itemCount: _getFilteredDataList().length,
  itemBuilder: (context, index) {
    final filteredList = _getFilteredDataList();
    final data = filteredList[index];
    bool isManual = data['manual'] == true;

    return Card(
      color: isManual ? const Color(0xFF00ffc4) : const Color(0xFFff5fff),
      elevation: 4,
      child: 
      InkWell(
        
        child: ListTile(
      
        
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3),
            Text(
          'Marker ${_markers.elementAt(index).markerId.value}',
          style: const TextStyle(
            color: Color(0xFF0f0b53),
            fontWeight: FontWeight.bold,
          ),
        ),
          ]
        ),
        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3),
            Text(
              data['timestamp'],
              style: const TextStyle(
                color: Color(0xFF0f0b53),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Lat: ${data['latitude']}',
              style: const TextStyle(
                color: Color(0xFF0f0b53),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Lng: ${data['longitude']}',
              style: const TextStyle(
                color: Color(0xFF0f0b53),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),

          ],
        ),
      ),
      )
      
    );
  },
)
      )
      ),


        ],
      ),

        );
  }

}