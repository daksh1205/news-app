import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_app_clean_architecture/core/resources/data_state.dart';
import 'package:new_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:new_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:new_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticlesBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesBloc(this._getArticleUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
  }

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticleState> emit) async {
    final dataState = await _getArticleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteArticlesDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      log(dataState.error!.message.toString());
      emit(RemoteArticlesError(dataState.error!));
    }
  }
}
