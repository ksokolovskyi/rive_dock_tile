import 'package:flutter/material.dart';
import 'package:rive_dock_tile/rive_dock_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RiveDockTile.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive Dock Tile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 20,
              spacing: 50,
              children: [
                ElevatedButton(
                  onPressed: () {
                    RiveDockTile.instance.start();
                  },
                  child: const Text('START'),
                ),
                ElevatedButton(
                  onPressed: () {
                    RiveDockTile.instance.stop();
                  },
                  child: const Text('STOP'),
                ),
                ElevatedButton(
                  onPressed: () {
                    RiveDockTile.instance.reset();
                  },
                  child: const Text('RESET'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
