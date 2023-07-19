import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mall_ukm/app/model/address/address_select.dart';
import 'package:mall_ukm/app/model/transaction/checkout_data.dart';
import 'package:mall_ukm/app/model/transaction/transaction_store_model.dart';
import 'package:mall_ukm/app/modules/checkout/views/webwiew.dart';
import 'package:mall_ukm/app/modules/navbar_page/controllers/navbar_page_controller.dart';
import 'package:mall_ukm/app/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutController extends GetxController {
  var controllerNav = Get.put(NavbarPageController());
  TextEditingController selectedCourier1 = TextEditingController();
  var selectedCourier = ''.obs;
  var selectedCourierFirst = '';
  final selectedService = ''.obs;
  final services = <dynamic>[].obs;
  final costValue = 0.0.obs;
  WebViewController ctr = WebViewController();
  var idkecamatan = '';
  var weight = ''.obs;
  RxList<RxInt> weight2 = <RxInt>[].obs;

  final List<String> couriers = ['jne', 'pos', 'tiki'];
  final List<String> layanan = ['jne', 'pos', 'tiki'];

  Future<TransaksiStore> tambahDataTransaksi(CheckoutData checkoutData) async {
    String? token = GetStorage().read('token');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse(ApiEndPoints.baseUrl +
        ApiEndPoints.transactionEndPoints
            .store); // Ganti URL sesuai dengan endpoint yang benar

    // Buat body request sesuai dengan contoh yang kamu berikan
    final body = jsonEncode(checkoutData.toJson());

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      // Jika berhasil, parse respons JSON ke dalam objek TransaksiStore
      TransaksiStore transaksi =
          TransaksiStore.fromJson(jsonDecode(response.body));

      // Lakukan redirect ke payment_url jika ada
      if (transaksi.data!.paymentUrl != null) {
        String paymentUrl = transaksi.data!.paymentUrl!;
        ctr = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(paymentUrl));

        Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                url: paymentUrl,
              ),
            ));
        print(paymentUrl);
      }

      return transaksi;
    } else {
      // Jika gagal, lempar exception atau lakukan penanganan kesalahan sesuai kebutuhan
      throw Exception(
          'Gagal menambahkan data transaksi. Status code: ${response.statusCode} ${response.body}');
    }
  }

  void fetchServices() async {
    String apiUrl = "https://pro.rajaongkir.com/api/cost";
    String origin = "109";
    String originType = "city";
    String destinationType = "subdistrict";

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'key': 'ef61419fa7acff0b3771ac86a6b6e349', // Ganti dengan API key Anda
    };

    final Map<String, dynamic> requestBody = {
      "origin": origin,
      "originType": originType,
      "destination": idkecamatan,
      "destinationType": destinationType,
      "weight": "1",
      "courier": selectedCourier.value,
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(requestBody));
    var jsonData = json.decode(response.body);
    print(response.body);

    services.value =
        jsonData['rajaongkir']['results'][0]['costs'] as List<dynamic>;

    print(' serviceee ${services.value}');
  }

  Future<AddressSelect> getAddress() async {
    String? token = GetStorage().read('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.addressEndPoints.addressSelect);
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'];

      return AddressSelect.fromJson(data);
    } else {
      throw Exception('Gagal mengambil data alamat');
    }
  }

  Future<void> addToCart(cartItem) async {
    String? token = GetStorage().read('token');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.cartEndPoints.store,
    );

    final body = jsonEncode(cartItem.toJson());

    http.Response response = await http.post(url, body: body, headers: headers);
    print('body $body ||| ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['code'] == 200) {
        print('Item berhasil ditambahkan ke keranjang');
      } else {
        print(
            'Gagal menambahkan item ke keranjang ${response.body} ||| ${jsonResponse['code']} || ${jsonResponse}');
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    fetchServices();

    super.onReady();
  }

  @override
  void onClose() {
    Get.back(result: null);
    super.onClose();
  }
}
