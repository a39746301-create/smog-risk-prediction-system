import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;


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

          child: SingleChildScrollView(

            child: Container(

              width:400,

              padding:const EdgeInsets.all(35),


              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:
                BorderRadius.circular(20),


                boxShadow:[

                  BoxShadow(

                    color:
                    Colors.black26,

                    blurRadius:20,

                  ),

                ],

              ),


              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[


                  const Text(

                    "Create Account",

                    style:TextStyle(

                      fontSize:32,

                      fontWeight:FontWeight.bold,

                      color:Color(0xff1E293B),

                    ),

                  ),


                  const SizedBox(height:10),


                  const Text(

                    "Register for Smog Risk Prediction",

                    style:TextStyle(

                      color:Colors.grey,

                    ),

                  ),


                  const SizedBox(height:30),


                  TextField(

                    controller:nameController,

                    decoration:InputDecoration(

                      labelText:"Full Name",

                      prefixIcon:
                      const Icon(Icons.person_outline),


                      border:OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(12),

                      ),

                    ),

                  ),


                  const SizedBox(height:15),


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


                  const SizedBox(height:15),


                  TextField(

                    controller:passwordController,

                    obscureText:hidePassword,


                    decoration:InputDecoration(

                      labelText:"Password",

                      prefixIcon:
                      const Icon(Icons.lock_outline),


                      suffixIcon:IconButton(

                        icon:Icon(

                          hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,

                        ),


                        onPressed:(){

                          setState((){

                            hidePassword =
                            !hidePassword;

                          });

                        },

                      ),


                      border:OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(12),

                      ),

                    ),

                  ),


                  const SizedBox(height:15),


                  TextField(

                    controller:confirmPasswordController,

                    obscureText:hideConfirmPassword,


                    decoration:InputDecoration(

                      labelText:"Confirm Password",

                      prefixIcon:
                      const Icon(Icons.lock),


                      suffixIcon:IconButton(

                        icon:Icon(

                          hideConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,

                        ),


                        onPressed:(){

                          setState((){

                            hideConfirmPassword =
                            !hideConfirmPassword;

                          });

                        },

                      ),


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


                        String name =
                        nameController.text.trim();

                        String email =
                        emailController.text.trim();

                        String password =
                        passwordController.text.trim();

                        String confirmPassword =
                        confirmPasswordController.text.trim();



                        if(name.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty){


                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            const SnackBar(

                              content:
                              Text("Please fill all fields"),

                            ),

                          );

                          return;

                        }



                        if(!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
                        ).hasMatch(email)){


                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            const SnackBar(

                              content:
                              Text("Enter a valid email address"),

                            ),

                          );

                          return;

                        }



                        if(password.length < 8 ||
                            !RegExp(r'[A-Z]').hasMatch(password) ||
                            !RegExp(r'[a-z]').hasMatch(password) ||
                            !RegExp(r'[0-9]').hasMatch(password)){


                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            const SnackBar(

                              content:
                              Text(
                                "Password must contain capital, small letter and number",
                              ),

                            ),

                          );

                          return;

                        }



                        if(password != confirmPassword){


                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            const SnackBar(

                              content:
                              Text("Password does not match"),

                            ),

                          );

                          return;

                        }



                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                          const SnackBar(

                            content:
                            Text("Account Created Successfully"),

                          ),

                        );


                        Future.delayed(
                            const Duration(seconds:1),
                                (){

                              Navigator.pop(context);

                            });


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

                        "Create Account",

                        style:TextStyle(

                          color:Colors.white,

                          fontSize:18,

                        ),

                      ),


                    ),

                  ),


                  const SizedBox(height:20),


                  Center(

                    child:TextButton(

                      onPressed:(){

                        Navigator.pop(context);

                      },


                      child:const Text(

                        "Already have an account? Login",

                        style:TextStyle(

                          color:Color(0xff2563EB),

                        ),

                      ),

                    ),

                  )


                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}