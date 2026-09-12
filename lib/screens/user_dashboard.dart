import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xff081426),

      appBar: AppBar(
        title: const Text(
          "Smog Risk Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: const Color(0xff102A43),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            const Text(
              "Good Morning 👋",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),


            const SizedBox(height:20),


            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(25),

                gradient: const LinearGradient(

                  colors: [

                    Color(0xff16324F),
                    Color(0xff243B53),

                  ],

                ),

              ),


              child: Column(

                children: [


                  const Icon(

                    Icons.air,

                    size:70,

                    color: Colors.white,

                  ),


                  const SizedBox(height:15),


                  const Text(

                    "AQI 156",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize:40,

                      fontWeight: FontWeight.bold,

                    ),

                  ),


                  const Text(

                    "Moderate Smog Level",

                    style: TextStyle(

                      color: Colors.orangeAccent,

                      fontSize:18,

                    ),

                  ),

                ],

              ),

            ),


            const SizedBox(height:25),


            Row(

              children: [

                dashboardCard(
                  "PM 2.5",
                  "85 µg/m³",
                  Icons.cloud,
                ),


                const SizedBox(width:15),


                dashboardCard(
                  "Temperature",
                  "28°C",
                  Icons.thermostat,
                ),

              ],

            ),


            const SizedBox(height:25),


            Container(

              width:double.infinity,

              padding:const EdgeInsets.all(20),

              decoration:BoxDecoration(

                color:Colors.white.withOpacity(0.08),

                borderRadius:BorderRadius.circular(20),

              ),


              child:const Column(

                crossAxisAlignment:CrossAxisAlignment.start,

                children:[


                  Text(

                    "AI Prediction",

                    style:TextStyle(

                      color:Colors.white,

                      fontSize:20,

                      fontWeight:FontWeight.bold,

                    ),

                  ),


                  SizedBox(height:10),


                  Text(

                    "Smog risk prediction will appear here",

                    style:TextStyle(

                      color:Colors.white70,

                    ),

                  ),

                ],

              ),

            )


          ],

        ),

      ),

    );

  }



  Widget dashboardCard(
      String title,
      String value,
      IconData icon
      ){

    return Expanded(

      child: Container(

        padding:const EdgeInsets.all(18),

        decoration:BoxDecoration(

          color:Colors.white.withOpacity(0.08),

          borderRadius:BorderRadius.circular(20),

        ),


        child:Column(

          children:[

            Icon(
              icon,
              color:Colors.white,
              size:35,
            ),

            const SizedBox(height:10),

            Text(

              title,

              style:const TextStyle(
                color:Colors.white70,
              ),

            ),

            Text(

              value,

              style:const TextStyle(

                color:Colors.white,

                fontSize:18,

                fontWeight:FontWeight.bold,

              ),

            )

          ],

        ),

      ),

    );

  }


}