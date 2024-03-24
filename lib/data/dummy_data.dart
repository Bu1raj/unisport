import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_complex_ms/models/arena_management_section/arena.dart';
import 'package:sports_complex_ms/models/arena_management_section/slots_details.dart';
import 'package:sports_complex_ms/models/issue_return_section/equipment.dart';
import 'package:sports_complex_ms/models/issue_return_section/issued_equipments.dart';
import 'package:sports_complex_ms/models/student.dart';

final mainSportsCatalog = {
  'Cricket': Icons.sports_cricket_rounded,
  'Football': Icons.sports_soccer_rounded,
  'Volleyball': Icons.sports_volleyball_rounded,
  'Basketball': Icons.sports_basketball_rounded,
  'Handball': Icons.sports_handball_rounded,
  'Tennis': Icons.sports_tennis_rounded,
};

final categoriesEquipmentsMap = {
  'Cricket': ['bat', 'ball', 'stumps'],
  'Volleyball': ['ball', 'net'],
  'Football': ['ball', 'cones'],
  'Basketball': ['ball'],
  'Handball': ['ball', 'net'],
  'Tennis': ['racquets', 'ball'],
};

List<InUseEquipment> inventory = [
  //cricket
  InUseEquipment(
    equipmentName: 'bat',
    equipmentId: 'CKBAT02',
    sport: 'Cricket',
    issued: true,
  ),
  InUseEquipment(
    equipmentName: 'bat',
    equipmentId: 'CKBAT03',
    sport: 'Cricket',
    issued: true,
  ),
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'CKBALL02',
    sport: 'Cricket',
  ),
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'CKBALL03',
    sport: 'Cricket',
    issued: true,
  ),

  //volleyball
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'VBBALL02',
    sport: 'Volleyball',
  ),
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'VBBALL03',
    sport: 'Volleyball',
  ),
  InUseEquipment(
    equipmentName: 'net',
    equipmentId: 'VBNET02',
    sport: 'Volleyball',
  ),
  InUseEquipment(
    equipmentName: 'net',
    equipmentId: 'VBNET03',
    sport: 'Volleyball',
  ),

  //football
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'FBBALL02',
    sport: 'Football',
  ),
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'FBBALL03',
    sport: 'Football',
  ),

  InUseEquipment(
    equipmentName: 'cones',
    equipmentId: 'FBCONES02',
    sport: 'Football',
  ),
  InUseEquipment(
    equipmentName: 'cones',
    equipmentId: 'FBCONES03',
    sport: 'Football',
  ),

  //basketball
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'BBBALL02',
    sport: 'Basketball',
  ),

  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'BBBALL03',
    sport: 'Basketball',
  ),

  //handball
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'HBBALL02',
    sport: 'Handball',
  ),

  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'HBBALL03',
    sport: 'Handball',
  ),

  InUseEquipment(
    equipmentName: 'net',
    equipmentId: 'HBNET02',
    sport: 'Handball',
  ),

  InUseEquipment(
    equipmentName: 'net',
    equipmentId: 'HBNET03',
    sport: 'Handball',
  ),

  //tennis
  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'TEBALL02',
    sport: 'Tennis',
  ),

  InUseEquipment(
    equipmentName: 'ball',
    equipmentId: 'TEBALL03',
    sport: 'Tennis',
  ),

  InUseEquipment(
    equipmentName: 'racquet',
    equipmentId: 'TERACQ02',
    sport: 'Tennis',
  ),

  InUseEquipment(
    equipmentName: 'racquet',
    equipmentId: 'TERACQ03',
    sport: 'Tennis',
  ),
];

final List<Student> registeredStudents = [
  Student(
    usn: '1RV21CS028',
    phNo: '8660538414',
    emailId: 'bhuvanrajt.cs21@rvce.edu.in',
    name: 'Bhuvanraj T'
  ),
  Student(
    usn: '1RV21CS024',
    phNo: '8123371154',
    emailId: 'arvindsawati.cs21@rvce.edu.in',
    name: 'Arvind S Awati'
  ),
  Student(
    usn: '1RV21CS040',
    phNo: '7022190665',
    emailId: 'gahanmr.cs21@rvce.edu.in',
    name: 'Gahan MR'
  ),
];

final List<IssuedEquipments> issuedEquipments = [
  IssuedEquipments(
    usn: '1RV21CS024',
    issuedEquipmentsIds: ['CKBAT02', 'CKBALL03', 'CKBAT03'],
    issuedTime: Timestamp.now(),//DateTime(2024, 1, 14, 1, 30),
  ),
  IssuedEquipments(
    usn: '1RV21CS028',
    issuedEquipmentsIds: ['VBBALL02'],
    issuedTime: Timestamp.now(),//DateTime(2024, 1, 14, 2, 40),
  ),
  IssuedEquipments(
    usn: '1RV21CS040',
    issuedEquipmentsIds: ['VBNET03'],
    issuedTime: Timestamp.now(),//DateTime(2024, 1, 14, 3, 00),
  ),
];

final List<Arena> arenas = [
  //cricket arenas
  Arena(
      sport: mainSportsCatalog.entries
          .firstWhere((element) => element.key == 'Cricket'),
      arenaName: 'Cricket Field 1',
      arenaId: 'CK_FIELD_01',
      slotsInfo: {
        Slots.slot1: SlotDetails(
          slotStartTime: const TimeOfDay(hour: 11, minute: 00),
          slotEndTime: const TimeOfDay(hour: 12, minute: 30),
          bookedBy: null,
        ),
        Slots.slot2: SlotDetails(
          slotStartTime: const TimeOfDay(hour: 12, minute: 30),
          slotEndTime: const TimeOfDay(hour: 02, minute: 00),
          bookedBy: null,
        ),
        Slots.slot3: SlotDetails(
          slotStartTime: const TimeOfDay(hour: 02, minute: 00),
          slotEndTime: const TimeOfDay(hour: 03, minute: 30),
          bookedBy: registeredStudents[1],
        ),
        Slots.slot4: SlotDetails(
          slotStartTime: const TimeOfDay(hour: 03, minute: 30),
          slotEndTime: const TimeOfDay(hour: 05, minute: 00),
          bookedBy: null,
        ),
      },
      arenaImagePath: 'assets\\arena_images\\cricket_field.jpg'),
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Cricket'),
    arenaName: 'Cricket Field 2',
    arenaId: 'CK_FIELD_02',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\cricket_field.jpg',
  ),

  //football arenas
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Football'),
    arenaName: 'Football Field 1',
    arenaId: 'FB_FIELD_01',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\football_field.jpg',
  ),
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Football'),
    arenaName: 'Football Field 2',
    arenaId: 'FB_FIELD_02',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\football_field.jpg',
  ),

  //volleyball arenas
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Volleyball'),
    arenaName: 'Volleyball Court 1',
    arenaId: 'VB_COURT_01',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\volleyball_court.jpg',
  ),
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Volleyball'),
    arenaName: 'Volleyball Court 2',
    arenaId: 'VB_COURT_02',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\volleyball_court.jpg',
  ),

  //handball courts
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Handball'),
    arenaName: 'Handball Court 1',
    arenaId: 'HB_COURT_01',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\handball_court.jpg',
  ),
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Handball'),
    arenaName: 'Handball Court 2',
    arenaId: 'HB_COURT_02',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\handball_court.jpg',
  ),

  //tennis courts
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Tennis'),
    arenaName: 'Tennis Court 1',
    arenaId: 'TE_COURT_01',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\tennis_court.jpg',
  ),
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Tennis'),
    arenaName: 'Tennis Court 2',
    arenaId: 'TE_COURT_02',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\tennis_court.jpg',
  ),

  //basketball courts
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Basketball'),
    arenaName: 'Basketball Court 1',
    arenaId: 'BB_COURT_01',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\basketball_court.jpg',
  ),
  Arena(
    sport: mainSportsCatalog.entries
        .firstWhere((element) => element.key == 'Basketball'),
    arenaName: 'Basketball Court 2',
    arenaId: 'BB_COURT_02',
    slotsInfo: {
      Slots.slot1: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 11, minute: 00),
        slotEndTime: const TimeOfDay(hour: 12, minute: 30),
        bookedBy: null,
      ),
      Slots.slot2: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 12, minute: 30),
        slotEndTime: const TimeOfDay(hour: 02, minute: 00),
        bookedBy: null,
      ),
      Slots.slot3: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 02, minute: 00),
        slotEndTime: const TimeOfDay(hour: 03, minute: 30),
        bookedBy: null,
      ),
      Slots.slot4: SlotDetails(
        slotStartTime: const TimeOfDay(hour: 03, minute: 30),
        slotEndTime: const TimeOfDay(hour: 05, minute: 00),
        bookedBy: null,
      ),
    },
    arenaImagePath: 'assets\\arena_images\\basketball_court.jpg',
  ),
];
