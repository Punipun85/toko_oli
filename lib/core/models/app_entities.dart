class AppProfile {
  const AppProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.accountType,
  });

  final String id;
  final String email;
  final String fullName;
  final String role;
  final String accountType;

  bool get isAdmin => role == 'admin';
  bool get isCourier => role == 'courier';
  bool get isCustomer => role == 'customer';
}

class BrandInfo {
  const BrandInfo({
    required this.id,
    required this.name,
    this.slug = '',
    this.isActive = true,
  });

  final String id;
  final String name;
  final String slug;
  final bool isActive;
}

class CategoryInfo {
  const CategoryInfo({
    required this.id,
    required this.name,
    this.slug = '',
    this.isActive = true,
  });

  final String id;
  final String name;
  final String slug;
  final bool isActive;
}

class ProductVariantInfo {
  const ProductVariantInfo({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    required this.price,
    required this.stockQuantity,
    this.barcode,
    this.minimumStock = 0,
    this.volumeLabel = '',
  });

  final String id;
  final String productId;
  final String name;
  final String sku;
  final double price;
  final int stockQuantity;
  final String? barcode;
  final int minimumStock;
  final String volumeLabel;
}

class AddressInfo {
  const AddressInfo({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.addressLine1,
    required this.city,
    required this.province,
    required this.postalCode,
    this.isDefault = false,
  });

  final String id;
  final String userId;
  final String label;
  final String recipientName;
  final String phone;
  final String addressLine1;
  final String city;
  final String province;
  final String postalCode;
  final bool isDefault;
}

class OrderInfo {
  const OrderInfo({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.orderStatus,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.grandTotal,
    required this.createdAt,
    this.trackingNumber,
  });

  final String id;
  final String userId;
  final String orderNumber;
  final String orderStatus;
  final String paymentStatus;
  final String deliveryStatus;
  final double grandTotal;
  final DateTime createdAt;
  final String? trackingNumber;
}

class ReviewInfo {
  const ReviewInfo({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.body,
    this.adminReply,
    this.isPublished = true,
  });

  final String id;
  final String userId;
  final String productId;
  final int rating;
  final String body;
  final String? adminReply;
  final bool isPublished;
}

class VehicleInfo {
  const VehicleInfo({
    required this.id,
    required this.userId,
    required this.name,
    required this.vehicleType,
    this.brand,
    this.model,
    this.engineType,
  });

  final String id;
  final String userId;
  final String name;
  final String vehicleType;
  final String? brand;
  final String? model;
  final String? engineType;
}

class OilRecommendationInfo {
  const OilRecommendationInfo({
    required this.id,
    required this.vehicleType,
    required this.productId,
    required this.notes,
    this.engineType,
    this.vehicleBrand,
    this.vehicleModel,
  });

  final String id;
  final String vehicleType;
  final String productId;
  final String notes;
  final String? engineType;
  final String? vehicleBrand;
  final String? vehicleModel;
}

class OilChangeReminderInfo {
  const OilChangeReminderInfo({
    required this.id,
    required this.userId,
    required this.vehicleProfileId,
    this.nextChangeDate,
    this.nextChangeOdometerKm,
  });

  final String id;
  final String userId;
  final String vehicleProfileId;
  final DateTime? nextChangeDate;
  final int? nextChangeOdometerKm;
}

class PromoInfo {
  const PromoInfo({
    required this.id,
    required this.code,
    required this.title,
    required this.discountValue,
    this.isActive = true,
  });

  final String id;
  final String code;
  final String title;
  final double discountValue;
  final bool isActive;
}

class StockMovementInfo {
  const StockMovementInfo({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.movementType,
    required this.quantity,
    required this.createdAt,
  });

  final String id;
  final String variantId;
  final String productId;
  final String movementType;
  final int quantity;
  final DateTime createdAt;
}

class ArticleInfo {
  const ArticleInfo({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.status,
  });

  final String id;
  final String title;
  final String slug;
  final String content;
  final String status;
}

class DashboardSummaryInfo {
  const DashboardSummaryInfo({
    required this.todaySales,
    required this.newOrders,
    required this.ordersToProcess,
    required this.shippedOrders,
    required this.lowStockProducts,
    required this.outOfStockProducts,
    required this.monthlyRevenue,
    required this.newCustomers,
  });

  final double todaySales;
  final int newOrders;
  final int ordersToProcess;
  final int shippedOrders;
  final int lowStockProducts;
  final int outOfStockProducts;
  final double monthlyRevenue;
  final int newCustomers;
}

class DeliveryInfo {
  const DeliveryInfo({
    required this.id,
    required this.orderId,
    required this.courierId,
    required this.status,
    this.orderNumber,
  });

  final String id;
  final String orderId;
  final String courierId;
  final String status;
  final String? orderNumber;
}
