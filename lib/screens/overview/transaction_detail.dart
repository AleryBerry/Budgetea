import "package:flutter/material.dart";

class DetailTransaction extends StatefulWidget {
  const DetailTransaction({super.key, required this.amount});
  final double amount;
  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ))
          ],
          title: const Text(
            "Budgetea",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Text(widget.amount.toString()),
        ));
  }
}
