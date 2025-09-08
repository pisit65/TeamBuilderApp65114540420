import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/name_controller.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});
  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final NameController controller = Get.find<NameController>(); // ดึงที่นี่
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("หน้าตั้งชื่อ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text("ชื่อปัจจุบัน: ${controller.name.value}",
                style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "กรอกชื่อใหม่",
              ),
              onSubmitted: (v) => controller.changeName(v),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                controller.changeName(textController.text.trim());
                textController.clear();
              },
              child: const Text("เปลี่ยนชื่อ"),
            ),
          ],
        ),
      ),
    );
  }
}
