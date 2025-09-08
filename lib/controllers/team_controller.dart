import 'package:get/get.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  final ApiService api = Get.find<ApiService>();

  final RxString teamName = 'Pokémon Team Builder'.obs;
  final RxList<Pokemon> pokemons = <Pokemon>[].obs;
  final RxList<Pokemon> team = <Pokemon>[].obs;
  final RxString query = ''.obs;
  final RxBool isLoading = false.obs;

  bool get isFull => team.length >= 3;

  @override
  void onInit() {
    super.onInit();
    loadPokemons(limit: 151);
  }

  Future<void> loadPokemons({int limit = 151}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final list = await api.fetchPokemons(limit: limit);
      pokemons.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  List<Pokemon> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return pokemons;
    return pokemons.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  void setQuery(String q) => query.value = q;

  bool selected(Pokemon p) => team.contains(p);

  void togglePokemon(Pokemon p) {
    if (selected(p)) {
      team.remove(p);
    } else {
      if (isFull) {
        Get.snackbar("Limit Reached", "You can only choose 3 Pokémon!");
        return;
      }
      team.add(p);
    }
  }

  void resetTeam() => team.clear();

  void renameTeam(String name) {
    final n = name.trim();
    if (n.isNotEmpty) teamName.value = n;
  }

  // ---------- เพิ่มส่วนนี้ ----------
  void renamePokemon(Pokemon p, String newName) {
    final n = newName.trim();
    if (n.isEmpty) return;

    // อัปเดตตัวใน pokemons
    final i = pokemons.indexWhere((e) => e.id == p.id);
    if (i != -1) {
      pokemons[i].name = n;
    }

    // ถ้าอยู่ใน team ให้ชื่อใน team เปลี่ยนด้วย (อ้างอิงเดียวกัน แต่กันเคส copy)
    final t = team.indexWhere((e) => e.id == p.id);
    if (t != -1) {
      team[t].name = n;
    }

    // แจ้ง Obx ให้รีเฟรชหน้าลิสต์
    pokemons.refresh();
    team.refresh();
  }

  void renamePokemonById(int id, String newName) {
    final p = pokemons.firstWhereOrNull((e) => e.id == id);
    if (p != null) renamePokemon(p, newName);
  }

  // ป้ายชื่อช่องทีม (เปลี่ยนชื่อได้)
  final RxMap<String, String> teamLabels =
      <String, String>{'A': 'Team A', 'B': 'Team B', 'C': 'Team C'}.obs;

  // เซฟทีมตามช่อง (สำเนา list)
  final RxMap<String, List<Pokemon>> savedTeams =
      <String, List<Pokemon>>{}.obs;

  // ช่องที่กำลังใช้งาน (ออปชัน: ถ้าอยากแสดง)
  final RxString activeSlot = 'A'.obs;

  /// เซฟทีมปัจจุบันลงช่อง (A/B/C)
  void saveCurrentToSlot(String slot) {
    // เก็บสำเนา ไม่ผูก reference
    savedTeams[slot] = team.map((e) => e).toList();
    savedTeams.refresh();
    Get.snackbar('Saved', 'Saved current team to ${teamLabels[slot] ?? slot}');
  }

  /// โหลดทีมจากช่องมาเป็นทีมปัจจุบัน
  void loadSlot(String slot) {
    final list = savedTeams[slot] ?? <Pokemon>[];
    team.assignAll(list);
    activeSlot.value = slot;
    Get.snackbar('Loaded', 'Loaded ${teamLabels[slot] ?? slot} to current team');
  }

  /// เปลี่ยนชื่อช่องทีม
  void renameSlot(String slot, String newName) {
    final n = newName.trim();
    if (n.isEmpty) return;
    teamLabels[slot] = n;
    teamLabels.refresh();
  }

}
