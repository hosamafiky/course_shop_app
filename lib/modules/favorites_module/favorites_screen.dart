import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/favorite_model.dart';
import '../../shared/cubit/home_cubit/home_cubit.dart';
import '../../shared/cubit/home_cubit/home_states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildFavoriteListItem(
            cubit.favoriteModel!.data!.data![index].product!,
            cubit,
          ),
          itemCount: cubit.favoriteModel!.data!.data!.length,
        );
      },
    );
  }

  Widget buildFavoriteListItem(Product product, cubit) => Container(
        height: 120.0,
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            SizedBox(
              width: 120.0,
              height: 120.0,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image(
                    image: NetworkImage(product.image!),
                    height: 120.0,
                    width: 120.0,
                  ),
                  if (product.discount! != 0)
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
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        product.price!.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      if (product.discount! != 0)
                        Text(
                          product.oldPrice!.toString(),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14.0,
                          ),
                        ),
                      const Spacer(),
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
