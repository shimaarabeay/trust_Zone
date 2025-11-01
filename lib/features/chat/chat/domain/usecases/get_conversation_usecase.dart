import 'package:my_trust_zone/features/chat/chat/domain/entities/conversation_entity.dart';
import 'package:my_trust_zone/features/chat/chat/domain/repos/conversation_repo.dart';

class GetConversationsUseCase {
  final ConversationRepository repo;

  GetConversationsUseCase(this.repo);

  Future<List<ConversationEntity>> call(int page, int pageSize, String token) {
    return repo.getConversations(page, pageSize, token);
  }
}
