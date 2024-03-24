import 'package:sports_complex_ms/models/issue_return_section/equipment.dart';

final mainInventory = [
  //cricket
  MainInventoryEquipment(
    equipmentId: 'CKBAT01',
    equipmentName: 'bat',
    sport: 'Cricket',
    startedUsingOn: DateTime(2022, DateTime.january, 29),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBAT02',
    equipmentName: 'bat',
    sport: 'Cricket',
    startedUsingOn: DateTime(2022, DateTime.february, 18),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBAT03',
    equipmentName: 'bat',
    sport: 'Cricket',
    startedUsingOn: DateTime(2022, DateTime.february, 20),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBAT04',
    equipmentName: 'bat',
    sport: 'Cricket',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBALL01',
    equipmentName: 'ball',
    sport: 'Cricket',
    startedUsingOn: DateTime(2022, DateTime.january, 25),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBALL02',
    equipmentName: 'ball',
    sport: 'Cricket',
    startedUsingOn: DateTime(2023, DateTime.april, 24),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBALL03',
    equipmentName: 'ball',
    sport: 'Cricket',
    startedUsingOn: DateTime(2023, DateTime.april, 24),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'CKBALL04',
    equipmentName: 'ball',
    sport: 'Cricket',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  //volleyball
  MainInventoryEquipment(
    equipmentId: 'VBBALL01',
    equipmentName: 'ball',
    sport: 'Volleyball',
    startedUsingOn: DateTime(2022, DateTime.august, 13),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBBALL02',
    equipmentName: 'ball',
    sport: 'Volleyball',
    startedUsingOn: DateTime(2023, DateTime.january, 13),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBBALL03',
    equipmentName: 'ball',
    sport: 'Volleyball',
    startedUsingOn: DateTime(2023, DateTime.january, 13),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBBALL04',
    equipmentName: 'ball',
    sport: 'Volleyball',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBNET01',
    equipmentName: 'net',
    sport: 'Volleyball',
    startedUsingOn: DateTime(2022, DateTime.august, 13),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBNET02',
    equipmentName: 'net',
    sport: 'Volleyball',
    startedUsingOn: DateTime(2023, DateTime.march, 13),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBNET03',
    equipmentName: 'net',
    sport: 'Volleyball',
    startedUsingOn: DateTime(2023, DateTime.march, 15),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'VBNET04',
    equipmentName: 'net',
    sport: 'Volleyball',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  // Football
  MainInventoryEquipment(
    equipmentId: 'FBBALL01',
    equipmentName: 'ball',
    sport: 'Football',
    startedUsingOn: DateTime(2022, DateTime.january, 10),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBBALL02',
    equipmentName: 'ball',
    sport: 'Football',
    startedUsingOn: DateTime(2023, DateTime.february, 5),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBBALL03',
    equipmentName: 'ball',
    sport: 'Football',
    startedUsingOn: DateTime(2023, DateTime.february, 15),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBBALL04',
    equipmentName: 'ball',
    sport: 'Football',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBCONES01',
    equipmentName: 'cones',
    sport: 'Football',
    startedUsingOn: DateTime(2022, DateTime.january, 20),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBCONES02',
    equipmentName: 'cones',
    sport: 'Football',
    startedUsingOn: DateTime(2023, DateTime.february, 10),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBCONES03',
    equipmentName: 'cones',
    sport: 'Football',
    startedUsingOn: DateTime(2023, DateTime.february, 20),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'FBCONES04',
    equipmentName: 'cones',
    sport: 'Football',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  // Basketball
  MainInventoryEquipment(
    equipmentId: 'BBBALL01',
    equipmentName: 'ball',
    sport: 'Basketball',
    startedUsingOn: DateTime(2022, DateTime.march, 5),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'BBBALL02',
    equipmentName: 'ball',
    sport: 'Basketball',
    startedUsingOn: DateTime(2023, DateTime.march, 15),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'BBBALL03',
    equipmentName: 'ball',
    sport: 'Basketball',
    startedUsingOn: DateTime(2023, DateTime.march, 25),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'BBBALL04',
    equipmentName: 'ball',
    sport: 'Basketball',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  // Handball
  MainInventoryEquipment(
    equipmentId: 'HBBALL01',
    equipmentName: 'ball',
    sport: 'Handball',
    startedUsingOn: DateTime(2022, DateTime.april, 10),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBBALL02',
    equipmentName: 'ball',
    sport: 'Handball',
    startedUsingOn: DateTime(2023, DateTime.april, 20),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBBALL03',
    equipmentName: 'ball',
    sport: 'Handball',
    startedUsingOn: DateTime(2023, DateTime.april, 30),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBBALL04',
    equipmentName: 'ball',
    sport: 'Handball',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBNET01',
    equipmentName: 'net',
    sport: 'Handball',
    startedUsingOn: DateTime(2022, DateTime.april, 15),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBNET02',
    equipmentName: 'net',
    sport: 'Handball',
    startedUsingOn: DateTime(2023, DateTime.april, 25),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBNET03',
    equipmentName: 'net',
    sport: 'Handball',
    startedUsingOn: DateTime(2023, DateTime.may, 5),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'HBNET04',
    equipmentName: 'net',
    sport: 'Handball',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  // Tennis
  MainInventoryEquipment(
    equipmentId: 'TERACQ01',
    equipmentName: 'racquet',
    sport: 'Tennis',
    startedUsingOn: DateTime(2022, DateTime.june, 10),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'TERACQ02',
    equipmentName: 'racquet',
    sport: 'Tennis',
    startedUsingOn: DateTime(2023, DateTime.june, 20),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'TERACQ03',
    equipmentName: 'racquet',
    sport: 'Tennis',
    startedUsingOn: DateTime(2023, DateTime.june, 30),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'TERACQ04',
    equipmentName: 'racquet',
    sport: 'Tennis',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),

  MainInventoryEquipment(
    equipmentId: 'TEBALL01',
    equipmentName: 'ball',
    sport: 'Tennis',
    startedUsingOn: DateTime(2022, DateTime.july, 5),
    status: 'damaged',
  ),

  MainInventoryEquipment(
    equipmentId: 'TEBALL02',
    equipmentName: 'ball',
    sport: 'Tennis',
    startedUsingOn: DateTime(2023, DateTime.july, 15),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'TEBALL03',
    equipmentName: 'ball',
    sport: 'Tennis',
    startedUsingOn: DateTime(2023, DateTime.july, 25),
    status: 'inUse',
  ),

  MainInventoryEquipment(
    equipmentId: 'TEBALL04',
    equipmentName: 'ball',
    sport: 'Tennis',
    startedUsingOn: DateTime(0, 0, 0),
    status: 'newStock',
  ),
];
