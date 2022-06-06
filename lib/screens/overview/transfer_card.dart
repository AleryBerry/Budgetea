import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:my_app/extension_methods/color.dart";
import "package:my_app/extension_methods/date_time.dart";
import "package:my_app/main.dart";
import "package:my_app/models/currency.dart";
import "package:my_app/models/transaction.dart";

class TransferCard extends StatelessWidget {
  const TransferCard({
    required this.transfer,
    this.onTap,
    this.onLongPress,
    super.key,
  });
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        onLongPress: onLongPress,
        onTap: onTap,
        title: Row(
          children: <Widget>[
            Text(transfer.account1.name),
            const Icon(Icons.arrow_right),
            Text(transfer.account2.name),
          ],
        ),
        leading: transfer.category.getIconData() == null
            ? null
            : Icon(
                transfer.category.getIconData(),
                color: HexColor.fromHex(transfer.category.iconColor),
              ),
        subtitle: Text(
            "${transfer.date.formatStandardWithTime()}\n${transfer.category.name}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20.0 -
                      ((transfer.amount.$1.decimalPoints - 2) * 0.5)
                          .roundToDouble(),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    style: TextStyle(
                      color: transfer.amount.$2 < 0 ? null : Colors.green[300],
                    ),
                    text:
                        "${transfer.amount.$2 > 0 ? "+" : ""}${Constants.formatterCompact(transfer.amount.$1).formatDouble(transfer.amount.$2)}",
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: transfer.amount.$1.iso,
                  ),
                ],
              ),
            ),
            transfer.amount.$1.type == CurrencyType.crypto
                ? CachedNetworkImage(
                    imageUrl: transfer.amount.$1.logoUrl,
                    width: 40,
                    height: 40,
                  )
                : SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        transfer.amount.$1.getEmoji(),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
          ].toList(),
        ),
      ),
    );
  }
}
