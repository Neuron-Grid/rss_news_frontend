import 'package:flutter/material.dart';

class ThemeModeSelection extends StatelessWidget {
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const ThemeModeSelection({super.key, required this.onThemeModeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('テーマ設定'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                onThemeModeChanged(ThemeMode.dark);
              },
              child: const Text('ダークモード'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onThemeModeChanged(ThemeMode.light);
              },
              child: const Text('ライトモード'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onThemeModeChanged(ThemeMode.system);
              },
              child: const Text('システム設定に従う'),
            ),
          ],
        ),
      ),
    );
  }
}
