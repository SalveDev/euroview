import 'package:flutter/material.dart';
import 'package:gersa_regionales/Providers/theme_provider.dart';
import 'package:gersa_regionales/Theme/theme.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary(
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: AppIcons.customIcon(context, size: 300, invertMode: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
