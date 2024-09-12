import 'package:butterfly/cubits/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BehaviorsSettingsPage extends StatelessWidget {
  final bool inView;

  const BehaviorsSettingsPage({super.key, this.inView = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inView ? Colors.transparent : null,
      appBar: WindowTitleBar<SettingsCubit, ButterflySettings>(
        title: Text(AppLocalizations.of(context).inputs),
        backgroundColor: inView ? Colors.transparent : null,
        inView: inView,
      ),
      body: BlocBuilder<SettingsCubit, ButterflySettings>(
          builder: (context, state) {
        return ListView(children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SwitchListTile(
                      value: state.autosave,
                      title: Text(AppLocalizations.of(context).autosave),
                      secondary:
                          const PhosphorIcon(PhosphorIconsLight.floppyDisk),
                      onChanged: (value) =>
                          context.read<SettingsCubit>().changeAutosave(value),
                    ),
                    SwitchListTile(
                      value: state.hideCursorWhileDrawing,
                      title: Text(
                          AppLocalizations.of(context).hideCursorWhileDrawing),
                      secondary:
                          const PhosphorIcon(PhosphorIconsLight.cursorClick),
                      onChanged: (value) => context
                          .read<SettingsCubit>()
                          .changeHideCursorWhileDrawing(value),
                    ),
                  ]),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(AppLocalizations.of(context).import,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: state.spreadPages,
                      secondary: const PhosphorIcon(
                          PhosphorIconsLight.arrowsOutSimple),
                      title: Text(AppLocalizations.of(context).spreadToPages),
                      onChanged: (value) => context
                          .read<SettingsCubit>()
                          .changeSpreadPages(value),
                    ),
                    const SizedBox(height: 8),
                    ExactSlider(
                      header: Text(AppLocalizations.of(context).imageScale),
                      leading:
                          const PhosphorIcon(PhosphorIconsLight.frameCorners),
                      value: state.imageScale * 100,
                      min: 0,
                      max: 100,
                      defaultValue: 50,
                      fractionDigits: 0,
                      onChangeEnd: (value) => context
                          .read<SettingsCubit>()
                          .changeImageScale(value / 100),
                    ),
                    ExactSlider(
                      leading:
                          const PhosphorIcon(PhosphorIconsLight.flowerLotus),
                      header: Text(AppLocalizations.of(context).pdfQuality),
                      value: state.pdfQuality,
                      min: 0.5,
                      max: 10,
                      defaultValue: 2,
                      onChangeEnd: (value) =>
                          context.read<SettingsCubit>().changePdfQuality(value),
                    ),
                  ]),
            ),
          ),
        ]);
      }),
    );
  }
}
