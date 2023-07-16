import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:mall_ukm/app/model/cart/cartItem_model.dart';
import 'package:mall_ukm/app/model/cart/selectedCart.dart';
import 'package:mall_ukm/app/modules/cart/views/checkbox.dart';
import 'package:mall_ukm/app/style/styles.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    RxDouble tot = 0.0.obs;

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Keranjang',
            style: Styles.headerStyles(weight: FontWeight.w500, size: 16),
          ),
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: kToolbarHeight + 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 7.0, bottom: 10, top: 12),
                      child: Text('Total Harga', style: Styles.bodyStyle()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                      child: Obx(() {
                        return Text(
                          '$tot',
                          style: Styles.bodyStyle(
                            weight: FontWeight.w500,
                            size: 15,
                          ),
                        );
                      }),
                    )
                  ],
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      print(controller.selectedItems);
                      Get.toNamed('/checkout',
                          arguments: [controller.selectedItems,tot]);
                    },
                    child: Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: const Color(0xff034779),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text('Checkout',
                              style: Styles.bodyStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                child: Obx(() {
                  if (controller.carts.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Kamu belum memasukan barang dikeranjang',
                            style: Styles.bodyStyle(),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        itemCount: controller.carts.length,
                        itemBuilder: (context, index) {
                          var carts = controller.carts[index];
                          var counter = carts.qty.obs;
                          var isChecked = controller.isChecked(index).obs;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => CheckboxTile(
                                      value: isChecked.value ?? false,
                                      onChanged: (bool? value) {
                                        isChecked.value = value ?? false;
                                        if (value == true) {
                                          tot.value += carts.price;
                                          controller.selectedItems.add(
                                            SelectedCartItem(
                                                isChecked: true, cart: carts),
                                          );
                                        } else {
                                          tot.value -= carts.price;
                                          controller.selectedItems.removeWhere(
                                              (item) => item.cart == carts);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: [
                                    Image.network(
                                      '${carts.photo}',
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              carts.title,
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.bodyStyle(),
                                            ),
                                            Text(
                                              'Varian : ${carts.unitVariant}',
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.bodyStyle(),
                                            ),
                                            Text(
                                              'Rp${carts.price}',
                                              style: Styles.bodyStyle(),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Obx(() {
                                                    return CartStepperInt(
                                                        value: counter.value,
                                                        size: 22,
                                                        style: CartStepperStyle(
                                                          foregroundColor:
                                                              Colors.black87,
                                                          activeForegroundColor:
                                                              Colors.black87,
                                                          activeBackgroundColor:
                                                              Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          radius: const Radius
                                                              .circular(8),
                                                          elevation: 0,
                                                          buttonAspectRatio:
                                                              1.5,
                                                        ),
                                                        didChangeCount:
                                                            (count) async {
                                                          if (count >
                                                              counter.value) {
                                                            counter.value++;
                                                            tot.value =
                                                                counter.value *
                                                                    carts.price;
                                                            CartItem cartItem =
                                                                CartItem(
                                                              product_id: int
                                                                  .parse(carts
                                                                      .productId),
                                                              qty: 1,
                                                              unit_variant: carts
                                                                  .unitVariant,
                                                            );
                                                            await controller
                                                                .updateCart(
                                                                    carts.id,
                                                                    cartItem);
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  'Berhasil menambahkan kuantitas',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      800],
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 14.0,
                                                            );
                                                          } else if (count <
                                                              counter.value) {
                                                            // Jika tombol "-" ditekan
                                                            if (counter.value <=
                                                                1) {
                                                              // Jika qty sudah 1 atau kurang, hapus item dari keranjang
                                                              await controller
                                                                  .deleteCart(
                                                                      carts.id);
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    'Item dihapus dari keranjang',
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        800],
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14.0,
                                                              );
                                                            } else if (count <
                                                                counter.value) {
                                                              // Jika tombol "-" ditekan, kurangi qty sebanyak 1
                                                              tot.value = tot
                                                                      .value -
                                                                  carts.price;

                                                              counter.value--;
                                                              CartItem
                                                                  cartItem =
                                                                  CartItem(
                                                                product_id: int
                                                                    .parse(carts
                                                                        .productId),
                                                                qty: -1,
                                                                unit_variant: carts
                                                                    .unitVariant,
                                                              );
                                                              await controller
                                                                  .updateCart(
                                                                      carts.id,
                                                                      cartItem);
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg:
                                                                    'Berhasil mengurangi kuantitas',
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        800],
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 14.0,
                                                              );
                                                            }
                                                          }
                                                        });
                                                  }),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Berhasil menghapus barang dari keranjang',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            Colors.grey[800],
                                                        textColor: Colors.white,
                                                        fontSize: 14.0,
                                                      );
                                                      await controller
                                                          .deleteCart(carts.id);
                                                      print(carts.id);
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                })),
          ),
        ));
  }
}
