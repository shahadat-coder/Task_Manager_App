import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:module_11_live_class/Api/models/auth_utility.dart';
import 'package:module_11_live_class/UI/screens/UpdateProfile.dart';
import 'package:module_11_live_class/UI/screens/auth/loginScreen.dart';

class UserProfileBanner extends StatefulWidget {
  final bool? isUpdatedScreen;
  const UserProfileBanner({
    super.key, this.isUpdatedScreen = false,
  });

  @override
  State<UserProfileBanner> createState() => _UserProfileBannerState();
}

class _UserProfileBannerState extends State<UserProfileBanner> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(

      
      backgroundColor: Colors.green,

      title: InkWell(
        onTap: () {
          if ((widget.isUpdatedScreen ?? false) == false) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UpdateProfileScreen()));
          }
        },
        child: Visibility(
          visible: ((widget.isUpdatedScreen ?? false) == false) ,
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircleAvatar(
                   backgroundImage:  MemoryImage(
                     base64Decode(Authutility.userInfo.data!.photo!),
                   ),
                  onBackgroundImageError: (_,__){
                    const Icon(Icons.person);
                  },
                  radius: 15,
                ),
              ),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Authutility.userInfo.data?.firstName ?? ''} ${Authutility.userInfo.data?.lastName ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.white,
                  ),

                  ),
              Text(Authutility.userInfo.data?.email?? 'Unknown',
                style:const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
                ],
              ),
            ],
          ),
        ),
      ),

      actions:  [
          IconButton(
              onPressed: () async {
                await Authutility.clearUserInfo();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false);
                }

              },
              icon: const Icon(Icons.logout),
          ),
        ],

    );
  }
}