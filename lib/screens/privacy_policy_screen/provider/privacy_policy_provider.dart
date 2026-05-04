import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/base_repository.dart';

final privacyPolicyProvider = FutureProvider<String>((ref) async {
  return await BaseRepository.instance.privacyPolicy();
});
