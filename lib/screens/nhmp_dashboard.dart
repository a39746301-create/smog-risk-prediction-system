import 'package:flutter/material.dart';

class NHMPDashboard extends StatelessWidget {

  const NHMPDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "NHMP Monitoring Dashboard"
        ),

        backgroundColor: Colors.green,

      ),


      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.location_on,
              size:80,
              color:Colors.green,
            ),


            const Text(

              "Motorway Air Quality Monitoring",

              style:TextStyle(

                fontSize:25,

                fontWeight:FontWeight.bold,

              ),

            ),

            const SizedBox(height:20),


            const Text(
              "Live AQI Monitoring\nSmog Alerts\nReports",
              textAlign:TextAlign.center,
              style:TextStyle(fontSize:18),
            )

          ],

        ),

      ),

    );

  }
}