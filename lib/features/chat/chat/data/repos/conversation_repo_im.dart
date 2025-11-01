import 'package:my_trust_zone/features/chat/chat/data/data_souce/conversation_remote_data_source.dart';
import 'package:my_trust_zone/features/chat/chat/domain/entities/conversation_entity.dart';
import 'package:my_trust_zone/features/chat/chat/domain/repos/conversation_repo.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;

  ConversationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ConversationEntity>> getConversations(int page, int pageSize, String token) {
    return remoteDataSource.getConversations(
      page: page,
      pageSize: pageSize,
      token: token,
    );
  }
}
