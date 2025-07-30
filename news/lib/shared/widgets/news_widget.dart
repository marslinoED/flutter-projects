import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/cubit.dart';
import 'package:news/shared/cubit/states.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key, required this.model});

  final model;

  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = NewsCubit.get(context);
        return InkWell(
          onTap: (){
            // NewsCubit.get(context).launchURL(model['url']); <-- Not Android ابقي سرش
              
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WebViewScreen(url: model['url'])), // Navigate to SecondScreen
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage('${model['urlToImage']}'),
                      fit: BoxFit.cover,
                      )
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: cubit.isEn ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text('${model['title']}', 
                          // textAlign: TextAlign.start,
                          textDirection: cubit.isEn ? TextDirection.ltr : TextDirection.rtl,
                            style: TextStyle(
                            fontSize: 16, 
                            
                            fontWeight: FontWeight.w600),
                            maxLines: 4,
                            overflow:  TextOverflow.ellipsis,
                          ),
                        ),
                    
                        Text('${model['publishedAt'].substring(0, 10)}',
                          style: TextStyle(
                          color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),      
              ],
            ),
          ),
        );
      },
    );
  }
}