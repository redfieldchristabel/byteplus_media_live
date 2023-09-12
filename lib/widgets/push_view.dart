import 'package:byteplus_media_live/models/push_engine_controller.dart';
import 'package:byteplus_media_live/models/push_player_option.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class PushView extends StatelessWidget {
  const PushView(
      {super.key, this.option = const PushPlayerOption(), this.controller});

  final PushEngineController? controller;

  final PushPlayerOption option;

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'byteplus_push';
    // // Pass parameters to the platform side.
    // const Map<String, dynamic> creationParams = <String, dynamic>{};

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (context, viewController) {
        controller?.initialize(viewController.viewId);

        return AndroidViewSurface(
          controller: viewController as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: option.toJsonRaw(),
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}
