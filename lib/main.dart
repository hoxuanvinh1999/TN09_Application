import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tn09_app_demo/page/login_page/login_screen.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/blocs/application_bloc.dart';
//import 'widget/button_widget.dart';
import 'widget/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //For Camera
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MainPage(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   static final String title = 'TN09 App Demo';

//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: title,
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: MainPage(),
//       );
// }

class MainPage extends StatefulWidget {
  final CameraDescription camera;
  const MainPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        title: 'Login Page',
        theme: ThemeData(accentColor: Colors.green, primarySwatch: Colors.blue),
        home: LoginScreen(
          camera: widget.camera,
        ),
      ),
    );
  }
}
