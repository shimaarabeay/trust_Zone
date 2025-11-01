import 'package:my_trust_zone/features/chat/chat/data/models/conversation.dart';
import 'package:my_trust_zone/features/chat/chat/domain/repos/messages_repo.dart';

class CreateConversationUseCase {
  final ChatRepository repo;
  CreateConversationUseCase(this.repo);

  Future<ConversationModel> call(String user2Id) => repo.createConversation(user2Id);
}
