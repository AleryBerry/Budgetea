import "dart:async";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/models/dropdown_model.dart";

class SearchableDropDown<T extends DropDownType> extends StatefulWidget {
  const SearchableDropDown({
    super.key,
    required this.label,
    required this.table,
    required this.getType,
    required this.onSelected,
    this.child,
    this.onAdd,
    this.validator,
    this.selectFirst = false,
    this.initialValue,
  });

  final String label;
  final String table;
  final bool selectFirst;
  final List<T> Function(List<Map<String, Object?>>) getType;
  final Widget Function(T)? child;
  final void Function(T?) onSelected;
  final Future<bool> Function()? onAdd;
  final FormFieldValidator<T>? validator;
  final T? initialValue;

  @override
  State<SearchableDropDown<T>> createState() => _SearchableDropDownState<T>();
}

class _SearchableDropDownState<T extends DropDownType>
    extends State<SearchableDropDown<T>> {
  final ValueNotifier<(T?, List<T>)> listenable =
      ValueNotifier<(T?, List<T>)>((null, <T>[]));
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Future<List<T>> loadData() async {
    Database db = BudgeteaDatabase.database!;
    return widget.getType(await db.query(widget.table));
  }

  @override
  void initState() {
    super.initState();
    loadData().then((List<T> result) {
      T? initial;
      if (widget.initialValue != null) {
        initial = result.firstWhereOrNull((T e) => e == widget.initialValue);
      }
      initial ??= widget.selectFirst ? result.firstOrNull : null;

      listenable.value = (initial, result);
      if (initial != null) {
        _textController.text = initial.fullName ?? initial.name;
        if (widget.initialValue == null && widget.selectFirst) {
          widget.onSelected(initial);
        }
      } else {
        widget.onSelected(null);
      }
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {

        Future<void>.delayed(const Duration(milliseconds: 200), () {
          if (!_focusNode.hasFocus) {
            _hideOverlay();
          }
        });
      }
    });

    _textController.addListener(() {
      _overlayEntry?.markNeedsBuild();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant SearchableDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      final T? initial = listenable.value.$2.firstWhereOrNull((T e) => e == widget.initialValue);
      if (initial != null) {
        listenable.value = (initial, listenable.value.$2);
        _textController.text = initial.fullName ?? initial.name;
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
              elevation: 4.0,
              child: ValueListenableBuilder<(T?, List<T>)>(
                valueListenable: listenable,
                builder: (BuildContext context, (T?, List<T>) value, _) {
                  final List<T> filteredList = value.$2
                      .where((T element) => (element.fullName ?? element.name)
                          .toLowerCase()
                          .contains(_textController.text.toLowerCase()))
                      .toList();

                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final T element = filteredList[index];
                        return ListTile(
                          title: widget.child == null
                              ? Text(element.fullName ?? element.name)
                              : widget.child!(element),
                          onTap: () {
                            listenable.value = (element, listenable.value.$2);
                            widget.onSelected(element);
                            _textController.text = element.fullName ?? element.name;
                            _focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> suffixIcons = <Widget>[];
    if (_textController.text.isNotEmpty) {
      suffixIcons.add(
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _textController.clear();
            listenable.value = (null, listenable.value.$2);
            widget.onSelected(null);
            _focusNode.unfocus();
          },
        ),
      );
    }
    if (widget.onAdd != null) {
      suffixIcons.add(
        IconButton(
          onPressed: () async {
            if (await widget.onAdd!()) {
              final List<T> tmp = await loadData();
              setState(() => listenable.value = (listenable.value.$1, tmp));
            }
          },
          icon: const Icon(Icons.add),
        ),
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _textController,
        focusNode: _focusNode,
        validator: (String? value) {
          if (widget.validator != null) {
            return widget.validator!(listenable.value.$1);
          }
          return null;
        },
        onChanged: (String value) {
          // This is to trigger the overlay to rebuild
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          suffixIcon: suffixIcons.isEmpty
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: suffixIcons,
                ),
        ),
      ),
    );
  }
}
