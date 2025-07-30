import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/shared/widgets/news_widget.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>
      (
        listener: (context, state) {
          
        },
        builder: (context, state){
          var business = NewsCubit.get(context).businessData;
          return  business.isNotEmpty ?
            ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index) => NewsWidget(model: business[index]),
              separatorBuilder: (context,index) => Padding(padding: const EdgeInsets.all(8.0), child: Divider(),), 
              itemCount: business.length) :
            Center(
              child: CircularProgressIndicator(),
            );
   
        }, 
      );
    }
}