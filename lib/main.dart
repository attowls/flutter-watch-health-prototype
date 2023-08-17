import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<HealthDataPoint> _heartRateData = [];

  @override
  void initState() {
    super.initState();
    _fetchHeartRateData();
  }


  Future<void> _fetchHeartRateData() async {
    print('hello');
    final HealthFactory health = HealthFactory();
    List<HealthDataType> types = [HealthDataType.HEART_RATE];
    bool isAuthorized = await health.requestAuthorization(types);
    if (isAuthorized) {
      try {
        DateTime now = DateTime.now();
        DateTime startDate = DateTime(now.year - 1);
        DateTime endDate = now;

        List<HealthDataPoint> heartRateData =
            await health.getHealthDataFromTypes(
          startDate,
          endDate,
          types,
        );

        setState(() {
          _heartRateData = heartRateData;
        });
        print('hello');
      } catch (e) {
        print("Error fetching heart rate data: $e");
      }
    } else {
      print("Authorization denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Heart Rate Data'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _heartRateData.length,
            itemBuilder: (context, index) {
              HealthDataPoint dataPoint = _heartRateData[index];
              return ListTile(
                title: Text("Heart Rate: ${dataPoint.value} bpm"),
                subtitle: Text("Date: ${dataPoint.dateFrom}"),
              );
            },
          ),
        ),
      ),
    );
  }
}
