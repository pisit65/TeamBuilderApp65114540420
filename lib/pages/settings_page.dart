import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final teamCtrl = Get.find<TeamController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename Team'),
            subtitle: Obx(() => Text('Current: ${teamCtrl.teamName.value}')),
            onTap: () {
              final controller = TextEditingController(text: teamCtrl.teamName.value);
              Get.dialog(
                AlertDialog(
                  title: const Text('Rename Team'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter new team name',
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                    ElevatedButton(
                      onPressed: () {
                        teamCtrl.renameTeam(controller.text);
                        Get.back();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Reset Team'),
            onTap: () {
              teamCtrl.resetTeam();
              Get.snackbar('Reset', 'Team cleared!');
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('Pokémon Team Builder App using GetX'),
          ),
        ],
      ),
    );
  }
}
