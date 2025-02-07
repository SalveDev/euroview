import 'package:flutter/material.dart';
import 'package:gersa_regionales/Theme/theme.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Container(
                child: AppIcons.customIcon(context, size: 300),
            ),
            SizedBox(height: 20),
            Text(
              "Cargando...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}