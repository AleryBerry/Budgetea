import "package:flutter/material.dart";
import "package:my_app/l10n/app_localizations.dart";

Future<bool> alertDialogAsk(BuildContext context, String question) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(question),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.yes),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.no),
              ),
            ],
          );
        },
      ) ??
      false;
}
