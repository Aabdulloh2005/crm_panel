import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson_101/bloc/user/user_bloc.dart';
import 'package:lesson_101/data/service/user_service.dart';

Future<void> showEditProfileDialog(BuildContext context, String initialName,
    String initialPhone, String initialEmail, String initialPhotoUrl) {
  final TextEditingController nameController =
      TextEditingController(text: initialName);
  final TextEditingController phoneController =
      TextEditingController(text: initialPhone);
  final TextEditingController emailController =
      TextEditingController(text: initialEmail);
  String? imagePath;
  String? networkImageUrl = initialPhotoUrl.isNotEmpty ? initialPhotoUrl : null;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  XFile? xfile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 10,
                  );
                  if (xfile != null) {
                    imagePath = xfile.path;
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: imagePath != null
                      ? FileImage(File(imagePath!))
                      : (networkImageUrl != null
                              ? NetworkImage(networkImageUrl)
                              : const AssetImage('assets/default_profile.png'))
                          as ImageProvider,
                ),
              ),
              const Gap(16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const Gap(8),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const Gap(8),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              Navigator.of(context).pop({
                'name': nameController.text,
                'phone': phoneController.text,
                'email': emailController.text,
                'photo': imagePath ?? networkImageUrl,
              });

              context.read<UserBloc>().add(
                    UpdateUserEvent(
                      name: nameController.text,
                      photoUrl: imagePath ?? networkImageUrl!,
                      email: emailController.text,
                      phone: phoneController.text,
                    ),
                  );
            },
          ),
        ],
      );
    },
  );
}
