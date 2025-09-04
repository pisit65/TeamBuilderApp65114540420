
1. การจัดการสถานะด้วย GetX
เราจะใช้ GetxController เพื่อจัดการสถานะของแอปพลิเคชันทั้งหมด และใช้ตัวแปรแบบ reactive เพื่อให้ UI อัปเดตตัวเองได้โดยอัตโนมัติเมื่อสถานะเปลี่ยนไป

ตัวแปร Reactive: ใช้ RxList สำหรับรายชื่อโปเกมอนที่ถูกเลือกในทีม และ RxString สำหรับชื่อทีมปัจจุบัน

final RxList<Pokemon> selectedTeam = <Pokemon>[].obs;

final RxString teamName = 'My Awesome Team'.obs;

การผูกกับ Widget: ใช้ Obx widget เพื่อครอบ widget ที่ต้องมีการเปลี่ยนแปลงตามสถานะของตัวแปร reactive เช่น ListView ของทีมโปเกมอน หรือ Text widget ที่แสดงชื่อทีม

การเข้าถึง Controller: ใช้ Get.put() ในการสร้างและใส่ Controller เข้าไปในระบบครั้งแรก และใช้ Get.find() เพื่อดึง Controller ที่มีอยู่แล้วมาใช้ใน widget ต่าง ๆ

2. การสร้าง Controller (TeamController)
Controller นี้จะเป็นศูนย์กลางในการจัดการ logic และสถานะทั้งหมดของแอป

Logic การเพิ่ม/ลบสมาชิก:

สร้างเมธอด addPokemon(Pokemon pokemon) ที่จะเช็คเงื่อนไขก่อนเพิ่ม (จำนวนไม่เกิน 3 ตัว และไม่ซ้ำ)

สร้างเมธอด removePokemon(Pokemon pokemon) เพื่อลบโปเกมอนออกจากทีม

Logic การจัดการชื่อทีม:

สร้างเมธอด changeTeamName(String newName) เพื่อแก้ไขชื่อทีม

Logic การรีเซ็ตทีม:

สร้างเมธอด resetTeam() เพื่อล้างค่าใน selectedTeam ให้ว่างเปล่า

3. ส่วนประกอบของหน้าจอ (Widgets)
AppBar:

ใช้ Obx ครอบ Text widget เพื่อแสดงชื่อทีมปัจจุบัน (controller.teamName.value)

มี IconButton สำหรับเปลี่ยนชื่อทีม เมื่อกดแล้วจะเรียกเมธอด changeTeamName() ของ Controller

มี IconButton สำหรับรีเซ็ตทีม เมื่อกดจะเรียกเมธอด resetTeam()

รายการโปเกมอน (ListView):

สร้าง ListView.builder ที่แสดงรายการโปเกมอนทั้งหมด

แต่ละรายการโปเกมอน (list tile) จะมี GestureDetector เพื่อให้ผู้ใช้แตะเพื่อเลือกหรือลบ

ภายใน list tile จะใช้ Obx เพื่อเปลี่ยน icon (Icon(Icons.add) หรือ Icon(Icons.check)) ตามสถานะว่าโปเกมอนตัวนั้นถูกเลือกแล้วหรือไม่ (controller.selectedTeam.contains(pokemon))

หน้าสรุปทีม (Preview Page):

เมื่อกดปุ่มเพื่อไปหน้านี้ ให้ใช้ Get.to() ในการเปลี่ยนหน้า

ในหน้านี้ ให้ใช้ Obx และตรวจสอบว่า controller.selectedTeam.isEmpty

ถ้าเป็นจริง ให้แสดง Text('ยังไม่มีสมาชิกในทีม')

ถ้าไม่เป็นจริง ให้แสดง ListView ของโปเกมอนที่อยู่ในทีม