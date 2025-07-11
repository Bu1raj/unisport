import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/constants/sport_code_icon_generator.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/issued_equipments.dart';
import 'package:sports_complex_ms/staff_side_app/screens/issue_return_section/return_screen_overlay.dart';

class IssuedEquipmentCard extends StatelessWidget {
  const IssuedEquipmentCard({
    super.key,
    required this.issuedEquipmentsDetails,
  });

  final IssuedEquipments issuedEquipmentsDetails;
  //final void Function(String) freeEquipments;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //final deadline = dateTime.add(const Duration(hours: 5));
    //final issuedEquipmentsList = issuedEquipments.join(', ');

    void displayReturnScreenOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          minWidth: screenWidth,
          minHeight: screenHeight * 0.3,
        ),
        context: context,
        builder: (ctx) => SafeArea(
          child: ReturnScreenOverlay(
            issuedEquipmentsReturnData: issuedEquipmentsDetails,
            parentContext: context,
            //freeEquipments: freeEquipments,
          ),
        ),
      );
    }

    String dateTimeFormatter(DateTime time) {
      final dateTimeFormatter = DateFormat.Hm().add_yMMMd();
      return dateTimeFormatter.format(time);
    }

    return InkWell(
      onTap: displayReturnScreenOverlay,
      splashColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 15.0, right: 20.0, left: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.tertiary,
                        size: 30,
                      ),
                      Text(
                        issuedEquipmentsDetails.usn,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Issued Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dateTimeFormatter(
                        issuedEquipmentsDetails.issuedTime.toDate()),
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Icon(
                iconGenerator(
                  issuedEquipmentsDetails.sport,
                ),
                color: Theme.of(context).colorScheme.primary,
                size: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
