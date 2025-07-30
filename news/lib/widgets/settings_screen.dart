import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NewsCubit.get(context);

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings, size: 80),
              const Text(
                "Settings Screen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: cubit.toggleColorMode,
                    icon: Icon(cubit.isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                  ),
                ],
              ),
              DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Colors.grey[700],
                iconEnabledColor: Colors.deepOrange,
                focusColor: Colors.transparent,

                value: cubit.isEn ? 'en' : 'ar',
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.deepOrange))),
                  DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(color: Colors.deepOrange))),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    cubit.toggleLanguage(newValue);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
