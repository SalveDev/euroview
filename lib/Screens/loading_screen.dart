import 'package:flutter/material.dart';
import 'package:euro_euroview/Providers/theme_provider.dart';
import 'package:euro_euroview/Theme/theme.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary(
            Theme.of(context).brightness == Brightness.dark),
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
