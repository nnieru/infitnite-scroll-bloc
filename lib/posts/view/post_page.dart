import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:http/http.dart" as http;
import "package:infinitelist/posts/bloc/post_bloc.dart";

import "post_list.dart";

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PostBloc(httpClient: http.Client())..add(PostEventFetched()),
        child: const PostList(),
      ),
    );
  }
}