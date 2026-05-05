import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/providers/app_providers.dart';
import 'package:toko_oli/features/product/domain/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(activeProductsProvider.future);
});
