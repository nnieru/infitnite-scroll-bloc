import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import "package:equatable/equatable.dart";
import "../model/post.dart";
import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:http/http.dart' as http;
part 'post_event.dart';
part 'post_state.dart';

const throttleDuration = Duration(milliseconds: 100);
EventTransformer<E> trotthleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  
  final http.Client httpClient;
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostEventFetched>(_onPostFetched, transformer: trotthleDroppable(throttleDuration));
  }

  Future<void> _onPostFetched(PostEventFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchedPost(state.posts.length);
        emit(state.copyWith(
          status: PostStatus.sucess,
          posts: posts,
          hasReachedMax: false,
        ));
      }

      final posts = await _fetchedPost(state.posts.length);
      emit(posts.isEmpty ? state.copyWith(hasReachedMax: true) :
        state.copyWith(
         hasReachedMax: false,
         status: PostStatus.sucess,
         posts: List.of(state.posts)..addAll(posts)
        )
      );

    } catch(_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }


  Future<List<Post>> _fetchedPost(int index) async {

    Map<String,String> params =  {
      '_start': '$index', '_limit': 20.toString()
    };

    final response = await httpClient.get(Uri.https("jsonplaceholder.typicode.com", "/posts", params));
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception("Error fetching posts");
  }


}