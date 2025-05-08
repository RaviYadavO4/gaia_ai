import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final email = auth.user?.email ?? "No Email";
    final name = auth.user?.displayName ?? "No Name";
    final photoUrl = auth.user?.photoURL;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: photoUrl != null
                ? NetworkImage(photoUrl)
                : AssetImage('assets/avatar.png') as ImageProvider,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(email, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              // logout using AuthProvider
              await Provider.of<AuthProvider>(context, listen: false).logout();

              // prevent back navigation to splash/home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
