import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../util/localizer/localizer.dart';
import '../../../util/providers/flavor_provider.dart';
import '../../../util/providers/package_info_provider.dart';

class AppInfoPage extends HookConsumerWidget {
  const AppInfoPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final textTheme = Theme.of(context).textTheme;
    final flavor = ref.watch(flavorProvider);
    final packageInfo = ref.watch(packageInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(Routemaster.of(context).currentRoute.fullPath),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(l10n.title),
              Text('Author is ${l10n.authorName}.'),
              const Text('Developed by Ryunosuke Muramatsu.'),
              const Divider(height: 56),
              Center(child: Text('App Info', style: textTheme.headline2)),
              const Gap(16),
              Text('Flavor', style: textTheme.headline3),
              Text(flavor.name),
              const Gap(32),
              Text('App name', style: textTheme.headline4),
              Text(packageInfo.appName),
              const Gap(32),
              Text('Package name', style: textTheme.headline4),
              Text(packageInfo.packageName),
              const Divider(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
