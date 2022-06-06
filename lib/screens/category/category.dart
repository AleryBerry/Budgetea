import "package:flex_color_picker/flex_color_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_iconpicker/flutter_iconpicker.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/extension_methods/color.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Future<bool> colorPickerDialog(BuildContext context,
    ValueNotifier<(Color?, IconPickerIcon?)> dialogPickerColor) async {
  return ColorPicker(
    color: dialogPickerColor.value.$1 ?? Colors.blue,
    onColorChanged: (Color color) {
      dialogPickerColor.value = (color, dialogPickerColor.value.$2);
    },
    width: 40,
    height: 40,
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    heading: Text(
      "Select color",
      style: Theme.of(context).textTheme.titleMedium,
    ),
    subheading: Text(
      "Select color shade",
      style: Theme.of(context).textTheme.titleMedium,
    ),
    wheelSubheading: Text(
      "Selected color and its shades",
      style: Theme.of(context).textTheme.titleMedium,
    ),
    showMaterialName: true,
    showColorName: true,
    showColorCode: false,
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      longPressMenu: true,
    ),
    materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
    colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
    colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
    selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: false,
      ColorPickerType.primary: true,
      ColorPickerType.accent: true,
      ColorPickerType.bw: false,
    },
  ).showPickerDialog(
    context,
    actionsPadding: const EdgeInsets.all(16),
  );
}

class CategoryCreation extends StatelessWidget {
  const CategoryCreation({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController();
    final ValueNotifier<(Color?, IconPickerIcon?)> selectedColorAndIcon =
        ValueNotifier<(Color?, IconPickerIcon?)>((null, null));

    Future<void> submit() async {
      final Database db = BudgeteaDatabase.database!;

      await db.insert(
        "cash_flow_category",
        <String, Object?>{
          "name": name.text,
          "icon_name": selectedColorAndIcon.value.$2?.name,
          "icon_pack": "material",
          "icon_color":
              selectedColorAndIcon.value.$1?.toHex(leadingHashSign: true),
        },
      );
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: name,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                  onFieldSubmitted: (_) => submit(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Icon: "),
                ValueListenableBuilder<(Color?, IconPickerIcon?)>(
                  valueListenable: selectedColorAndIcon,
                  builder: (BuildContext context,
                      (Color?, IconPickerIcon?) colorAndIcon, Widget? _) {
                    return IconButton(
                      iconSize: 44,
                      color: colorAndIcon.$1,
                      onPressed: () async {
                        final IconPickerIcon? pickerIcon =
                            await showIconPicker(context);

                        if (pickerIcon == null) {
                          selectedColorAndIcon.value =
                              (selectedColorAndIcon.value.$1, null);
                        } else {
                          selectedColorAndIcon.value =
                              (selectedColorAndIcon.value.$1, pickerIcon);
                        }
                        if (!context.mounted) return;
                        if (!await colorPickerDialog(
                            context, selectedColorAndIcon)) {
                          selectedColorAndIcon.value =
                              (colorAndIcon.$1, pickerIcon);
                        }
                      },
                      icon: Icon(colorAndIcon.$2?.data ?? Icons.remove),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: submit,
          child: const Text("Ok"),
        ),
      ),
    );
  }
}
