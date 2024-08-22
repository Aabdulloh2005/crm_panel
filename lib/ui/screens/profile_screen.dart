import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lesson_101/bloc/user/user_bloc.dart';
import 'package:lesson_101/ui/screens/edit_dialog_widget.dart';
import 'package:lesson_101/ui/widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String phone;
  late String email;
  late String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),

        actions: [
          IconButton(
            onPressed: () {
              print(photoUrl);
              showEditProfileDialog(context, name, phone, email, photoUrl);
            },

            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(

        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is UserError) {
                return Center(
                  child: Text(state.error),
                );
              }
              if (state is UserLoaded) {
                final user = state.userModel;
                name = user.name;
                phone = user.phone;
                email = user.email ?? "";
                photoUrl =
                    "http://millima.flutterwithakmaljon.uz/storage/avatars/${user.photo}" ??
                        "https://st3.depositphotos.com/9998432/13335/v/1600/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg";
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                "http://millima.flutterwithakmaljon.uz/storage/avatars/${user.photo}" ??
                                    "https://st3.depositphotos.com/9998432/13335/v/1600/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg"),
                          ),
                          const Gap(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Name: ${user.name}",
                                fontSize: 18,
                              ),
                              CustomText(
                                text: "Phone: ${user.phone}",
                                fontSize: 16,
                              ),
                              CustomText(text: "Role: ${user.role.name}")
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("statelarga tushmadi"),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
