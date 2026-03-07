import 'package:flutter/material.dart';

class PostTemplate extends StatelessWidget {
  const PostTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: BoxBorder.all(color: Theme.of(context).colorScheme.onSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            "Nilansh Sharma • @nil4nsh",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(100, 0, 0, 0)),
          ),
          Text(
            "02/09/2023 19:23 PM",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(100, 0, 0, 0)),
          ),
          Text(
            "Proin placerat neque felis. Etiam a vestibulum libero, ut venenatis elit. Morbi cursus bibendum aliquam. Nulla facilisi. Aliquam id gravida ipsum. Nullam quis interdum sem. Sed eget efficitur urna. Phasellus lobortis dignissim sem ut lacinia. Nulla et ornare nibh. Aliquam consequat tristique orci, ut mollis purus volutpat sit amet. Ut ut libero diam. Curabitur pulvinar cursus eros eget tempus. Nullam lacinia nulla nibh, vehicula dictum justo sollicitudin iaculis. Suspendisse massa felis, vehicula non dui at, venenatis lacinia nibh. ",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
