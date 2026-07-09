import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/models/constants.dart';
import 'package:my_app/screens/transaction/cashflow_add.dart';
import 'package:my_app/screens/transaction/transaction_form.dart';

class HomeFab extends StatelessWidget {
  final VoidCallback onDataChanged;
  const HomeFab({super.key, required this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      renderOverlay: false,
      icon: Icons.add,
      spacing: 12,
      animatedIcon: AnimatedIcons.menu_close,
      spaceBetweenChildren: 15,
      children: <SpeedDialChild>[
        SpeedDialChild(
          child: const Icon(Icons.compare_arrows),
          label: AppLocalizations.of(context)!.transfer,
          onTap: () async {
            final bool result = await Navigator.push<bool>(
                  context,
                  PageRouteBuilder<bool>(
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                    pageBuilder: (context, _, __) => TransactionForm(),
                  ),
                ) ??
                false;
            if (result) {
              onDataChanged();
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.arrow_upward),
          label: AppLocalizations.of(context)!.withdrawal,
          onTap: () async {
            final bool result = await Navigator.push<bool>(
                  context,
                  PageRouteBuilder<bool>(
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                    pageBuilder: (context, _, __) => CashFlowForm(type: TransactionType.gasto),
                  ),
                ) ??
                false;
            if (result) {
              onDataChanged();
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.arrow_downward),
          label: AppLocalizations.of(context)!.deposit,
          onTap: () async {
            final bool result = await Navigator.push<bool>(
                  context,
                  PageRouteBuilder<bool>(
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                    pageBuilder: (context, _, __) => CashFlowForm(type: TransactionType.ingreso),
                  ),
                ) ??
                false;
            if (result) {
              onDataChanged();
            }
          },
        )
      ],
    );
  }
}
