class Pokemon {
  final int id;
  String name;        // <-- ต้องไม่เป็น final
  final String imageUrl;
  final String type;
  final int hp;
  final int attack;
  final int defense;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.hp,
    required this.attack,
    required this.defense,
  });
}
