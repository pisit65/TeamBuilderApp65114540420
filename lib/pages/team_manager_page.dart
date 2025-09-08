import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../models/pokemon.dart';

class TeamManagerPage extends StatelessWidget {
  TeamManagerPage({super.key});

  final teamCtrl = Get.find<TeamController>();
  static const slots = ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Teams (A / B / C)')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: slots.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final slot = slots[i];
          return _SlotCard(slot: slot);
        },
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.slot, super.key});
  final String slot;

  @override
  Widget build(BuildContext context) {
    final teamCtrl = Get.find<TeamController>();

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // หัวการ์ด + ปุ่มเปลี่ยนชื่อ (Obx เฉพาะจุดที่อ่าน Rx)
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final label = teamCtrl.teamLabels[slot] ?? slot;
                    final members = teamCtrl.savedTeams[slot] ?? <Pokemon>[];
                    return Text(
                      '$label  (${members.length}/3)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    );
                  }),
                ),
                IconButton(
                  tooltip: 'Rename',
                  icon: const Icon(Icons.edit),
                  onPressed: () => _openRenameDialog(slot),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // แสดงสมาชิก (Obx เฉพาะรายชื่อ)
            Obx(() {
              final members = teamCtrl.savedTeams[slot] ?? <Pokemon>[];
              if (members.isEmpty) return const Text('Empty slot');
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: members.map((p) {
                  return Chip(
                    avatar: CircleAvatar(backgroundImage: NetworkImage(p.imageUrl)),
                    label: Text(p.name),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 12),

            // ปุ่ม Save/Load (อ่าน Rx ผ่าน action ไม่ต้อง Obx)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => teamCtrl.saveCurrentToSlot(slot),
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save current → slot'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => teamCtrl.loadSlot(slot),
                    icon: const Icon(Icons.upload),
                    label: const Text('Load slot → current'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openRenameDialog(String slot) {
    final teamCtrl = Get.find<TeamController>();
    final current = teamCtrl.teamLabels[slot] ?? slot;
    final c = TextEditingController(text: current);
    Get.dialog(
      AlertDialog(
        title: Text('Rename $current'),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter new name',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              teamCtrl.renameSlot(slot, c.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
