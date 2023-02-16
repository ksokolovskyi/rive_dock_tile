import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:screen_retriever/screen_retriever.dart';

class RiveDockTile {
  RiveDockTile._();

  static final RiveDockTile instance = RiveDockTile._();

  static const _channel = MethodChannel('dock_tile');
  static const _side = 128.0;
  static const _pixelRatio = 2.0;

  final Stopwatch _stopwatch = Stopwatch();

  Artboard? _artboard;
  StateMachineController? _stateController;
  SimpleAnimation? _blinkController;
  Timer? _timer;
  Size? _screenSize;

  Future<void> init() async {
    _screenSize = (await screenRetriever.getPrimaryDisplay()).size;

    final file = await RiveFile.asset('assets/eye_icon.riv');

    final artboard = file.mainArtboard.instance();
    _artboard = artboard;

    final stateController = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    )!;
    _stateController = stateController;
    artboard.addController(stateController);

    final blinkController = SimpleAnimation('Blink');
    _blinkController = blinkController;
    artboard.addController(blinkController);
  }

  Future<void> start() async {
    if (_timer != null) {
      return;
    }

    final artboard = _artboard;
    final stateController = _stateController;

    if (artboard == null || stateController == null) {
      throw const FormatException('init() method should be called first');
    }

    _timer = Timer.periodic(
      const Duration(microseconds: 16666),
      (_) async {
        final position = await screenRetriever.getCursorScreenPoint();
        final x = (position.dx * 130) / (_screenSize?.width ?? 0);
        final y = (position.dy * 130) / (_screenSize?.height ?? 0) / 1.85;

        stateController.pointerMove(
          Vec2D.fromValues(x, y),
        );

        final elapsedSeconds = _stopwatch.elapsedTicks / _stopwatch.frequency;

        _stopwatch.reset();
        _stopwatch.start();

        artboard.advance(elapsedSeconds);

        final bounds = Rect.fromPoints(
          const Offset(0.0, 0.0),
          const Offset(_side, _side),
        );

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder, bounds);

        final transform = Matrix4.diagonal3Values(
          _pixelRatio,
          _pixelRatio,
          1,
        );
        transform.translate(-bounds.left, -bounds.top);
        canvas.transform(transform.storage);

        artboard.artboard.draw(canvas);

        final picture = recorder.endRecording();

        final img = await picture.toImage(
          (_pixelRatio * bounds.width).ceil(),
          (_pixelRatio * bounds.height).ceil(),
        );

        final bytes = await img.toByteData(
          format: ImageByteFormat.png,
        );

        await _syncDockTile(bytes!.buffer.asUint8List());
      },
    );
  }

  Future<void> reset() async {
    final stateController = _stateController;
    final blinkController = _blinkController;

    if (stateController == null || blinkController == null) {
      throw const FormatException('init() method should be called first');
    }

    stateController.pointerMove(
      Vec2D.fromValues(_side / 2, _side / 2),
    );

    blinkController.reset();

    await stop();
    await _resetDockTile();
  }

  Future<void> stop() async {
    _stopwatch.reset();
    _stopwatch.stop();

    _timer?.cancel();
    _timer = null;
  }

  Future<void> _syncDockTile(Uint8List bytes) async {
    await _channel.invokeMethod('sync', bytes);
  }

  Future<void> _resetDockTile() async {
    await _channel.invokeMethod('reset', null);
  }
}
