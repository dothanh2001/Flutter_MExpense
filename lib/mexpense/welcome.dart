import 'package:flutter/material.dart';

import 'route_names.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.NewTrip);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('M-Expense'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/m-expense.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.blue.shade100.withOpacity(0.8),
            ),
            child: const Text(
              'M-Expense App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    ));
  }
}
