import 'package:flutter/material.dart';
import 'package:module_11_live_class/Api/models/LoginResponseModel.dart';
import 'package:module_11_live_class/Api/models/Network_Response.dart';
import 'package:module_11_live_class/Api/models/auth_utility.dart';
import 'package:module_11_live_class/Api/services/Network_Caller.dart';
import 'package:module_11_live_class/Api/utils/url.dart';
import 'package:module_11_live_class/UI/screens/auth/SignUpScreen.dart';
import 'package:module_11_live_class/UI/screens/bottom_Nev_BaseScreen.dart';
import 'package:module_11_live_class/UI/screens/emailVarificationScreen.dart';
import 'package:module_11_live_class/Wigdets/Screen_Backgroud.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _loginInProgress = false;

  Future<void> login() async{
    _loginInProgress =true;
    if (mounted) {
      setState(() {});
    }
    Map<String,dynamic> requestBody ={

        "email":_emailTEController.text.trim(),
        "password":_passwordTEController.text

    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.login, requestBody);
       _loginInProgress = false;
    if (response.isSuccess) {
    LoginResponseModel model = LoginResponseModel.fromJson(response.body!);
    await Authutility.saveUserInfo(model);
     if (mounted) {
       Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(
               builder: (context) => const BottomNevBaseScreen()),
               (route) => false);
     }
    }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar
          (const SnackBar(content: Text('Incorrect email or password')));
      }

    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: ScreenBackground(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get Started with ',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(
                height: 10,
              ),
               TextFormField(
                 controller: _emailTEController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
               TextFormField(
                controller: _passwordTEController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: _loginInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator(),),
                  child: ElevatedButton(
                    onPressed: () {
                    login();
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ),
              const SizedBox(height:24,),
              Center(
                child: InkWell(
                  onTap: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const EmailVerificationScreen() ));
                  },
                  child: const Text(
                    'Forgot Password!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),),
                    const SizedBox(
                      width: 1,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                                (route) => false);
                      },
                      child: const Text('Sign Up',
                          style: TextStyle(color: Colors.green)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
