import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gob_cordoba/models/models.dart';
import 'package:gob_cordoba/provider/db_provider.dart';
import 'package:gob_cordoba/provider/scan_list_provider.dart';
import 'package:gob_cordoba/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class CarnetService extends ChangeNotifier{

  final String _baseUrl = 'flutter-73f8f-default-rtdb.firebaseio.com';
  late Carnet? carnets ;
  final storage = new FlutterSecureStorage();
  List<ScanModel> scans = [];
   
   ScanListProvider base= new ScanListProvider();

  File? newPictureFile;
  bool isLoading = false;
  bool isSaving = false;

  CarnetService(){
    this.loadCartUser();

  }

 Future<String>readData()async{
  return  await storage.read(key:'data') ?? '';
  }
 
  // TODO: 
   Future <Carnet> loadCartUser() async {
    //isLoading = true;
    //notifyListeners();
    // Carnet dato = Carnet();
    // final url = Uri.https( _baseUrl, 'gob/empleado.json');
    // final resp = await http.get(url);
    // final  productsMap= json.decode(resp.body);
    // Carnet dato = Carnet();
    // dato=Carnet.fromJson(productsMap);
    // final tempScan = new Carnet(birthday: 'd', carg: 'duu', documentId: 1, email: 'luis.gmail.com', fechaingreso: '5/6/2001', firstname: 'Luis', plant: 'Secretario', secondsname: 'Pedro', sex: 'M');


    Carnet dato1 = Carnet();

   final firstname= await storage.read(key:'firstname') ?? '';
   final document= await storage.read(key:'documentId') ?? '';
   print(document+ 'ijlljj');
    if( firstname != '' ){
         int documentId= int.parse('$document');
        Carnet dato1 = Carnet(firstname: '$firstname' , documentId: documentId);
        return dato1;
    }else{
    final url = Uri.https( _baseUrl, 'gob/empleado.json');
    final resp = await http.get(url);
    final  productsMap= json.decode(resp.body);
    Carnet dato = Carnet();
    dato=Carnet.fromJson(productsMap);
    String document= dato.documentId.toString();
    //print(document);
    await storage.write(key: 'documentId', value: document );
    await storage.write(key: 'birthday', value: dato.birthday);
    await storage.write(key: 'carg', value: dato.carg);
    await storage.write(key: 'email', value: dato.email);
    await storage.write(key: 'fechaingreso', value: dato.fechaingreso);
    await storage.write(key: 'firstname', value: dato.firstname);
    await storage.write(key: 'plant', value: dato.plant);
    await storage.write(key: 'secondsname', value: dato.secondsname);
    await storage.write(key: 'sex', value: dato.sex);
    return dato;    



    }
  }


  Future <ScanModel> loadCarstAdmin( int documentId) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https( _baseUrl, 'gob.json');
    final resp = await http.get(url);
    final  productsMap= json.decode(resp.body);
    isLoading= false;
    notifyListeners();
    ScanModel scans1= ScanModel();

    try {
       await Future.delayed(const Duration(seconds: 4));
      
    } catch (e) {
    }

    if(isLoading==true)
    {
    }else{
     final ScanModel scans= await DBProvider.db.getScanById(12);
     if(scans.tipo==null){
       print('null');
     }else{
       return scans;
     }  
    }
    return scans1;
    // return null;    
  }
  
  // Future saveOrCreateProduct( Product product) async {
  //   isSaving = true;
  //   notifyListeners();

  //   if ( product.id == null){
  //     await this.createProduct(product);
  //   }else{
  //     await this.updateProduct(product); 
  //   }
  //   isSaving= false;
  //   notifyListeners();
  // }

  // Future<String> updateProduct(Product product ) async{
  //   final url = Uri.https( _baseUrl, 'Products/${product.id}.json');
  //   final resp = await http.put(url, body: product.toJson()  );
  //   final decodedData= resp.body;
  //    final index= this.products.indexWhere((element)=> element.id == product.id);
  //    this.products[index]= product;
  //    return product.id!;
  // }

  //  Future<String> createProduct(Product product ) async{


  //   final url = Uri.https( _baseUrl, 'Products.json', {
  //     'auth': await storage.read(key: 'token') ?? '',
  //   });
  //   final resp = await http.post(url, body: product.toJson()  );
  //   final decodedData= json.decode(resp.body);
  //   product.id= decodedData['name'];
  //   this.products.add(product);
  //   print(decodedData);
  //   return product.id!;

  // }

  // void updateSelectedProductImage( String path){
    
  //   this.selectedProduct.picture = path;
  //   this.newPictureFile = File.fromUri(Uri(path: path));

  //   notifyListeners();
  // }

  // Future<String?>uploadImage() async {
  //   if( this.newPictureFile == null) return null;

  //   this.isSaving= true;
  //    notifyListeners();
  //    final url = Uri.parse('https://api.cloudinary.com/v1_1/dve1nfb9j/image/upload?upload_preset=yqeniftu');
  //    final imageUploadRequest = http.MultipartRequest('POST',url);
  //    final file= await http.MultipartFile.fromPath('file', newPictureFile!.path);
  //    imageUploadRequest.files.add(file);
  //    final streamResponse= await imageUploadRequest.send();
  //    final resp = await http.Response.fromStream(streamResponse);
  //   if(resp.statusCode != 200 && resp.statusCode != 201){
  //     print('Algo salio mal');
  //     print(resp.body);
  //     return null;
  //   }
  //   this.newPictureFile=null;
  //   final decodedData = json.decode(resp.body);
  //   return decodedData['secure_url'];

  // }




}