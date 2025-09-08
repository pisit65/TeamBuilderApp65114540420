import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/pokemon.dart';
import '../controllers/team_controller.dart'; // 👈 เพิ่ม import

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.pokemon.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pokemon.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(widget.pokemon.imageUrl, height: 150),
            const SizedBox(height: 16),
            Text("Type: ${widget.pokemon.type}"),
            Text("HP: ${widget.pokemon.hp}"),
            Text("Attack: ${widget.pokemon.attack}"),
            Text("Defense: ${widget.pokemon.defense}"),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "เปลี่ยนชื่อ",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final newName = _controller.text.trim();
                if (newName.isEmpty) {
                  Get.snackbar("กรอกชื่อ", "กรุณากรอกชื่อก่อนบันทึก");
                  return;
                }

                // ✅ ให้ Controller เป็นคนอัปเดต + refresh ลิสต์
                final teamCtrl = Get.find<TeamController>();
                teamCtrl.renamePokemon(widget.pokemon, newName);

                // อัปเดต title ของหน้านี้ด้วย
                setState(() {});

                Get.snackbar("อัปเดตแล้ว", "เปลี่ยนชื่อเป็น $newName");
              },
              child: const Text("บันทึกชื่อใหม่"),
            ),
          ],
        ),
      ),
    );
  }
}
