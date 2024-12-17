import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NativeBattery(),
    );
  }
}

class NativeBattery extends StatelessWidget {
  const NativeBattery({super.key});
  static const platform = MethodChannel("batterycheck");

  Future<String> getBatteryLevel() async{
    try {
      final int batteryLevel = await platform.invokeMethod('getBattery');
      return "batter level : $batteryLevel";
    } on PlatformException catch (e) {
      return "failed to get battery level : ${e.message}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getBatteryLevel(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }else{
                return Text('battery percentage ${snapshot.data}' ?? "unknown battery");
              }
            },),
      ),
    );
  }
}
