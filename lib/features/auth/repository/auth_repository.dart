import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/helpers/db_helpers.dart';

import '../../../common/routes/routes.dart';
import '../../../common/widgets/custom_alert.dart';

// Make provider for AuthRepository accessible to all widgets
final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;

  AuthRepository({required this.auth});

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await auth.signInWithPopup(
        GoogleAuthProvider(),
      );

      return googleUser.user;
    } catch (e) {
      if (Platform.isIOS) {
        if (context.mounted) {
          CustomCupertinoAlertDialog.show(
            context,
            'Error',
            e.toString(),
          );
        }
      } else {
        if (context.mounted) {
          CustomCupertinoAlertDialog.showAlertDialog(
            context: context,
            title: 'Error',
            content: e.toString(),
            buttonText: 'OK',
          );
        }
      }
    }
    return null;
  }

  void verifyOTP({
    required String verificationId,
    required String smsCode,
    required bool mounted,
    required BuildContext context,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      if (!mounted) {
        return;
      }
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    } on FirebaseAuth catch (e) {
      print(e.toString());
      if (Platform.isIOS) {
        CustomCupertinoAlertDialog.show(
          context,
          'Error',
          e.toString(),
        );
      } else {
        CustomCupertinoAlertDialog.showAlertDialog(
          context: context,
          title: 'Error',
          content: e.toString(),
          buttonText: 'OK',
        );
      }
    } on SocketException catch (e) {
      if (Platform.isIOS) {
        CustomCupertinoAlertDialog.show(
          context,
          'Error',
          e.toString(),
        );
      } else {
        CustomCupertinoAlertDialog.showAlertDialog(
          context: context,
          title: 'Error',
          content: e.toString(),
          buttonText: 'OK',
        );
      }
    } catch (e) {
      if (Platform.isIOS) {
        CustomCupertinoAlertDialog.show(
          context,
          'Error',
          e.toString(),
        );
      } else {
        CustomCupertinoAlertDialog.showAlertDialog(
          context: context,
          title: 'Error',
          content: e.toString(),
          buttonText: 'OK',
        );
      }
    }
  }

  void sendOTP({
    required String phone,
    required BuildContext context,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.home, (route) => false);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.toString());
          if (e.code == 'invalid-phone-number') {
            if (Platform.isIOS) {
              CustomCupertinoAlertDialog.show(
                context,
                'Error',
                e.toString(),
              );
            } else {
              CustomCupertinoAlertDialog.showAlertDialog(
                context: context,
                title: 'Error',
                content: e.toString(),
                buttonText: 'OK',
              );
            }
          } else if (e.code == 'too-many-requests') {
            if (Platform.isIOS) {
              CustomCupertinoAlertDialog.show(
                context,
                'Error',
                e.toString(),
              );
            } else {
              CustomCupertinoAlertDialog.showAlertDialog(
                context: context,
                title: 'Error',
                content: e.toString(),
                buttonText: 'OK',
              );
            }
          } else {
            if (Platform.isIOS) {
              CustomCupertinoAlertDialog.show(
                context,
                'Error',
                e.toString(),
              );
            } else {
              CustomCupertinoAlertDialog.showAlertDialog(
                context: context,
                title: 'Error',
                content: e.toString(),
                buttonText: 'OK',
              );
            }
          }

          // if (Platform.isIOS) {
          //   CustomCupertinoAlertDialog.show(
          //     context,
          //     'Error',
          //     e.toString(),
          //   );
          // } else {
          //   CustomCupertinoAlertDialog.showAlertDialog(
          //     context: context,
          //     title: 'Error',
          //     content: e.toString(),
          //     buttonText: 'OK',
          //   );
          // }
        },
        codeSent: (String verificationId, int? resendToken) {
          DBHelper.createUser(1);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.otp,
            arguments: {
              'verificationId': verificationId,
              'phone': phone,
            },
            (route) => false,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-phone-number':
          if (Platform.isIOS) {
            if (context.mounted) {
              CustomCupertinoAlertDialog.show(
                context,
                'Error',
                e.toString(),
              );
            }
          } else {
            if (context.mounted) {
              CustomCupertinoAlertDialog.showAlertDialog(
                context: context,
                title: 'Error',
                content: e.toString(),
                buttonText: 'OK',
              );
            }
          }
          break;
        case 'too-many-requests':
          if (Platform.isIOS) {
            if (context.mounted) {
              CustomCupertinoAlertDialog.show(
                context,
                'Error',
                e.toString(),
              );
            }
          } else {
            if (context.mounted) {
              CustomCupertinoAlertDialog.showAlertDialog(
                context: context,
                title: 'Error',
                content: e.toString(),
                buttonText: 'OK',
              );
            }
          }
        default:
          if (Platform.isIOS) {
            if (context.mounted) {
              CustomCupertinoAlertDialog.show(
                context,
                'Error',
                e.toString(),
              );
            }
          } else {
            if (context.mounted) {
              CustomCupertinoAlertDialog.showAlertDialog(
                context: context,
                title: 'Error',
                content: e.toString(),
                buttonText: 'OK',
              );
            }
          }
      }

      // if (Platform.isIOS) {
      //   if (context.mounted) {
      //     CustomCupertinoAlertDialog.show(
      //       context,
      //       'Error',
      //       e.toString(),
      //     );
      //   }
      // } else {
      //   if (context.mounted) {
      //     CustomCupertinoAlertDialog.showAlertDialog(
      //       context: context,
      //       title: 'Error',
      //       content: e.toString(),
      //       buttonText: 'OK',
      //     );
      //   }
      // }
    } on SocketException catch (e) {
      if (Platform.isIOS) {
        if (context.mounted) {
          CustomCupertinoAlertDialog.show(
            context,
            'Error',
            e.toString(),
          );
        }
      } else {
        if (context.mounted) {
          CustomCupertinoAlertDialog.showAlertDialog(
            context: context,
            title: 'Error',
            content: e.toString(),
            buttonText: 'OK',
          );
        }
      }
    } catch (e) {
      if (Platform.isIOS) {
        if (context.mounted) {
          CustomCupertinoAlertDialog.show(
            context,
            'Error',
            e.toString(),
          );
        }
      } else {
        if (context.mounted) {
          CustomCupertinoAlertDialog.showAlertDialog(
            context: context,
            title: 'Error',
            content: e.toString(),
            buttonText: 'OK',
          );
        }
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
