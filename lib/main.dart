import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

//START
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//PUBLICKEY
final publicKey = "TEST-272818e9-8110-4952-8a6e-057814527aef";

final Dio dio = Dio();

Future<void> postMerc() async {
  //link
  final endpoint =
      'https://api.mercadopago.com/checkout/preferences?access_token=TEST-3580340282910535-022101-27f1bf5467c68f87dbf3b1ef946b166b-604603631';

  try {
    final data = {
      "items": [
        {
          "title": "Titulo do produto",
          "description": "Des do produto",
          "quantity": 1,
          "currency_id": "BRL",
          //preço
          "unit_price": 5,
        }
      ],
      "payer": {"email": "ok@gmail.com"},
      "payment_methods": {
        "excluded_payment_types": [
          //boleto == null
          {"id": "ticket"}
        ],
        //total de parcelas aceitas
        "installments": 1
      }
    };
    final response = await dio.post(endpoint, data: data);
    // INICIANDO CHECKOUT
    PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(
        publicKey, response.data['id']);
  } on DioError catch (e) {
    print('erro');
    return e.error('Inválido');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mercado Pago'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            postMerc();
          },
          child: Text('Pagemento'),
        ),
      ),
    );
  }
}
