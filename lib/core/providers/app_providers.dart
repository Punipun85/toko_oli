import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_oli/core/data/storage_repository.dart';
import 'package:toko_oli/core/data/supabase_support.dart';
import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/features/address/data/address_repository.dart';
import 'package:toko_oli/features/admin/data/admin_dashboard_repository.dart';
import 'package:toko_oli/features/article/data/article_repository.dart';
import 'package:toko_oli/features/auth/data/auth_repository.dart';
import 'package:toko_oli/features/cart/data/cart_repository.dart';
import 'package:toko_oli/features/courier/data/courier_repository.dart';
import 'package:toko_oli/features/order/data/order_repository.dart';
import 'package:toko_oli/features/product/domain/product.dart';
import 'package:toko_oli/features/product/presentation/data/product_repository.dart';
import 'package:toko_oli/features/promo/data/promo_repository.dart';
import 'package:toko_oli/features/recommendation/data/oil_recommendation_repository.dart';
import 'package:toko_oli/features/reminder/data/oil_change_reminder_repository.dart';
import 'package:toko_oli/features/review/data/review_repository.dart';
import 'package:toko_oli/features/stock/data/stock_repository.dart';
import 'package:toko_oli/features/vehicle/data/vehicle_repository.dart';
import 'package:toko_oli/features/wishlist/data/wishlist_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(client: ref.watch(supabaseClientProvider));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(
    ref.watch(productRepositoryProvider),
    client: ref.watch(supabaseClientProvider),
  );
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(
    productRepository: ref.watch(productRepositoryProvider),
    client: ref.watch(supabaseClientProvider),
  );
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(client: ref.watch(supabaseClientProvider));
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(
    ref.watch(productRepositoryProvider),
    client: ref.watch(supabaseClientProvider),
  );
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(client: ref.watch(supabaseClientProvider));
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(client: ref.watch(supabaseClientProvider));
});

final oilRecommendationRepositoryProvider =
    Provider<OilRecommendationRepository>((ref) {
  return OilRecommendationRepository(client: ref.watch(supabaseClientProvider));
});

final oilChangeReminderRepositoryProvider =
    Provider<OilChangeReminderRepository>((ref) {
  return OilChangeReminderRepository(client: ref.watch(supabaseClientProvider));
});

final promoRepositoryProvider = Provider<PromoRepository>((ref) {
  return PromoRepository(client: ref.watch(supabaseClientProvider));
});

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository(
    ref.watch(productRepositoryProvider),
    client: ref.watch(supabaseClientProvider),
  );
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepository(client: ref.watch(supabaseClientProvider));
});

final adminDashboardRepositoryProvider = Provider<AdminDashboardRepository>((ref) {
  return AdminDashboardRepository(
    ref.watch(orderRepositoryProvider),
    ref.watch(productRepositoryProvider),
    client: ref.watch(supabaseClientProvider),
  );
});

final courierRepositoryProvider = Provider<CourierRepository>((ref) {
  return CourierRepository(client: ref.watch(supabaseClientProvider));
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(ref.watch(supabaseClientProvider));
});

final activeProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getActiveProducts();
});

final brandsProvider = FutureProvider<List<BrandInfo>>((ref) {
  return ref.watch(productRepositoryProvider).getBrands();
});

final categoriesProvider = FutureProvider<List<CategoryInfo>>((ref) {
  return ref.watch(productRepositoryProvider).getCategories();
});

final myOrdersProvider = FutureProvider<List<OrderInfo>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return const <OrderInfo>[];
  }
  return ref.watch(orderRepositoryProvider).getMyOrders(user.id);
});

final myAddressesProvider = FutureProvider<List<AddressInfo>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return const <AddressInfo>[];
  }
  return ref.watch(addressRepositoryProvider).getMyAddresses(user.id);
});

final myWishlistProvider = FutureProvider<List<Product>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return const <Product>[];
  }
  return ref.watch(wishlistRepositoryProvider).getWishlist(user.id);
});

final myVehiclesProvider = FutureProvider<List<VehicleInfo>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return const <VehicleInfo>[];
  }
  return ref.watch(vehicleRepositoryProvider).getMyVehicles(user.id);
});

final myRemindersProvider = FutureProvider<List<OilChangeReminderInfo>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return const <OilChangeReminderInfo>[];
  }
  return ref.watch(oilChangeReminderRepositoryProvider).getMyReminders(user.id);
});

final publishedArticlesProvider = FutureProvider<List<ArticleInfo>>((ref) {
  return ref.watch(articleRepositoryProvider).getPublishedArticles();
});

final activePromosProvider = FutureProvider<List<PromoInfo>>((ref) {
  return ref.watch(promoRepositoryProvider).getActivePromos();
});

final adminSummaryProvider = FutureProvider<DashboardSummaryInfo>((ref) {
  return ref.watch(adminDashboardRepositoryProvider).getDashboardSummary();
});

final adminRecentOrdersProvider = FutureProvider<List<OrderInfo>>((ref) {
  return ref.watch(adminDashboardRepositoryProvider).getRecentOrders();
});

final adminLowStockProvider = FutureProvider<List<ProductVariantInfo>>((ref) {
  return ref.watch(adminDashboardRepositoryProvider).getLowStockAlerts();
});

final adminBestSellingProvider =
    FutureProvider<List<Map<String, Object>>>((ref) {
  return ref.watch(adminDashboardRepositoryProvider).getBestSellingProducts();
});

final adminRevenueChartProvider = FutureProvider<List<Map<String, Object>>>((ref) {
  return ref.watch(adminDashboardRepositoryProvider).getRevenueChart();
});

final adminOrderStatusOverviewProvider =
    FutureProvider<List<Map<String, Object>>>((ref) {
  return ref.watch(adminDashboardRepositoryProvider).getOrderStatusOverview();
});

final assignedDeliveriesProvider = FutureProvider<List<DeliveryInfo>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) {
    return const <DeliveryInfo>[];
  }
  return ref.watch(courierRepositoryProvider).getAssignedDeliveries(user.id);
});

final homeRecommendationsProvider = FutureProvider<List<Product>>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  final recommendationRepository = ref.watch(oilRecommendationRepositoryProvider);
  final vehicles = await ref.watch(myVehiclesProvider.future);
  final referenceVehicleType =
      vehicles.isNotEmpty ? vehicles.first.vehicleType : 'motor';
  final recommendations = await recommendationRepository.getRecommendationByVehicle(
    referenceVehicleType,
    brand: vehicles.isNotEmpty ? vehicles.first.brand : null,
    model: vehicles.isNotEmpty ? vehicles.first.model : null,
  );
  if (recommendations.isEmpty) {
    final fallbackProducts = await productRepository.getActiveProducts();
    return fallbackProducts.take(3).toList();
  }

  final products = <Product>[];
  for (final item in recommendations) {
    final product = await productRepository.getProductById(item.productId);
    if (product != null) {
      products.add(product);
    }
  }
  if (products.isEmpty) {
    final fallbackProducts = await productRepository.getActiveProducts();
    return fallbackProducts.take(3).toList();
  }
  return products;
});
