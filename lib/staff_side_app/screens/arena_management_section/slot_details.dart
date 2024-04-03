import 'package:flutter/material.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/arena_management_section/slots_details_items.dart';

class SlotsDetailsScreen extends StatefulWidget {
  const SlotsDetailsScreen({
    super.key,
    required this.slotsDetails,
    required this.arenaName,
    required this.sport,
  });

  final String sport;
  final String arenaName;
  final List<Map<String, String?>> slotsDetails;
  @override
  State<SlotsDetailsScreen> createState() {
    return _SlotsDetailsScreenState();
  }
}

class _SlotsDetailsScreenState extends State<SlotsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final slotsList = widget.slotsDetails;
    /*final timings =
        '${slotsList[0].slotStartTime.format} - ${slotsList[0].slotEndTime.format}';*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arenaName,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets\\arena_images\\${widget.sport}.jpg',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 15),
            child: Text(
              'Slots Details',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: slotsList.length,
                itemBuilder: (context, index) => SlotsDetailsItem(
                      index: index,
                      slotDetails: slotsList[index],
                    )),
          ),
        ],
      ),
    );
  }
}
