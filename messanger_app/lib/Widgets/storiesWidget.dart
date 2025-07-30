import 'package:flutter/material.dart';

class Storieswidget extends StatelessWidget {
  const Storieswidget({super.key, this.imageUrl, this.name, this.isOnline});
final String? imageUrl;
final String? name;
final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: Column( 
        children: [Stack(
            children: [
              CircleAvatar(
                radius: 27, // Adjust size as needed
                backgroundImage: AssetImage(imageUrl ?? "assets/images/myProfilePic.jpg"),
                   ),
              if (isOnline ?? false) // Show green dot if online
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                )
                else
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                 )
      
                
            ],
          ),
          //SizedBox(height: 1), // Space between avatar and name
          Text(
            name ?? "Marslino Edward", 
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Ensures long names don’t break UI
            maxLines: 2,
            style: const TextStyle(
                fontSize: 9, 
                )
          )
        ],
                ),
    );
              
  }
}
