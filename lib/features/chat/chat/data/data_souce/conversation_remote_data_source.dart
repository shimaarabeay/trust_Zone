import 'package:dio/dio.dart';
import 'package:my_trust_zone/features/chat/chat/data/models/conversation.dart';
import 'package:my_trust_zone/utils/token_helper.dart';

class ConversationRemoteDataSource {
  final Dio dio;

  ConversationRemoteDataSource(this.dio);

  Future<List<ConversationModel>> getConversations({
    required int page,
    required int pageSize,
    required String token,
  }) async {
    // جلب userId من TokenHelper هنا مش من مكان تاني
    final currentUserId = await TokenHelper.getUserId();

    final response = await dio.get(
      'https://trustzone.azurewebsites.net/api/Conversation/user',
      queryParameters: {'page': page, 'pageSize': pageSize},
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }),
    );

    final data = response.data;

    if (data is List && currentUserId != null) {
      return data
          .map((json) => ConversationModel.fromJson(
              Map<String, dynamic>.from(json), currentUserId))
          .toList();
    } else {
      throw Exception("Unexpected response or missing userId");
    }
  }
}
