import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/home_cubit/home_cubit.dart';
import 'package:shop_app/shared/cubit/home_cubit/home_states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeSuccessChangeFavoritesDataState) {
          if (!state.changeFavoriteModel.status!) {
            showToast(
              text: state.changeFavoriteModel.message!,
              state: ToastState.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          body: ConditionalBuilder(
            condition: cubit.homeModel != null && cubit.categoriesModel != null,
            builder: (context) => buildProductsPage(
                cubit.homeModel!, cubit.categoriesModel!, cubit),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  Widget buildProductsPage(
      HomeModel homeModel, CategoriesModel categoriesModel, cubit) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: homeModel.data!.banners
                .map((e) => Image(
                      image: NetworkImage(e.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ))
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              height: 200.0,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayInterval: const Duration(seconds: 3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 100.0,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => buildCategoryListItems(
                        categoriesModel.data!.categoriesData[index], cubit),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10.0),
                    itemCount: categoriesModel.data!.categoriesData.length,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Latest Products',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            color: Colors.grey[200],
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.51,
              children: List.generate(
                homeModel.data!.products.length,
                (index) =>
                    buildGridItem(homeModel.data!.products[index], cubit),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryListItems(CategoryModel model, cubit) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
              model.image!,
            ),
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100.0,
            color: Colors.black.withOpacity(0.6),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Text(
              capitalize(model.name!),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      );
  Widget buildGridItem(ProductModel product, cubit) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image(
                image: NetworkImage(product.image!),
                height: 200.0,
              ),
              if (product.discount != 0)
                Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3.0, vertical: 1.0),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Text(
                      '${product.price!.round().toString()} \$',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (product.discount != 0)
                      Text(
                        '${product.oldPrice!.round().toString()} \$',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    IconButton(
                      icon: CircleAvatar(
                        radius: 12.0,
                        backgroundColor: cubit.favorites[product.id]
                            ? Colors.deepOrange
                            : Colors.grey[200],
                        child: const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                      onPressed: () {
                        cubit.changeFavoriteData(product.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
