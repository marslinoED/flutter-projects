import 'package:cosmic/shared/app_theme.dart';
import 'package:cosmic/shared/component/components.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(24),
          height: 112,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme().darkBG.withOpacity(0.7),
            borderRadius: BorderRadius.circular(50),
            border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
              right: BorderSide(color: Colors.black.withOpacity(0.4), width: 3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/profile.png',
                        fit: BoxFit.cover,
                        width: 64,
                        height: 64,
                      ),
                      Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          'assets/background/profile_highlight_background.png',
                          fit: BoxFit.cover,
                          width: 64,
                          height: 64,
                        ),
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/background/profile_background.png',
                          fit: BoxFit.cover,
                          width: 64,
                          height: 64,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Marslino Edward", style: AppTheme().bodyMedium),
                  Text("Ai Engineer", style: AppTheme().bodySmall),
                ],
              ),
              Spacer(),
              circularButton(Icon(Icons.edit), Colors.transparent,(){}),
              SizedBox(width: 16),
            ],
          ),
        ),
        SizedBox(height: 16),
        Image.asset('assets/progress.png', fit: BoxFit.cover, width: double.infinity, height: 600),
      ],
    );
  }
}
