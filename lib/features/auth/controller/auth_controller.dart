import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AuthController(authRepository: authRepository);
});

class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  Future<void> signInWithGoogle(BuildContext context) async {
    await authRepository.signInWithGoogle(context);
  }

  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
    required bool mounted,
    required BuildContext context,
  }) async {
    authRepository.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
      mounted: mounted,
      context: context,
    );
  }

  void sendOTP({
    required String phone,
    required BuildContext context,
  }) async {
    authRepository.sendOTP(
      phone: phone,
      context: context,
    );
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}
