import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';
import 'pokemon_detail_page.dart';

class PokemonListPage extends StatelessWidget {
  final ApiService api = ApiService();

  PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokédex")),
      body: FutureBuilder<List<Pokemon>>(
        future: api.fetchPokemons(limit: 20),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final pokemons = snapshot.data!;
          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, i) {
              final p = pokemons[i];
              return ListTile(
                leading: Image.network(p.imageUrl, width: 50),
                title: Text(p.name),
                subtitle: Text("Type: ${p.type}"),
                onTap: () {
                  Get.to(() => PokemonDetailPage(pokemon: p));
                },
              );
            },
          );
        },
      ),
    );
  }
}
