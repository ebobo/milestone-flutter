import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:milestone_flutter/models/cameras.dart';
import 'package:milestone_flutter/services/rest_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milestone - WebRTC',
      theme: ThemeData(
        // This is the theme of this application.
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Milestone CCTV WebRTC Connection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of this application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _cameraVideoRenderer = RTCVideoRenderer();
  final _restService = RestService();
  String _serverUrl = 'http://172.16.1.235';
  String _username = 'qixu';
  String _password = 'Newyear2023!';
  bool _isConnected = false;
  List<Camera> _cameraList = [];
  String _selectedCameraID = '';

  final servelUrlController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    servelUrlController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    servelUrlController.text = _serverUrl;
    userNameController.text = _username;
    passwordController.text = _password;
    _restService.baseUrl = _serverUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const SettingDrawer(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            const Text(
              'Milestone server:',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 295,
                  height: 45,
                  child: TextField(
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      hintText: 'Server URL',
                      filled: true,
                      icon: Icon(Icons.http),
                    ),
                    controller: servelUrlController,
                    onChanged: (String value) {
                      _serverUrl = value;
                    },
                  ),
                ),
                const SizedBox(width: 40),
                Icon(
                  _isConnected ? Icons.done : Icons.question_mark,
                  size: 25,
                  color: _isConnected ? Colors.green : Colors.grey.shade200,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SizedBox(
                width: 155,
                height: 45,
                child: TextField(
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    icon: Icon(Icons.person),
                  ),
                  controller: userNameController,
                  onChanged: (String value) {
                    _username = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 130,
                height: 45,
                child: TextField(
                  autocorrect: false,
                  obscureText: true,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    filled: true,
                  ),
                  controller: passwordController,
                  onChanged: (String value) {
                    _password = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 32,
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                  onPressed: () async {
                    String state = await _restService.signinAPIgateway(
                        _username, _password);
                    setState(() {
                      _isConnected = state == 'Success';
                    });
                    final cameras = await _restService.getCamras();
                    setState(() {
                      _cameraList = cameras;
                    });
                  },
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              height: 32,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                onPressed: () async {
                  String state =
                      await _restService.signinAPIgateway(_username, _password);
                  setState(() {
                    _isConnected = state == 'Success';
                  });
                },
                child: const Text('Connect',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Choose your remote camera:',
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _cameraList.isEmpty ? '' : _cameraList[0].id,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCameraID = newValue!;
                    });
                  },
                  items: _cameraList.map<DropdownMenuItem<String>>((Camera c) {
                    return DropdownMenuItem<String>(
                      value: c.id,
                      child: Text(c.displayName ?? ''),
                    );
                  }).toList(),
                ),
              ],
            ),

            // const SizedBox(height: 20),
            Flexible(
              child: Container(
                key: const Key('cameraView'),
                margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                decoration: const BoxDecoration(color: Colors.black),
                child: RTCVideoView(_cameraVideoRenderer),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingDrawer extends StatelessWidget {
  const SettingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Text('Settings'),
          ),
          ListTile(
            title: const Text('Server Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
