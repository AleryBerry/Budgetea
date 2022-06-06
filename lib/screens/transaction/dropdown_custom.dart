import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/models/dropdown_model.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

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
  });

  final String label;
  final String table;
  final bool selectFirst;
  final List<T> Function(List<Map<String, Object?>>) getType;
  final Widget Function(T)? child;
  final void Function(T) onSelected;
  final Future<bool> Function()? onAdd;
  final FormFieldValidator<T>? validator;

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
      if (widget.selectFirst) {
        listenable.value = (result.firstOrNull, result);
        if (listenable.value.$1 != null) {
          widget.onSelected(listenable.value.$1!);
        }
      } else {
        listenable.value = (null, result);
      }
    });
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
