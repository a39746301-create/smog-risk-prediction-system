import 'package:flutter/material.dart';

import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'user_dashboard.dart';
import 'nhmp_dashboard.dart';
import 'admin_dashboard.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedRole = "User Login";

bool hidePassword = true;
bool isLoading = false;
bool rememberMe = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Row(

        children: [


          // LEFT SIDE DESIGN

          Expanded(
            flex: 1,

            child: Stack(

              children: [


                Positioned.fill(

                  child: Image.asset(

                    'assets/images/motorway_bg.png',

                    fit: BoxFit.cover,

                  ),

                ),


                Positioned.fill(

                  child: Container(

                    decoration: BoxDecoration(

                      gradient: LinearGradient(

                       colors: [
  Colors.black.withOpacity(0.7),

  const Color(0xff102A43)
      .withOpacity(0.6),

],
                        begin: Alignment.topLeft,

                        end: Alignment.bottomRight,

                      ),

                    ),

                  ),

                ),



                Padding(

                  padding: const EdgeInsets.all(40),

                  child: Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,


                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children: [


                      Container(

                        padding:
                        const EdgeInsets.all(14),


                        decoration: BoxDecoration(

                          color: Colors.white
                              .withOpacity(0.15),

                          borderRadius:
                          BorderRadius.circular(18),

                        ),


                        child: const Icon(

                          Icons.cloud,

                          color: Colors.white,

                          size:45,

                        ),

                      ),



                      const SizedBox(height:25),



                      const Text(

                        "AI-Powered\nSmog Risk\nPrediction",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize:36,

                          fontWeight:
                          FontWeight.bold,

                          height:1.2,

                        ),

                      ),



                      const SizedBox(height:15),



                      const Text(

                        "Predict air quality risks using\nArtificial Intelligence and real-time\nenvironmental data.",

                        style: TextStyle(

                          color: Colors.white70,

                          fontSize:16,

                        ),

                      ),



                      const SizedBox(height:35),



                      Row(

                        children: [


                          featureCard(
                            Icons.air,
                            "AQI\nMonitoring",
                          ),


                          const SizedBox(width:12),


                          featureCard(
                            Icons.analytics,
                            "AI\nPrediction",
                          ),


                          const SizedBox(width:12),


                          featureCard(
                            Icons.location_on,
                            "Real Time\nLocation",
                          ),


                        ],

                      ),


                    ],

                  ),

                ),

              ],

            ),

          ),



          // RIGHT SIDE

          Expanded(

            flex:1,

            child: Container(

            decoration: BoxDecoration(

  gradient: LinearGradient(

    colors: [

      const Color(0xff081426),

      const Color(0xff16324F),

      const Color(0xff243B53),

    ],

    begin: Alignment.topLeft,

    end: Alignment.bottomRight,

  ),

),

              child: Center(

                child: SingleChildScrollView(

                  child: Container(

                    width:430,

                    padding:
                    const EdgeInsets.all(35),


                    child: Column(

                      mainAxisSize:
                      MainAxisSize.min,


                      children:[


                        const Text(

                          "Welcome Back!",

                          style: TextStyle(

                            color:Colors.white,

                            fontSize:34,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),



                        const SizedBox(height:10),



                        const Text(

                          "Select your role to continue",

                          style: TextStyle(

                            color:Colors.white70,

                            fontSize:16,

                          ),

                        ),



                        const SizedBox(height:35),



                        loginRoleCard(

                          "User Login",

                          "Access user dashboard",

                          Icons.person,

                          const Color(0xff2563EB),

                        ),



                        loginRoleCard(

                          "NHMP Login",

                          "National Highway Management",

                          Icons.shield,

                          const Color(0xff16A34A),

                        ),



                        loginRoleCard(

                          "Admin Login",

                          "System administration",

                          Icons.settings,

                          const Color(0xff9333EA),

                        ),



                        const SizedBox(height:25),
                        TextField(

                          controller: emailController,
keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(

                            filled:true,

                            fillColor:Colors.white,

                           hintText:"Enter your email",
                           

                            prefixIcon:
                            const Icon(Icons.email_outlined),

                            border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
),

enabledBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(
    color: Colors.grey,
  ),
),

focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(
    color: Color(0xff2563EB),
    width: 2,
  ),
),

                          ),

                        ),


                        const SizedBox(height:15),



                        TextField(

                          controller: passwordController,



                          obscureText: hidePassword,

                          decoration: InputDecoration(

                            filled:true,

                            fillColor:Colors.white,
hintText:"Enter your password",
                            

                            prefixIcon:
                            const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(

  icon: Icon(
    hidePassword
        ? Icons.visibility_off
        : Icons.visibility,
  ),

  onPressed: (){

    setState((){

      hidePassword = !hidePassword;

    });

  },

),
border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
),

enabledBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(
    color: Colors.grey,
  ),
),

focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(
    color: Color(0xff2563EB),
    width: 2,
  ),
),

                          ),

                        ),



                       Row(
  children: [

    Checkbox(

      value: rememberMe,

      activeColor: const Color(0xff2563EB),

      onChanged: (value) {

        setState(() {

          rememberMe = value!;

        });

      },

    ),

    const Text(

      "Remember Me",

      style: TextStyle(

        color: Colors.white,

      ),

    ),

    const Spacer(),

    TextButton(

      onPressed: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => const ForgotPasswordPage(),

          ),

        );

      },

      child: const Text(

        "Forgot Password?",

        style: TextStyle(

          color: Colors.white70,

        ),

      ),

    ),

  ],

),


                        SizedBox(

                          width:double.infinity,

                          height:55,

                          child:ElevatedButton(

                           onPressed: () {
                       
                            setState(() {
  isLoading = true;
});

  String email = emailController.text.trim();
  String password = passwordController.text.trim();


  // Empty check
  if(email.isEmpty || password.isEmpty){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
      ),
    );
setState(() {
  isLoading = false;
});
    return;
  }


  // Email validation
  if(!RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
  ).hasMatch(email)){


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter a valid email address"),
      ),
    );
setState(() {
  isLoading = false;
});
    return;
  }



  // Password validation
  if(password.length < 8 ||
     !RegExp(r'[A-Z]').hasMatch(password) ||
     !RegExp(r'[a-z]').hasMatch(password) ||
     !RegExp(r'[0-9]').hasMatch(password)){


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Password must contain capital, small letter and number"
        ),
      ),
    );
setState(() {
  isLoading = false;
});
    return;
  }



  // Login checking


  if(selectedRole=="NHMP Login" &&
      email=="nhmp@gmail.com" &&
      password=="Nhmp1234"){


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful"),
      ),
    );

setState(() {
  isLoading = false;
});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:(context)=> NHMPDashboard(),
      ),
    );

  }


  else if(selectedRole=="User Login" &&
      email=="user@gmail.com" &&
      password=="User1234"){


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful"),
      ),
    );


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:(context)=> UserDashboard(),
      ),
    );

  }


  else if(selectedRole=="Admin Login" &&
      email=="admin@gmail.com" &&
      password=="Admin1234"){


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful"),
      ),
    );


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:(context)=> AdminDashboard(),
      ),
    );

  }

else {

  setState(() {
    isLoading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Invalid email or password"),
    ),
  );

}


},

                            style:ElevatedButton.styleFrom(

                              backgroundColor:
                              const Color(0xff2563EB),

elevation: 8,

shadowColor: Colors.black45,
                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(15),

                              ),

                            ),


                          child: isLoading
    ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
    : const Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

                          ),

                        ),



                        const SizedBox(height:20),



                        TextButton(

                          onPressed:(){

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder:(context)=>
                                const SignupPage(),

                              ),

                            );

                          },

                          child:const Text(

                            "Don't have an account? Sign Up",

                            style:TextStyle(

                              color:Colors.white,

                            ),

                          ),

                        ),


                      ],

                    ),

                  ),

                ),

              ),

            ),

          ),


        ],

      ),

    );

  }





  Widget featureCard(
      IconData icon,
      String text
      ){

    return Container(

      width:110,

      height:100,

      padding:
      const EdgeInsets.all(12),


      decoration:BoxDecoration(

        color:
        Colors.white.withOpacity(0.15),

        borderRadius:
        BorderRadius.circular(15),

      ),


      child:Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children:[

          Icon(

            icon,

            color:Colors.white,

            size:30,

          ),


          const SizedBox(height:8),


          Text(

            text,

            textAlign:
            TextAlign.center,

            style:const TextStyle(

              color:Colors.white,

              fontSize:12,

            ),

          ),

        ],

      ),

    );

  }






  Widget loginRoleCard(

      String title,

      String subtitle,

      IconData icon,

      Color color,

      ){

    return GestureDetector(

      onTap:(){

        setState((){

          selectedRole = title;

        });

      },

      child:Container(

        margin:
        const EdgeInsets.only(bottom:18),


        padding:
        const EdgeInsets.all(20),


        decoration:BoxDecoration(

         color:
Colors.blueGrey.withOpacity(0.18),


          borderRadius:
          BorderRadius.circular(22),


          border:Border.all(

            color:selectedRole==title
                ? color
                : Colors.white24,

            width:selectedRole==title ? 3 : 1,

          ),

        ),


      
        child:Row(

          children:[


            CircleAvatar(

              radius:28,

              backgroundColor:
              color.withOpacity(0.2),


              child:Icon(

                icon,

                color:color,

                size:30,

              ),

            ),


        
            const SizedBox(width:18),



            Expanded(

              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[


                  Text(

                    title,

                    style:TextStyle(

                      color:color,

                      fontSize:20,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

              

                  const SizedBox(height:5),



                  Text(

                    subtitle,

                    style:const TextStyle(

                      color:Colors.white70,

                      fontSize:13,

                    ),

                  ),


                ],

              ),

            ),

        

            Icon(

              Icons.arrow_forward_ios,

              color:color,

              size:18,

            ),


          ],

        ),

      ),

    );

  }

}
