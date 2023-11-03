import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';



class ProductListing extends StatefulWidget {
  const ProductListing({super.key});

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {

  List<dynamic> list=[];
  
  Future<List<dynamic>> getProducts()async{
    final response=await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if(response.statusCode==200){
        return jsonDecode(response.body.toString());
    }else{
      throw Exception('Error Exist While Fetching');
    }
  }
    static String s="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE0E0E0),
      body:Column(
        children: [
          Expanded(
            child: FutureBuilder(future: getProducts(), builder: (context,AsyncSnapshot<List<dynamic>> snapshot){
              if(!snapshot.hasData){
                return const CircularProgressIndicator(
                    color: Colors.red,
                );
              }else{
                return GridView.builder(
                    itemCount:snapshot.data!.length,
                    gridDelegate:const
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                        crossAxisSpacing: 2,childAspectRatio:0.5,mainAxisSpacing: 5
                    ),
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                              color:Color(0xffFAFAFA),
                          ),

                          child:Builder(
                              builder: (context) {
                                return Column(
                                  children: [
                                    Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                      child:  Container(
                                        width:double.infinity,
                                        height: 200,
                                        decoration:BoxDecoration(
                                           borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(snapshot.data![index]['image'].toString()),
                                            )
                                        ),
                                      ),
                                    ),


                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RatingBarIndicator(
                                            rating:double.parse(snapshot.data![index]['rating']['rate'].toString() ),
                                            itemBuilder: (context, index) =>const Icon(
                                              Icons.star,
                                              color: Colors.black,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                          const Icon(Icons.favorite_border_outlined)
                                        ],
                                      ),
                                    ),

                                    Align(
                                      alignment: Alignment.center
                                        ,child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                          child: ReadMoreText(
                                     snapshot.data![index]['title'].toString(),style:GoogleFonts.lato(textStyle: TextStyle(
                                            fontSize: 17,letterSpacing: 1,fontWeight: FontWeight.bold,color: Colors.black45

                                          )),
                                      trimLines: 1,
                                      colorClickableText: Colors.pink,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '',
                                      trimExpandedText: '',
                                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                        )),
                                    Text("Rs."+snapshot.data![index]['price'].toString(),style: GoogleFonts.aBeeZee(textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.black45)),),

                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                     child: Container(
                                       height: 40,
                                       decoration: BoxDecoration(
                                         color: Color(0xffE0E0E0),
                                         borderRadius: BorderRadius.circular(10)
                                       ),

                                       child:Row(
                                         mainAxisAlignment:MainAxisAlignment.center
                                         ,children: [
                                           Icon(Icons.add_shopping_cart,color: Colors.black54,size: 30,),
                                           SizedBox(width: 5,),
                                           Text('Add to Cart',style:GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20,color: Colors.black54)))
                                         ],
                                       ),
                                     ),
                                   )


                                  ],
                                );
                              }
                          ),
                        ),
                      );
                    }
                );
              }

            }),
          ),

        ],
      )
    );
  }
}
