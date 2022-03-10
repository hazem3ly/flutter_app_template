import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/authenticator/auth_controller.dart';
import '../../models/authenticator/auth_error_code.dart';
import '../../models/authenticator/sign_with_apple_service.dart';
import '../../utils/utils.dart';
import 'account_setting_page_controller.dart';

/// Appleと連携
class AccountSettingAppleTile extends HookWidget {
  const AccountSettingAppleTile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = useProvider(authControllerProvider);
    final userInfo =
        useProvider(authControllerProvider.notifier).appleUserInfo(user: user);
    return FutureBuilder<bool>(
      future: canSignInWithApple,
      builder: (_, snapshot) {
        if (!snapshot.hasData || !snapshot.data!) {
          return const SizedBox();
        }
        return ListTile(
          leading: const Icon(MdiIcons.apple),
          title: Text(userInfo == null ? 'Apple IDと連携する' : 'Apple IDと連携済み'),
          onTap: () => _presentConfirmDialog(
            context: context,
            hasAppleLinked: userInfo != null,
          ),
        );
      },
    );
  }

  /// Apple連携の確認ダイアログを表示
  Future<void> _presentConfirmDialog({
    required BuildContext context,
    required bool hasAppleLinked,
  }) async {
    final result = await showOkCancelAlertDialog(
        context: context,
        title: hasAppleLinked ? 'Apple IDとの連携を解除しますか？' : 'Apple IDと連携しますか？');
    switch (result) {
      case OkCancelResult.ok:
        return _linkOrUnlinkAccount(context);

      case OkCancelResult.cancel:
        return;
    }
  }

  /// Apple連携or解除
  Future<void> _linkOrUnlinkAccount(BuildContext context) async {
    try {
      final result = await context
          .read(accountSettingPageControllerProvider.notifier)
          .linkOrUnlinkAppleAccount();
      if (result == null) {
        // キャンセルの場合はトースト表示しない
        return;
      }
      // 結果をトースト表示する
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(result)));
    } on FirebaseAuthException catch (exception) {
      // FirebaseAuthの例外処理
      logger.warning(exception);
      switch (exception.code) {
        case AuthErrorCode.credentialAlreadyInUse:
          await showOkAlertDialog(
            context: context,
            title: 'このApple IDは他のユーザーが既に使用しています。',
          );
          return;
        default:
      }
      await showOkAlertDialog(
        context: context,
        title: 'Apple IDの連携または解除に失敗しました',
      );
    } on Exception catch (exception) {
      // その他の例外処理
      logger.warning(exception);
      await showOkAlertDialog(
        context: context,
        title: 'Apple IDの連携または解除に失敗しました',
        message: exception.toString(),
      );
    }
  }
}
