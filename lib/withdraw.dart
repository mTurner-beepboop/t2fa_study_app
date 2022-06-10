import 'package:flutter/material.dart';

//TODO - Implement a way to withdraw from the study (probably just send in a request to firebase with id of participant and such)

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
      ),
      body: const Text("Here will be the method of withdrawal/a button to do it automatically"),
    );
  }
}
