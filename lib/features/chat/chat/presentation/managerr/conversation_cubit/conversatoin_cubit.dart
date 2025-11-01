import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_trust_zone/features/chat/chat/domain/entities/conversation_entity.dart';
import 'package:my_trust_zone/features/chat/chat/domain/usecases/get_conversation_usecase.dart';
import 'package:my_trust_zone/features/chat/chat/presentation/managerr/conversation_cubit/conversation_state.dart';
import 'package:my_trust_zone/utils/token_helper.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final GetConversationsUseCase useCase;

  ConversationCubit(this.useCase) : super(ConversationInitial());

  Future<void> fetchConversations(int page, int pageSize) async {
    emit(ConversationLoading());
    try {
      final token = await TokenHelper.getToken();
      final currentUserId = await TokenHelper.getUserId();

      if (token == null || currentUserId == null) {
        emit(ConversationError('Token or user ID not found.'));
        return;
      }

      final conversations = await useCase(page, pageSize, token);
      emit(ConversationLoaded(conversations));
    } catch (e) {
      emit(ConversationError('Failed to load conversations: $e'));
    }
  }
}
