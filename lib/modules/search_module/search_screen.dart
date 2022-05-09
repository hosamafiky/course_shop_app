import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/search_cubit/search_cubit.dart';
import 'package:shop_app/shared/cubit/search_cubit/search_states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      validateFunc: (value) {
                        if (value!.isEmpty) {
                          return 'Search field is empty, please enter some words';
                        }
                        return null;
                      },
                      label: 'Search',
                      prefix: Icons.search,
                      onSubmit: (value) {
                        SearchCubit.get(context).search(text: value);
                        return null;
                      },
                    ),
                    if (state is SearchLoadingState) ...[
                      const SizedBox(height: 20.0),
                      const LinearProgressIndicator(),
                    ],
                    const SizedBox(height: 10.0),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildListItem(
                            cubit.model!.data!.data![index],
                            context,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10.0),
                          itemCount: cubit.model!.data!.data!.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
