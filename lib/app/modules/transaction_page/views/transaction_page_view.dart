import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mall_ukm/app/modules/transaction_page/views/transaction.unpaid_view.dart';
import 'package:mall_ukm/app/modules/transaction_page/views/transaction.paid_view.dart';
import 'package:mall_ukm/app/modules/transaction_page/views/transaction.selesai_view%20.dart';
import 'package:mall_ukm/app/modules/transaction_page/views/transaction.semua_view.dart';
import 'package:mall_ukm/app/style/styles.dart';

import '../controllers/transaction_page_controller.dart';

class TransactionPageView extends GetView<TransactionPageController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorPadding: EdgeInsets.zero,
            tabs: [
              Tab(
                child: Text(
                  'Semua ',
                  style: Styles.bodyStyle(size: 14, weight: FontWeight.w400),
                ),
              ),
              Tab(
                child: Text(
                  'Sudah bayar',
                  style: Styles.bodyStyle(size: 12, weight: FontWeight.w400),
                ),
              ),
              Tab(
                child: Text(
                  'Belum Bayar',
                  style: Styles.bodyStyle(size: 11, weight: FontWeight.w400),
                ),
              ),
              Tab(
                child: Text(
                  'Selesai',
                  style: Styles.bodyStyle(size: 14, weight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GetBuilder<TransactionPageController>(
              init: TransactionPageController(),
              builder: (controller) => TransactionSemuaView(),
            ),
            GetBuilder<TransactionPageController>(
              init: TransactionPageController(),
              builder: (controller) => TransactionPaidView(),
            ),
            GetBuilder<TransactionPageController>(
              init: TransactionPageController(),
              builder: (controller) => TransactionUnpaidView(),
            ),
            GetBuilder<TransactionPageController>(
              init: TransactionPageController(),
              builder: (controller) => TransactionSelesaiView(),
            ),
          ],
        ),
      ),
    );
  }
}
