import 'package:flutter/material.dart';
import 'dart:math';

/// Widget handle Multi Select Dropdown [MultiSelectDropdownMenu]
class MultiSelectDropdownMenu<T> extends FormField<T> {
  final List<T> items;
  final bool filter;
  final double maxHeight;
  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final T initialValue;
  final bool autovalidate;
  final bool enabled;

  MultiSelectDropdownMenu({
    @required this.items,
    this.filter = false,
    this.maxHeight = 250,
    this.onSaved,
    this.initialValue,
    this.validator,
    this.autovalidate = false,
    this.enabled = true,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            enabled: enabled,
            builder: (
              FormFieldState<T> state,
            ) {
              final _MultiSelectDropdownMenuState<T> fieldState =
                  state as _MultiSelectDropdownMenuState<T>;
              return Container(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: InputDecorator(
                    child: Text('adads'),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  onTap: () {
                    // Get current input render box
                    final RenderBox inputBox =
                        fieldState.context.findRenderObject();
                    // Cast to rect with global position
                    final Rect inputRect =
                        inputBox.localToGlobal(Offset.zero) & inputBox.size;
                    Navigator.of(fieldState.context).push(
                      _MultiSelectDropdownRoute(
                        child: Material(
                          child: Container(
                            height: 600,
                            child: ListView.separated(
                              itemCount: items.length,
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (context, index) {
                                final key = items[index];
                                return ListTile(
                                  leading: Checkbox(
                                    value: fieldState.itemDictionary[key],
                                    onChanged: (checked) {
//                                DropdownButtonFormField
                                      fieldState.updateCheckbox(key, checked);
                                    },
                                  ),
                                  title: Text('$e'),
                                );
                              },
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: kElevationToShadow[9],
                            ),
                          ),
                        ),
                        inputRect: inputRect,
                        maxHeight: maxHeight,
                        filter: filter,
                      ),
                    );
                  },
                ),
              );
            });

  @override
  _MultiSelectDropdownMenuState<T> createState() =>
      _MultiSelectDropdownMenuState<T>();
}

class _MultiSelectDropdownMenuState<T> extends FormFieldState<T> {
  Map<T, bool> _itemDictionary;

  @override
  MultiSelectDropdownMenu<T> get widget =>
      super.widget as MultiSelectDropdownMenu;

  @override
  void initState() {
    super.initState();
    _itemDictionary =
        Map.fromIterable(widget.items, key: (e) => e, value: (e) => false);
  }

  get itemDictionary {
    return _itemDictionary;
  }

  updateCheckbox(T key, bool value) {
    _itemDictionary[key] = value;
    super.didChange(key);
  }
}

/// Create a popup route to push on top of stack
/// Get available constraint with [LayoutBuilder]
class _MultiSelectDropdownRoute extends PopupRoute {
  /// Child to render inside [Popup]
  Widget child;

  /// Coordinate, width and height of the [inputRect]
  /// Base on current coordinate we can decide where to render the [Popup]
  Rect inputRect;
  bool filter;
  double maxHeight;

  _MultiSelectDropdownRoute(
      {@required this.child,
      @required this.inputRect,
      this.filter,
      this.maxHeight});

  /// Color for the barrier, can set color to see the barrier area
  @override
  Color get barrierColor => null;

  /// When tap outside Current Route will be pop of the Stack
  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _MultiSelectDropdownPage(
          child: child,
          constraints: constraints,
          inputRect: inputRect,
          filter: filter,
          maxHeight: maxHeight,
        );
      },
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  String get barrierLabel => 'BarrierLabel';
}

class _MultiSelectDropdownPage extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget child;
  final Rect inputRect;
  final bool filter;
  final double maxHeight;

  _MultiSelectDropdownPage(
      {this.constraints,
      this.child,
      this.inputRect,
      this.filter,
      this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _MultiSelectDropdownDelegate(
        inputRect: inputRect,
        filter: filter,
        maxHeight: maxHeight,
      ),
      child: child,
    );
  }
}

class _MultiSelectDropdownDelegate extends SingleChildLayoutDelegate {
  final Rect inputRect;
  final bool filter;
  final double maxHeight;

  _MultiSelectDropdownDelegate(
      {@required this.inputRect, this.filter, this.maxHeight});

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    print(size);
    print(childSize);
    // Start at 1 / 3 of input height
    double y = inputRect.top + inputRect.height / 3;
    double height = y + maxHeight;
    // Not enough space move y to the top
    if (height > size.height) {
      y = max(0, inputRect.top - childSize.height);
    }
    double x = inputRect.left;
    return Offset(x, y);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Given constraint for child
    // Adjust dimension of child
    // Make popup width bigger than itself
    double width = min(constraints.maxWidth, inputRect.width * 1.1);
    return BoxConstraints(
        maxHeight: maxHeight, minHeight: 0, minWidth: width, maxWidth: width);
  }
}
