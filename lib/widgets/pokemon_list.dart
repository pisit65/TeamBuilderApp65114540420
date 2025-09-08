// lib/widgets/pokemon_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../models/pokemon.dart';
import '../pages/pokemon_detail_page.dart';

class PokemonList extends StatelessWidget {
  PokemonList({super.key});

  final TeamController teamCtrl = Get.find<TeamController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ ใช้ getter ที่มีอยู่จริงใน TeamController
      final List<Pokemon> list = teamCtrl.filtered;

      if (list.isEmpty) {
        return const Center(child: Text('No Pokémon'));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          final Pokemon p = list[i];
          final bool inTeam = teamCtrl.selected(p); // ✅ เมธอดที่มีจริง

          return ListTile(
            leading: Image.network(p.imageUrl, width: 48, height: 48),
            title: Text(p.name),
            subtitle: Text('#${p.id}'),
            // 👉 แตะรายการเพื่อไปหน้าแก้ชื่อ
            onTap: () => Get.to(() => PokemonDetailPage(pokemon: p)),
            // ปุ่มขวา: เพิ่ม/เอาออกจากทีม
            trailing: IconButton(
              icon: Icon(inTeam ? Icons.check_circle : Icons.add_circle_outline),
              onPressed: () => teamCtrl.togglePokemon(p), // ✅ toggle ที่มีจริง
            ),
          );
        },
      );
    });
  }
}
