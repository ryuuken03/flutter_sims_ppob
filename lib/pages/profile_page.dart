import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sims/pages/login_page.dart';
import 'package:sims/provider/home_provider.dart';
import 'package:sims/provider/profile_provider.dart';
import 'package:sims/widgets/dialog/dialog_alert_ask.dart';
import 'package:sims/widgets/dialog/dialog_alert_result.dart';
import 'package:sims/widgets/elevated_button/elevated_button_red.dart';
import 'package:sims/widgets/elevated_button/elevated_button_red_outline.dart';
import 'package:sims/widgets/text_field/email_text_field.dart';
import 'package:sims/widgets/text_field/name_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String routeName = "/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var firstNameController = TextEditingController();
    var lastNameController = TextEditingController();

    File? galleryFile;
    final picker = ImagePicker();

    Future getImage(
      ImageSource img,
    ) async {
      final pickedFile = await picker.pickImage(source: img);
      XFile? xfilePick = pickedFile;
      setState(
        () {
          if (xfilePick != null) {
            galleryFile = File(pickedFile!.path);
            var provider = Provider.of<ProfileProvider>(context, listen: false);
            provider.imageProfile(galleryFile!);
            var prov =
                Provider.of<HomeProvider>(context, listen: false);
            prov.getProfile();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    }

    void showPicker(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if(!provider.isLogout){
            if(!provider.loading && provider.data != null){
              if(!provider.isEdit){
                emailController.text = provider.data!.email!;
                firstNameController.text = provider.data!.first_name!;
                lastNameController.text = provider.data!.last_name!;
              }
            }
            if(provider.token == ""){
              provider.checkToken();
            }else if (provider.data == null) {
              provider.getProfile();
            }
            if(provider.successType > 0){
              var isSuccess = provider.successType == 1;
              var message = "gagal";
              if (isSuccess) {
                message = "berhasil";
              } else {}
              provider.resetStatusType();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialogAlertResultSaveProfile(context, isSuccess, message);
              });
            }
          }else{
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print("Push to Login 2");
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            });
          }
          return Form(
            child: (!provider.loading && provider.data != null) && !provider.isLogout
              ? Container(
                  margin: EdgeInsets.all(20),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  showPicker(context);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              50),
                                          border: Border.all(
                                              width: 1, color: Colors.grey)),
                                      child: CircleAvatar(
                                        foregroundImage: NetworkImage(
                                          provider.data!.profile_image!
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage('assets/image/Profile.png'),
                                      ),
                                    ),
                                    Container(
                                      width: 110,
                                      height: 110,
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.fromLTRB(40, 40, 0, 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1, color: Colors.grey)),
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  provider.data!.first_name! + " "+
                                        provider.data!.last_name!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Text(
                                  "Email",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: EmailTextField(
                                    enable: false,
                                    errorMessage: "",
                                    emailController: emailController),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  "Nama Depan",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: NameTextField(
                                    enable: provider.isEdit,
                                    hint: "masukkan nama depan anda",
                                    errorMessage: provider.firstNameMessage,
                                    nameController: firstNameController),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  "Nama Belakang",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: NameTextField(
                                    enable: provider.isEdit,
                                    hint: "masukkan nama belakang anda",
                                    errorMessage: provider.lastNameMessage,
                                    nameController: lastNameController),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: 
                                ElevatedButtonRed(
                                    activeText: provider.isEdit
                                              ? "Simpan"
                                              : "Edit Profil",
                                    onPressed:() {
                                      if(provider.isEdit){
                                        provider.checkValidity(
                                          firstNameController.text,
                                          lastNameController.text,
                                        );
                                        if (WidgetsBinding.instance.window
                                                .viewInsets.bottom >
                                            0.0) {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                        }
                                        if (provider.isValid) {
                                          showDialogAlertAskSaveProfile(context,provider);
                                        }
                                      }else{
                                        provider.changeEdit();
                                      }
                                    },
                                    isActive: true,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: ElevatedButtonRedOutline(
                                    activeText: provider.isEdit ? "Batalkan" : "Logout",
                                    onPressed: (){
                                      if(provider.isEdit){
                                        provider.changeEdit();
                                      }else{
                                        showDialogAlertAskLogout(context, provider);
                                      }
                                    },
                                  )
                                ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: provider.responseMessage!= null,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          constraints: BoxConstraints.tightFor(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            color: Color(0xfffff5f3)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                  provider.responseMessage!= null 
                                  ?provider.responseMessage!
                                  :""
                              ),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: (){
                                    provider.removeResponseMessage();
                                  }, 
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                    size: 15,
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                    child: const CircularProgressIndicator(),
                  ),
                ),
          );
        },
      ),
    );
  }

  showDialogAlertAskLogout(BuildContext context, ProfileProvider provider) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogAlertAsk(
          desc: "Apakah anda ingin Logout?",
          isNext: true,
          negativeAction: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          positiveAction: () {
            Navigator.of(context, rootNavigator: true).pop();
            provider.logout();
          },
          positiveActionText: "Ya, lanjutkan Logout",
        );
      }
    );
  }
  showDialogAlertAskSaveProfile(BuildContext context, ProfileProvider provider) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogAlertAsk(
          desc: "Apakah anda ingin menyimpan Profil?",
          isNext: true,
          negativeAction: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          positiveAction: () {
            provider.updateProfile();
            Navigator.of(context, rootNavigator: true).pop();
          },
          positiveActionText: "Ya, lanjutkan!",
        );
      }
    );
  }

  showDialogAlertResultSaveProfile(BuildContext context, bool isSuccess, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogAlertResult(
            desc: "Profil telah diperbarui",
            desc2: message,
            isSuccess: isSuccess,
            action: () {
              var prov = Provider.of<HomeProvider>(context,
                  listen: false);
              prov.getProfile();
              Navigator.of(context, rootNavigator: true).pop();
            },
            actionText: "Kembali",
          );
        });
  }
}

