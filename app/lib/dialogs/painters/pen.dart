import 'package:butterfly/dialogs/painters/general.dart';
import 'package:butterfly/models/painter.dart';
import 'package:butterfly/models/property.dart';
import 'package:butterfly/visualizer/property.dart';
import 'package:butterfly/widgets/color_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../widgets/exact_slider.dart';

class PenPainterDialog extends StatelessWidget {
  final int painterIndex;

  const PenPainterDialog({super.key, required this.painterIndex});

  @override
  Widget build(BuildContext context) {
    return GeneralPainterDialog<PenPainter>(
        index: painterIndex,
        title: AppLocalizations.of(context)!.pen,
        icon: PhosphorIcons.penLight,
        help: 'pen',
        builder: (context, painter, setPainter) => [
              ExactSlider(
                  header: Text(AppLocalizations.of(context)!.strokeWidth),
                  value: painter.property.strokeWidth,
                  min: 0,
                  max: 70,
                  defaultValue: 5,
                  onChanged: (value) => setPainter(painter.copyWith(
                      property:
                          painter.property.copyWith(strokeWidth: value)))),
              ExactSlider(
                  header: Text(AppLocalizations.of(context)!.strokeMultiplier),
                  value: painter.property.strokeMultiplier,
                  min: 0,
                  max: 70,
                  defaultValue: 5,
                  onChanged: (value) => setPainter(painter.copyWith(
                      property:
                          painter.property.copyWith(strokeMultiplier: value)))),
              const SizedBox(height: 50),
              ColorField(
                color: Color(painter.property.color),
                onChanged: (color) => setPainter(painter.copyWith(
                    property: painter.property.copyWith(color: color.value))),
                title: Text(AppLocalizations.of(context)!.color),
              ),
              ShapeView(
                shape: painter.property.shape,
                onChanged: (shape) => setPainter(painter.copyWith(
                    property: painter.property.copyWith(shape: shape))),
              ),
              const SizedBox(height: 15),
              CheckboxListTile(
                  value: painter.zoomDependent,
                  title: Text(AppLocalizations.of(context)!.zoomDependent),
                  onChanged: (value) => setPainter(painter.copyWith(
                      zoomDependent: value ?? painter.zoomDependent))),
              CheckboxListTile(
                  value: painter.property.fill,
                  title: Text(AppLocalizations.of(context)!.fill),
                  onChanged: (value) => setPainter(painter.copyWith(
                      property: painter.property
                          .copyWith(fill: value ?? painter.property.fill))))
            ]);
  }
}

class ShapeView extends StatefulWidget {
  final PathShape? shape;
  final ValueChanged<PathShape?> onChanged;
  const ShapeView({super.key, required this.shape, required this.onChanged});

  @override
  State<ShapeView> createState() => _ShapeViewState();
}

class _ShapeViewState extends State<ShapeView> {
  PathShape? currentShape;
  bool opened = false;

  @override
  void initState() {
    super.initState();
    currentShape = widget.shape;
  }

  void _onShapeChanged(PathShape? shape) {
    setState(() {
      currentShape = shape;
    });
    widget.onChanged(shape);
  }

  Widget _buildShapeView() {
    final current = currentShape;
    if (current is CircleShape) {
      return _CircleShapeView(shape: current, onChanged: _onShapeChanged);
    }
    if (current is RectangleShape) {
      return _RectangleShapeView(shape: current, onChanged: _onShapeChanged);
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    Widget shapeView = _buildShapeView();

    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          opened = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: opened,
          headerBuilder: (context, expanded) => ListTile(
            title: Text(AppLocalizations.of(context)!.shape),
            trailing: DropdownButton<String>(
              value: widget.shape?.runtimeType.toString() ?? '',
              items: [
                DropdownMenuItem<String>(
                  value: '',
                  onTap: () => _onShapeChanged(null),
                  child: Row(children: [
                    const Icon(PhosphorIcons.xLight),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.none),
                  ]),
                ),
                ...[
                  PathShape.circle,
                  PathShape.rectangle,
                  PathShape.line,
                ].map((e) {
                  var shape = e();
                  return DropdownMenuItem<String>(
                    value: shape.runtimeType.toString(),
                    child: Row(children: [
                      Icon(shape.getIcon()),
                      const SizedBox(width: 8),
                      Text(shape.getLocalizedName(context)),
                    ]),
                    onTap: () => _onShapeChanged(shape),
                  );
                })
              ],
              onChanged: (value) {},
            ),
          ),
          body: shapeView,
        )
      ],
    );
  }
}

class _CircleShapeView extends StatelessWidget {
  final CircleShape shape;
  final ValueChanged<CircleShape> onChanged;
  const _CircleShapeView({required this.shape, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ColorField(
        color: Color(shape.fillColor),
        title: Text(AppLocalizations.of(context)!.fill),
        leading: const Icon(PhosphorIcons.paintBucketLight),
        onChanged: (color) => onChanged(shape.copyWith(fillColor: color.value)),
      ),
    ]);
  }
}

class _RectangleShapeView extends StatelessWidget {
  final RectangleShape shape;
  final ValueChanged<RectangleShape> onChanged;
  const _RectangleShapeView({required this.shape, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ColorField(
        title: Text(AppLocalizations.of(context)!.fill),
        leading: const Icon(PhosphorIcons.paintBucketLight),
        color: Color(shape.fillColor),
        onChanged: (color) => onChanged(shape.copyWith(fillColor: color.value)),
      ),
      ExactSlider(
        defaultValue: 0,
        min: 0,
        max: 100,
        value: shape.cornerRadius,
        header: Text(AppLocalizations.of(context)!.cornerRadius),
        onChanged: (value) => onChanged(shape.copyWith(cornerRadius: value)),
      ),
    ]);
  }
}
