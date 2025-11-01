import 'package:my_trust_zone/features/chat/chat/domain/entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> getConversations(
    int page,
    int pageSize,
    String token,
  );
}
