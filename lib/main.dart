import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuários Flutter Web',
      home: const UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  Future<void> fetchUsuarios() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/usuarios'),
    );
    if (response.statusCode == 200) {
      setState(() {
        usuarios = jsonDecode(response.body);
      });
    } else {
      print('Erro ao carregar usuários: ${response.statusCode}');
    }
  }

  Future<void> deletarUsuario(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8080/usuarios/$id'),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      setState(() {
        usuarios.removeWhere((usuario) => usuario['id'] == id);
      });
    } else {
      print('Erro ao deletar usuário: ${response.statusCode}');
    }
  }

  Future<void> atualizarUsuario(int id, String nome, String email) async {
    final response = await http.put(
      Uri.parse('http://localhost:8080/usuarios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email}),
    );
    if (response.statusCode == 200) {
      setState(() {
        final index = usuarios.indexWhere((usuario) => usuario['id'] == id);
        if (index != -1) {
          usuarios[index] = jsonDecode(response.body);
        }
      });
    } else {
      print('Erro ao atualizar usuário: ${response.statusCode}');
    }
  }

  void abrirFormularioEdicao(Map<String, dynamic> usuario) {
    final nomeController = TextEditingController(text: usuario['nome']);
    final emailController = TextEditingController(text: usuario['email']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                nomeController.dispose();
                emailController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text;
                final email = emailController.text;
                await atualizarUsuario(usuario['id'], nome, email);
                nomeController.dispose();
                emailController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void abrirFormularioCriacao() {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                nomeController.dispose();
                emailController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nome = nomeController.text;
                final email = emailController.text;

                final response = await http.post(
                  Uri.parse('http://localhost:8080/usuarios'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'nome': nome, 'email': email}),
                );

                if (response.statusCode == 200 || response.statusCode == 201) {
                  fetchUsuarios();
                } else {
                  print('Erro ao criar usuário: ${response.statusCode}');
                }

                nomeController.dispose();
                emailController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuários')),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario['nome']),
            subtitle: Text(usuario['email']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => abrirFormularioEdicao(usuario),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deletarUsuario(usuario['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirFormularioCriacao,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Usuário',
      ),
    );
  }
}
