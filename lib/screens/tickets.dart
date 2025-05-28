import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theoriginalapp/main.dart';

class Tickets extends StatelessWidget {
  const Tickets({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        // Datos de los tickets
        final List<Map<String, String>> tickets = [
          {'title': 'Ticket 1', 'date': '01/02/2025'},
          {'title': 'Ticket 2', 'date': '02/02/2025'},
        ];
        return Scaffold(  //aqui se construye la pantalla
          appBar: AppBar( 
            title: const Text( 
              'Mis Tickets', // Texto de la AppBar
              style: TextStyle(color: Colors.white), // Texto en color blanco
            ),
            centerTitle: true,
            backgroundColor: isDark ? Colors.black : Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF5F5F5),
                        Color(0xFFEEEEEE),
                        Color(0xFFC2C1C1),
                        Color(0xFFC2C1C1),
                      ],
                    ),
              color: isDark ? Colors.black : null,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = tickets[index];
                          return Card(
                            color: isDark ? Colors.grey[900] : const Color(0xFFA1A1A1),
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                ticket['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                'Fecha: ${ticket['date']}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
