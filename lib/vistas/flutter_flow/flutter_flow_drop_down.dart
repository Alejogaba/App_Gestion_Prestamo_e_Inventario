import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlutterFlowDropDown<T> extends StatefulWidget {
  const FlutterFlowDropDown({
    this.initialOption,
    this.hintText,
    required this.options,
    this.optionLabels,
    required this.onChanged,
    this.icon,
    this.width,
    this.height,
    this.fillColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    required this.value,
    this.hidesUnderline = false,
    this.disabled = false,
  });

  final T? initialOption;
  final String? hintText;
  final List<DropdownMenuItem<T>> options;
  final List<String>? optionLabels;
  final Function(T?) onChanged;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color? fillColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;
  final bool disabled;
  final T? value;

  @override
  State<FlutterFlowDropDown<T>> createState() => _FlutterFlowDropDownState<T>();
}

class _FlutterFlowDropDownState<T> extends State<FlutterFlowDropDown<T>> {
  T? dropDownValue;

  @override
  void initState() {
    super.initState();
    dropDownValue = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = DropdownButton<T>(
      value: widget.value,
      hint: widget.hintText != null
          ? Text(widget.hintText!, style: widget.textStyle)
          : null,
      items: widget.options,
      elevation: widget.elevation.toInt(),
      onChanged: !widget.disabled
          ? (value) {
              dropDownValue = value;
              widget.onChanged(value);
            }
          : null,
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: widget.fillColor,
      focusColor: Colors.transparent,
    );
    final childWidget = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        color: widget.fillColor,
      ),
      child: Padding(
        padding: widget.margin,
        child: widget.hidesUnderline
            ? DropdownButtonHideUnderline(child: dropdownWidget)
            : dropdownWidget,
      ),
    );
    if (widget.height != null || widget.width != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        child: childWidget,
      );
    }
    return childWidget;
  }
}
