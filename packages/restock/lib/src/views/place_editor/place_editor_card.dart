import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'place_editor_controller.dart';

class PlaceEditorCard extends HookWidget {
  const PlaceEditorCard({
    Key? key,
    required this.index,
    required this.stockCategories,
  }) : super(key: key);

  final int index;
  final List<String> stockCategories;

  @override
  Widget build(BuildContext context) {
    final place = stockCategories[index];
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
      child: ListTile(
        title: Text(place),
        trailing: const Icon(
          Icons.reorder,
        ),
        onTap: () => _onTap(
          context: context,
          place: place,
        ),
      ),
    );
  }

  /// カードをタップしたときの動作
  Future<void> _onTap({
    required BuildContext context,
    required String place,
  }) async {
    // グループをテキスト入力して変更できる
    final results = await showTextInputDialog(
      context: context,
      title: 'グループ名を変更',
      message: '1文字以上10文字以内でご入力ください',
      okLabel: '変更',
      textFields: [
        DialogTextField(
          initialText: place,
          hintText: 'グループ名を入力',
          validator: (value) {
            if (value!.isEmpty) {
              return '1文字以上入力ください';
            }
            if (value.length > 10) {
              return '10文字以下で入力ください';
            }
            return null;
          },
        ),
      ],
    );
    if (results == null) {
      // キャンセルパターン
      return;
    }
    // 保管場所名を更新
    stockCategories[index] = results.first;
    // 新しいリストで全置換え
    context
        .read(placeEditorPageProvider.notifier)
        .updateCategories(stockCategories);
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('ニックネームを変更しました')),
      );
  }
}
