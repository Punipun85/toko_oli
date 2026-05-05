import 'package:toko_oli/core/models/app_entities.dart';
import 'package:toko_oli/features/cart/domain/cart_item.dart';
import 'package:toko_oli/features/product/domain/product.dart';

class AppFallbackStore {
  AppFallbackStore._();

  static final AppFallbackStore instance = AppFallbackStore._();

  final List<Product> products = [
    Product(
      id: 'demo-1',
      name: 'Pertamina Enduro Matic-V 10W-40',
      priceValue: 68000,
      sae: '10W-40',
      volume: '1 L',
      type: 'Synthetic',
      series: 'Enduro',
      description: 'Fallback demo product for offline mode.',
      imageUrl: null,
      brand: 'Pertamina',
      category: 'Oli Motor',
    ),
    Product(
      id: 'demo-2',
      name: 'Fastron Gold 5W-30',
      priceValue: 145000,
      sae: '5W-30',
      volume: '1 L',
      type: 'Full Synthetic',
      series: 'Fastron Gold',
      description: 'Fallback demo product for offline mode.',
      imageUrl: null,
      brand: 'Pertamina',
      category: 'Oli Mobil',
    ),
    Product(
      id: 'demo-3',
      name: 'Meditran SX Bio 15W-40',
      priceValue: 556000,
      sae: '15W-40',
      volume: '20 L',
      type: 'Heavy Duty',
      series: 'Meditran',
      description: 'Fallback demo product for offline mode.',
      imageUrl: null,
      brand: 'Pertamina',
      category: 'Oli Diesel',
    ),
  ];

  final List<BrandInfo> brands = const [
    BrandInfo(id: 'brand-1', name: 'Pertamina', slug: 'pertamina'),
    BrandInfo(id: 'brand-2', name: 'Shell', slug: 'shell'),
    BrandInfo(id: 'brand-3', name: 'Castrol', slug: 'castrol'),
  ];

  final List<CategoryInfo> categories = const [
    CategoryInfo(id: 'cat-1', name: 'Oli Motor', slug: 'oli-motor'),
    CategoryInfo(id: 'cat-2', name: 'Oli Mobil', slug: 'oli-mobil'),
    CategoryInfo(id: 'cat-3', name: 'Oli Diesel', slug: 'oli-diesel'),
  ];

  final List<ProductVariantInfo> variants = const [
    ProductVariantInfo(
      id: 'var-1',
      productId: 'demo-1',
      name: '1L',
      sku: 'DEMO-ENDURO-1L',
      price: 68000,
      stockQuantity: 12,
      minimumStock: 4,
      volumeLabel: '1L',
    ),
    ProductVariantInfo(
      id: 'var-2',
      productId: 'demo-2',
      name: '1L',
      sku: 'DEMO-FASTRON-1L',
      price: 145000,
      stockQuantity: 9,
      minimumStock: 3,
      volumeLabel: '1L',
    ),
    ProductVariantInfo(
      id: 'var-3',
      productId: 'demo-3',
      name: '20L',
      sku: 'DEMO-MEDITRAN-20L',
      price: 556000,
      stockQuantity: 2,
      minimumStock: 2,
      volumeLabel: '20L',
    ),
  ];

  final List<CartItem> cartItems = [];
  final List<AddressInfo> addresses = [];
  final List<String> wishlistProductIds = [];
  final List<OrderInfo> orders = [];
  final List<ReviewInfo> reviews = [];
  final List<VehicleInfo> vehicles = [];
  final List<OilRecommendationInfo> recommendations = const [
    OilRecommendationInfo(
      id: 'rec-1',
      vehicleType: 'motor',
      productId: 'demo-1',
      notes: 'Recommended for daily scooters.',
      vehicleBrand: 'Honda',
      vehicleModel: 'Vario 150',
    ),
    OilRecommendationInfo(
      id: 'rec-2',
      vehicleType: 'mobil',
      productId: 'demo-2',
      notes: 'Recommended for modern gasoline engines.',
      vehicleBrand: 'Toyota',
      vehicleModel: 'Avanza',
    ),
  ];
  final List<OilChangeReminderInfo> reminders = [];
  final List<PromoInfo> promos = const [
    PromoInfo(
      id: 'promo-1',
      code: 'OLIMART10',
      title: 'Diskon 10%',
      discountValue: 10,
    ),
  ];
  final List<StockMovementInfo> stockMovements = [];
  final List<ArticleInfo> articles = const [
    ArticleInfo(
      id: 'article-1',
      title: 'Cara Memilih Oli yang Tepat',
      slug: 'cara-memilih-oli-yang-tepat',
      content: 'Panduan singkat memilih oli berdasarkan kendaraan.',
      status: 'published',
    ),
  ];
  final List<DeliveryInfo> deliveries = const [
    DeliveryInfo(
      id: 'delivery-1',
      orderId: 'order-demo-1',
      courierId: 'demo-courier',
      status: 'assigned',
      orderNumber: 'ORD-DEMO-001',
    ),
  ];

  DashboardSummaryInfo get dashboardSummary => const DashboardSummaryInfo(
        todaySales: 1245000,
        newOrders: 3,
        ordersToProcess: 2,
        shippedOrders: 1,
        lowStockProducts: 1,
        outOfStockProducts: 0,
        monthlyRevenue: 12500000,
        newCustomers: 4,
      );
}
