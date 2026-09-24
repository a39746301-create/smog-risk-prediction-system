import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF1F5F9),

      appBar: AppBar(

        backgroundColor: const Color(0xff2563EB),

        title: const Text(
          "Smog Risk Prediction",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

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

              "Welcome 👋",

              style: TextStyle(

                fontSize:28,

                fontWeight:FontWeight.bold,

                color:Color(0xff1E293B),

              ),

            ),


            const SizedBox(height:5),


            const Text(

              "Monitor air quality and predict smog risks",

              style:TextStyle(

                color:Colors.grey,

                fontSize:16,

              ),

            ),


            const SizedBox(height:25),



            Row(

              children: [

                Expanded(

                  child: infoCard(

                    "AQI Level",

                    "165",

                    Icons.air,

                    Colors.orange,

                  ),

                ),


                const SizedBox(width:15),


                Expanded(

                  child: infoCard(

                    "Status",

                    "Poor",

                    Icons.warning,

                    Colors.red,

                  ),

                ),

              ],

            ),



            const SizedBox(height:15),



            Row(

              children: [

                Expanded(

                  child: infoCard(

                    "PM 2.5",

                    "78 µg/m³",

                    Icons.cloud,

                    Colors.blue,

                  ),

                ),


                const SizedBox(width:15),


                Expanded(

                  child: infoCard(

                    "Temperature",

                    "28 °C",

                    Icons.thermostat,

                    Colors.green,

                  ),

                ),

              ],

            ),



            const SizedBox(height:30),



            const Text(

              "Quick Actions",

              style:TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:15),



            actionButton(

              "Start Smog Prediction",

              Icons.analytics,

            ),


            const SizedBox(height:12),


            actionButton(

              "View Prediction History",

              Icons.history,

            ),


            const SizedBox(height:12),


            actionButton(

              "Check Location Air Quality",

              Icons.location_on,

            ),



            const SizedBox(height:30),



            Container(

              width:double.infinity,

              padding:const EdgeInsets.all(20),

              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:BorderRadius.circular(20),

              ),


              child:Column(

                crossAxisAlignment:CrossAxisAlignment.start,

                children:[


                  const Text(

                    "AI Prediction",

                    style:TextStyle(

                      fontSize:20,

                      fontWeight:FontWeight.bold,

                    ),

                  ),


                  const SizedBox(height:15),


                  const Text(

                    "Based on current environmental data, smog risk is expected to remain high. Avoid outdoor activities during peak pollution hours.",

                    style:TextStyle(

                      color:Colors.grey,

                      fontSize:15,

                    ),

                  )

                ],

              ),

            )


          ],

        ),

      ),

    );

  }



  Widget infoCard(

      String title,

      String value,

      IconData icon,

      Color color

      ){

    return Container(

      padding:const EdgeInsets.all(18),

      decoration:BoxDecoration(

        color:Colors.white,

        borderRadius:BorderRadius.circular(18),

        boxShadow:[

          BoxShadow(

            color:Colors.grey.withValues(alpha: 0.15),

            blurRadius:10,

          )

        ],

      ),


      child:Column(

        children:[


          Icon(

            icon,

            color:color,

            size:35,

          ),


          const SizedBox(height:10),


          Text(

            value,

            style:const TextStyle(

              fontSize:24,

              fontWeight:FontWeight.bold,

            ),

          ),


          Text(

            title,

            style:const TextStyle(

              color:Colors.grey,

            ),

          )


        ],

      ),

    );

  }



  Widget actionButton(String text, IconData icon){

    return Container(

      width:double.infinity,

      padding:const EdgeInsets.all(18),

      decoration:BoxDecoration(

        color:const Color(0xff2563EB),

        borderRadius:BorderRadius.circular(15),

      ),


      child:Row(

        children:[


          Icon(

            icon,

            color:Colors.white,

          ),


          const SizedBox(width:15),


          Text(

            text,

            style:const TextStyle(

              color:Colors.white,

              fontSize:16,

              fontWeight:FontWeight.bold,

            ),

          )


        ],

      ),

    );

  }

}
