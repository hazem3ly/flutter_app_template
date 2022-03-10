import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../util/image_cropper_service.dart';
import '../../util/image_picker_helper.dart';
import '../stock_editor/stock_editor_controller.dart';
import '../stock_editor/stock_editor_page.dart';
import '../stock_editor/stock_editor_parameter.dart';

/// 写真を撮影するボタン
class PhotoShootingButton extends HookConsumerWidget {
  const PhotoShootingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      title: const Icon(MdiIcons.camera),
      subtitle: const Text(
        '写真を撮る',
        textAlign: TextAlign.center,
      ),
      onTap: () => _takePicture(ref, context),
    );
  }

  /// カメラで写真を撮影できる
  Future<void> _takePicture(WidgetRef ref, BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      // カメラ使用拒否されていた場合は設定画面へ促す
      final result = await showOkCancelAlertDialog(
          context: context,
          message: 'カメラへのアクセス許可が必要です。',
          okLabel: '設定を開く',
          cancelLabel: 'キャンセル',
          defaultType: OkCancelAlertDefaultType.ok);
      switch (result) {
        case OkCancelResult.ok:
          await openAppSettings();
          return;
        case OkCancelResult.cancel:
          return;
      }
    }
    // カメラで写真を撮影
    final imageFile = await pickUpImageFromCamera(context);
    if (imageFile == null) {
      // 写真撮影がキャンセルされた時
      return;
    }
    // 写真をクロッピングできる画面を表示し、結果を受け取る
    final croppedFile = await presentImageCroppingView(imageFile);
    if (croppedFile == null) {
      // 写真編集がキャンセルされた時
      return;
    }
    // この時点ではStockItemは作成せず、画像ファイルだけ渡す
    ref.read(stockEditorParameterProvider.state).state =
        StockEditorParameter.createrWithPhoto(imageFile: croppedFile);
    // ストック作成結果画面へ遷移
    await Navigator.of(context).pushNamed(
      StockEditorPage.routeName,
    );
  }
}
