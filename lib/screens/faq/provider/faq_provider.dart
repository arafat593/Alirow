import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/services/repository/base_repository.dart';

final faqProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await BaseRepository.instance.getFaqs();
});
