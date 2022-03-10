import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_widgets/primary_button.dart';
import '../../util/shared_preferences_service.dart';
import 'stock_display_mode.dart';
import 'stock_filter_page/stock_filter_page.dart';
import 'stock_list_page_providers.dart';

class StockListTopArea extends HookWidget {
  const StockListTopArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchText = useProvider(searchTextProvider).state;
    final textEditingController = useTextEditingController(text: searchText);
    final tabController = DefaultTabController.of(context);

    void tabControllerListener() {
      if (tabController != null) {
        context.read(selectedTabIndexProvider).state = tabController.index;
      }
    }

    useEffect(
      () {
        tabController?.addListener(tabControllerListener);
        return () => tabController?.removeListener(tabControllerListener);
      },
      [tabController],
    );
    final selectedTabIndex = useProvider(selectedTabIndexProvider).state;
    final groups = useProvider(stockCategoriesProvider);
    final group = selectedTabIndex == 0 ? null : groups![selectedTabIndex - 1];
    final stockCount = useProvider(stockCountProvider(group));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) =>
                        context.read(searchTextProvider).state = text,
                    style: Theme.of(context).textTheme.subtitle2,
                    decoration: InputDecoration(
                      hintText: '検索',
                      hintStyle: Theme.of(context).textTheme.caption,
                      filled: true,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchText.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                context.read(searchTextProvider).state = '';
                                textEditingController.clear();
                              },
                            ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(64)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PrimaryButton(
                  padding: EdgeInsets.zero,
                  iconData: Icons.filter_alt,
                  labelText: '表示条件',
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => const StockFilterPage(),
                    elevation: 3,
                    backgroundColor: Theme.of(context).backgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stockCount == null ? '' : '$stockCount件のストック',
                style: Theme.of(context).textTheme.caption,
              ),
              const _ModeSelector(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeSelector extends HookWidget {
  const _ModeSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        _ChoiceChip(displayMode: StockDisplayMode.list),
        SizedBox(width: 8),
        _ChoiceChip(displayMode: StockDisplayMode.grid),
      ],
    );
  }
}

class _ChoiceChip extends HookWidget {
  const _ChoiceChip({
    Key? key,
    required this.displayMode,
  }) : super(key: key);

  final StockDisplayMode displayMode;

  @override
  Widget build(BuildContext context) {
    final currentMode = useProvider(displayModeProvider).state;
    return ChoiceChip(
      label: Icon(
        displayMode.iconData,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      selected: currentMode == displayMode,
      onSelected: (isOn) {
        if (isOn) {
          context.read(displayModeProvider).state = displayMode;
          context
              .read(sharedPreferencesServiceProvider)
              .saveStockDisplayMode(mode: displayMode);
        }
      },
    );
  }
}
