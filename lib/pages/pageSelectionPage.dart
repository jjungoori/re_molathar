import 'package:flutter/material.dart';

class PageSelectionPage extends StatelessWidget {
  const PageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/server');
          },
          child: Text('Server'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/client');
          },
          child: Text('Client'),
        ),
      ],
    );
  }
}
