import 'package:get/get.dart';
import '../models/pokemon.dart';

class ApiService extends GetConnect {
  Future<List<Pokemon>> fetchPokemons({int limit = 151}) async {
    final String url = 'https://pokeapi.co/api/v2/pokemon?limit=$limit';
    final Response resp = await get(url);

    if (resp.statusCode == 200 && resp.body != null) {
      final List results =
          (resp.body['results'] as List); // [{name,url}, {name,url}, ...]

      // ยิงขอรายละเอียดของแต่ละตัวเพื่อเอา type + stats
      final List<Future<Pokemon>> tasks = results.map<Future<Pokemon>>((m) async {
        final String name = m['name'] as String;
        final String detailUrl = m['url'] as String; // .../pokemon/{id}/
        final int id = _extractId(detailUrl);

        // ค่าพื้นฐาน (fallback)
        String imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
        String typeName = 'Unknown';
        int hp = 0, attack = 0, defense = 0;

        try {
          final Response d = await get(detailUrl);
          if (d.statusCode == 200 && d.body != null) {
            final Map<String, dynamic> body =
                (d.body as Map).cast<String, dynamic>();

            // type ตัวแรก
            final List types = (body['types'] as List? ?? []);
            if (types.isNotEmpty) {
              typeName =
                  (types.first['type']?['name'] as String?) ?? 'Unknown';
            }

            // รูป official ชัดกว่า ถ้ามี
            final sprites = body['sprites'] as Map<String, dynamic>?;
            final other = sprites?['other'] as Map<String, dynamic>?;
            final official = other?['official-artwork'] as Map<String, dynamic>?;
            final officialImg = official?['front_default'] as String?;
            if (officialImg != null && officialImg.isNotEmpty) {
              imageUrl = officialImg;
            }

            // stats: hp/attack/defense
            hp = _readStat(body, 'hp');
            attack = _readStat(body, 'attack');
            defense = _readStat(body, 'defense');
          }
        } catch (_) {
          // ปล่อยให้ใช้ค่า fallback
        }

        return Pokemon(
          id: id,
          name: _cap(name),
          imageUrl: imageUrl,
          type: _cap(typeName),
          hp: hp,
          attack: attack,
          defense: defense,
        );
      }).toList();

      final List<Pokemon> pokemons = await Future.wait(tasks);
      return pokemons;
    }

    Get.snackbar('Network Error',
        'Failed to fetch Pokémon (${resp.statusCode}).');
    return <Pokemon>[];
  }

  int _extractId(String url) {
    final parts = url.split('/').where((s) => s.isNotEmpty).toList();
    return int.tryParse(parts.isNotEmpty ? parts.last : '') ?? 0;
    // ถ้า parts.last ไม่ใช่ตัวเลข (เพราะ URL ลงท้ายด้วย /) เรา handle แล้ว
  }

  int _readStat(Map<String, dynamic> body, String name) {
    final List stats = (body['stats'] as List? ?? []);
    for (final s in stats) {
      final statName = s['stat']?['name'] as String?;
      if (statName == name) {
        final v = s['base_stat'];
        if (v is int) return v;
        if (v is num) return v.toInt();
      }
    }
    return 0;
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
