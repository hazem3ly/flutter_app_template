import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sender/notification_sender.dart';

import '../../utils/utils.dart';

class NotificationGuideDialog extends ConsumerWidget {
  // Constructor
  const NotificationGuideDialog();

  // Field
  static const String routeName = '/notification-guide';

  // Methods
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: ListBody(
            children: <Widget>[
              Image.asset('assets/images/notification_image.png'),
              const SizedBox(height: 8),
              Text(
                '通知の許可',
                style: theme.textTheme.headline6,
              ),
              const SizedBox(height: 8),
              Text(
                'ストックの期限を通知でお知らせ♪\n\nアプリを便利に使うためには、通知の「許可」がオススメです。',
                style: theme.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          // TODO(Aimiee): paddingの設定
          // padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
          onPressed: () {
            // ダイアログを閉じて、拒否されたことを伝える
            Navigator.of(context).pop(false);
          },
          child: const Text('あとで'),
        ),
        ElevatedButton(
          child: const Text('受け取る'),
          onPressed: () async {
            logger.finest('訴求ダイアログの通知を受け取るアクションが選択されました');
            // iOSの通知の許可を得るためのOS標準ダイアログを表示する
            final result = await ref
                .read(notificationSenderProvider.notifier)
                .requestPermissionForApple();
            logger.fine('通知の許可： $result');
            // ダイアログを閉じて、許可/拒否の結果を伝える
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }
}
