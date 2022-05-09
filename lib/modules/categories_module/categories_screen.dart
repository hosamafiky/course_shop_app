import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../shared/cubit/home_cubit/home_cubit.dart';
import '../../shared/cubit/home_cubit/home_states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildCategoryListItem(
              cubit.categoriesModel!.data!.categoriesData[index]),
          itemCount: cubit.categoriesModel!.data!.categoriesData.length,
        );
      },
    );
  }

  Widget buildCategoryListItem(CategoryModel model) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image(
                image: NetworkImage(
                  model.image!,
                ),
                width: 130.0,
                height: 130.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                capitalize(model.name!),
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_outlined),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
