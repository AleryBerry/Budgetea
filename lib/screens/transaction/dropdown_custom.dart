import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/models/dropdown_model.dart";

class DropDownCustom<T extends DropDownType> extends StatefulWidget {
  const DropDownCustom({
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
  final void Function(T) onSelected;
  final Future<bool> Function()? onAdd;
  final FormFieldValidator<T>? validator;
  final T? initialValue;

  @override
  State<DropDownCustom<T>> createState() => _DropDownCustomState<T>();
}

class _DropDownCustomState<T extends DropDownType>
    extends State<DropDownCustom<T>> {
  ValueNotifier<(T?, List<T>)> listenable =
      ValueNotifier<(T?, List<T>)>((null, <T>[]));

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
      if (initial != null && widget.initialValue == null && widget.selectFirst) {
        widget.onSelected(initial);
      }
    });
  }

  @override
  void didUpdateWidget(covariant DropDownCustom<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      final T? initial = listenable.value.$2.firstWhereOrNull((T e) => e == widget.initialValue);
      if (initial != null) {
        listenable.value = (initial, listenable.value.$2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<(T?, List<T>)>(
      valueListenable: listenable,
      builder: (BuildContext context, (T?, List<T>) value, _) {
        return DropdownButtonFormField<T>(
          validator: widget.validator,
          onChanged: (T? value) {
            listenable.value = (value, listenable.value.$2);
            if (value != null) widget.onSelected(value);
          },
          value: value.$1,
          items: listenable.value.$2
              .map(
                (T element) => DropdownMenuItem<T>(
                  value: element,
                  child: widget.child == null
                      ? ClipRect(child: Text(element.name))
                      : ClipRect(child: widget.child!(element)),
                ),
              )
              .toList(),
          isExpanded: true,
          decoration: InputDecoration(
            suffixIcon: widget.onAdd == null
                ? null
                : IconButton(
                    onPressed: () async {
                      if (await widget.onAdd!()) {
                        final List<T> tmp = await loadData();
                        setState(() =>
                            listenable.value = (listenable.value.$1, tmp));
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
            border: const OutlineInputBorder(),
            labelText: widget.label,
          ),
        );
      },
    );
  }
}
