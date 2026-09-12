import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}


class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        height: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [
              Color(0xff081426),
              Color(0xff102A43),
            ],

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

          ),

        ),


        child: Center(

          child: Container(

            width:400,

            padding: const EdgeInsets.all(35),


            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(20),

            ),


            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [


                const Text(

                  "Forgot Password?",

                  style: TextStyle(

                    fontSize:32,

                    fontWeight:FontWeight.bold,

                    color:Color(0xff1E293B),

                  ),

                ),


                const SizedBox(height:10),


                const Text(

                  "Enter your email to reset your password",

                  style:TextStyle(

                    color:Colors.grey,

                  ),

                ),


                const SizedBox(height:30),


                TextField(

                  controller:emailController,


                  decoration:InputDecoration(

                    labelText:"Email Address",

                    prefixIcon:
                    const Icon(Icons.email_outlined),


                    border:OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(12),

                    ),

                  ),

                ),



                const SizedBox(height:25),



                SizedBox(

                  width:double.infinity,

                  height:55,


                  child:ElevatedButton(

                   onPressed:(){

  String email = emailController.text.trim();


  if(email.isEmpty){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter email"),
      ),
    );

    return;
  }


  bool validEmail = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
  ).hasMatch(email);



  if(!validEmail){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Enter a valid email address"),
      ),
    );

    return;
  }



  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Password reset link sent successfully"),
    ),
  );


},

                    style:ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(0xff2563EB),


                      shape:RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(12),

                      ),

                    ),


                    child:const Text(

                      "Reset Password",

                      style:TextStyle(

                        color:Colors.white,

                        fontSize:18,

                      ),

                    ),


                  ),

                ),



                const SizedBox(height:20),



                TextButton(

                  onPressed:(){

                    Navigator.pop(context);

                  },


                  child:const Text(

                    "Back to Login",

                    style:TextStyle(

                      color:Color(0xff2563EB),

                    ),

                  ),

                )


              ],

            ),

          ),

        ),

      ),

    );

  }

}