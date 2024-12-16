import 'package:flutter/material.dart';
//import 'package:gabriela/pantalla_carga.dart';
import '../../../shared/widgets/Animations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {return const MaterialApp(
      title: "gabriela",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF398AD5),
        title: null,
        elevation: 0,
      ),





      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF398AD5),
              Color(0xFFF8F8F8),
            ],
          ),
        ),
        child: Align(alignment: Alignment.topLeft, 
          child: Padding(padding:const EdgeInsets.all(20.0), 
            child: Column(crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                const Text( "ALKIUM",style: TextStyle(color: Colors.white, fontSize: 40),),
                const Text("Desarrollo personal,\nmental y emocional",style: TextStyle(color: Colors.white, fontSize: 25),),
                const Text("Psicología Clínica", style: TextStyle(color: Colors.white, fontSize: 16),),
                const SizedBox(height: 23),
                Container(
                  width: 139,
                  height: 50,
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFAEFFFF), Color(0xFF497FC8),],begin: Alignment.topCenter, end: Alignment.bottomCenter,),borderRadius: BorderRadius.all(Radius.circular(60)),),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    onPressed: () {
                      //Navigator.pushAndRemoveUntil(context,fade(const PantallaCarga()),(Route<dynamic> route) => false,);
                    },
                    child: const Text( "INICIAR",style: TextStyle(color: Colors.white,fontSize: 18,),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'img/marciano.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'img/pie.png',
                    width: 100,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),


              ],
            ),
          ),
        ),
      ),

      
    );
  }
}

