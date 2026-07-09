import "package:flutter/material.dart";
import "package:my_app/data_base/budgetea_database.dart";
import "package:my_app/l10n/app_localizations.dart";
import "package:my_app/models/account.dart";
import "package:my_app/models/transaction.dart";
import "package:my_app/screens/accounts/accounts.dart";
import "package:intl/intl.dart";

class TransferDetails extends StatelessWidget {
  const TransferDetails({super.key, required this.transfer});
  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.view_details),
      ),
      body: FutureBuilder<(Account, Account)?>(
        future: (() async {
          final Database db = BudgeteaDatabase.database!;
          final Map<String, Object?>? acc1Json = (await db.query(
            "account",
            where: "id = ${transfer.account1.id}",
            limit: 1,
          )).firstOrNull;
          final Map<String, Object?>? acc2Json = (await db.query(
            "account",
            where: "id = ${transfer.account2.id}",
            limit: 1,
          )).firstOrNull;

          if (acc1Json == null || acc2Json == null) {
            return null;
          }
          return (
            Account.fromJson(acc1Json),
            Account.fromJson(acc2Json),
          );
        })(),
        builder: (BuildContext context, AsyncSnapshot<(Account, Account)?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Data not found"));
          }
          
          final Account origin = snapshot.data!.$1;
          final Account target = snapshot.data!.$2;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.transfer,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(child: AccountTile(account: origin)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Icon(Icons.arrow_forward),
                          ),
                          Expanded(child: AccountTile(account: target)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Amount",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${transfer.amount.$1.symbol} ${transfer.amount.$2.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Date",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMd(AppLocalizations.of(context)!.localeName).add_jm().format(transfer.date),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (transfer.observacion.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.description,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transfer.observacion,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
