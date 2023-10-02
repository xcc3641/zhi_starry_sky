import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:zhi_starry_sky/starry_sky.dart';

class AnimView extends StatelessWidget {
  const AnimView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EasyDynamicTheme.of(context).changeTheme();
        },
        child: Icon(Icons.brightness_6),
      ),
      body: const Center(
        child: StarrySkyView(),
      ),
    );
  }
}
