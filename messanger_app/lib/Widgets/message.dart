import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key, this.imageUrl, this.name, this.lastMessage});
final String? imageUrl;
final String? name;
final String? lastMessage;

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 50,
      child: Row(
            children: [
              CircleAvatar(
                radius: 30, // Adjust size as needed
                backgroundImage: AssetImage(imageUrl ?? "assets/images/myProfilePic.jpg"),
                   ),
            
          SizedBox(width: 4,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? "Marslino Edward", // Replace space with new line
                textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Ensures long names don’t break UI
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold, 
      
                    )
              ),
              Text(
                lastMessage ?? "Last Message", // Replace space with new line
                textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // Ensures long names don’t break UI
                  style: const TextStyle(
                    fontSize: 9, 
                    )
              ),
            ],
          ),
            ]
      ),
    );
              
              
  }
}
