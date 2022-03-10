import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_widgets/list_section_header.dart';
import '../../common_widgets/loading_indicator.dart';
import '../../core/me/me.dart';
import '../../models/authenticator/auth_controller.dart';
import '../../utils/build_mode.dart';
import '../pro_plan/pro_plan_page.dart';
import 'account_setting_apple_tile.dart';
import 'account_setting_google_tile.dart';
import 'account_setting_log_out_tile.dart';
import 'account_setting_nickname_tile.dart';
import 'account_setting_page_controller.dart';
import 'account_setting_quit_tile.dart';

class AccountSettingPage extends HookWidget {
  const AccountSettingPage({
    Key? key,
  }) : super(key: key);

  static const String routeName = '/account-setting';

  // Methods
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    final authController = useProvider(authControllerProvider.notifier);
    final user = useProvider(authControllerProvider);
    return LoadingIndicator(
      loading: useProvider(accountSettingPageControllerProvider).loading,
      child: Scaffold(
        appBar: AppBar(title: const Text('アカウント設定')),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              const ListSectionHeader(
                title: 'ニックネームは「みんなのストック」等で公開されます。',
              ),
              const _Cell(child: AccountSettingNicknameTile()),
              // TODO(Aimiee): Functionsをデプロイできていないため、Releseaモード時では非表示
              if (useProvider(buildModeProvider).isDebug)
                const SizedBox(height: 16),
              if (useProvider(buildModeProvider).isDebug)
                const _StockVisibilityToggleCell(),
              ListSectionHeader(
                title: authController.isAnonymous(user: user)
                    ? '機種変更でのデータ引き継ぎ、デバイス間のデータ共有が可能になります。'
                    : 'アカウント連携',
              ),
              const _Cell(child: AccountSettingAppleTile()),
              const _Cell(child: AccountSettingGoogleTile()),
              ListSectionHeader(
                title: authController.isAnonymous(user: user)
                    ? 'アカウント連携をせずに削除するとデータの復元はできません。'
                    : 'ログアウト・削除',
              ),
              const _Cell(child: AccountSettingLogOutTile()),
              const _Cell(child: AccountSettingQuitTile()),
            ],
          ),
        ),
      ),
    );
  }
}

/// マイストックの可視性を変更できるセル
class _StockVisibilityToggleCell extends HookWidget {
  const _StockVisibilityToggleCell({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPrivateMyStock =
        useProvider(meEntityProvider.select((v) => v?.isPrivateMyStock));
    return ColoredBox(
      color: Theme.of(context).cardColor,
      child: SwitchListTile.adaptive(
        value: isPrivateMyStock ?? false,
        onChanged: isPrivateMyStock == null
            ? null
            : (isOn) => _switchChanged(
                  context: context,
                  isOn: isOn,
                ),
        title: const Text('ストックを非公開にする'),
        subtitle: const Text('「みんなのストック」で非表示になります'),
        secondary: const Icon(Icons.privacy_tip_rounded),
        dense: true,
      ),
    );
  }

  /// ストックを非公開にするのトグル
  Future<void> _switchChanged({
    required BuildContext context,
    required bool isOn,
  }) async {
    //
    final errorString = await context
        .read(accountSettingPageControllerProvider.notifier)
        .togglePrivateStockSwitch(isPrivate: isOn);

    if (errorString != null) {
      final result = await showOkCancelAlertDialog(
        context: context,
        // title: 'マイストックの非公開機能は',
        message: errorString,
        okLabel: 'Proプランとは',
        defaultType: OkCancelAlertDefaultType.ok,
      );
      if (result == OkCancelResult.ok) {
        await Navigator.of(context).pushNamed(ProPlanPage.routeName);
      }
    }
  }
}

/// タイル共通で使う
class _Cell extends StatelessWidget {
  const _Cell({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).cardColor,
      child: child,
    );
  }
}
