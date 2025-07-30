import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/layout/cubit/app_cubit.dart';
import 'package:shopping/layout/cubit/app_states.dart';
import 'package:shopping/shared/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state)
          {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder: (context, index) => buildCatItem(AppCubit.get(context).categoryModel!.data.data[index]),
                separatorBuilder: (context, index) => Divider(color: Colors.grey,),
                itemCount: AppCubit.get(context).categoryModel!.data.data.length,
              ),
            );
          },
        );

  }
    Widget buildCatItem(DataModel model) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children:
          [
            Image(
              image: NetworkImage(model.image),
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              model.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
            ),
          ],
        ),
      );
  }
}
