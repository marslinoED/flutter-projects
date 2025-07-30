import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/screens/search/cubit/search_states.dart';
import 'package:shopping/shared/constraints/constants.dart';
import 'package:shopping/shared/models/search_models.dart';
import 'package:shopping/shared/network/end_points.dart';
import 'package:shopping/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {
    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      token: token ?? '',
      data: {
        'text': text,
      },
    ).then((value)
    {


      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}