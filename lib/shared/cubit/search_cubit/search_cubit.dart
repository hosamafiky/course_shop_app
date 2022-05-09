import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/end_points.dart';
import 'package:shop_app/shared/cubit/search_cubit/search_states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/search_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search({String? text}) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: SEARCH,
      data: {'text': text},
      token: token,
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      print('Error in searching : ${error.toString()}');
      emit(SearchErrorState());
    });
  }
}
