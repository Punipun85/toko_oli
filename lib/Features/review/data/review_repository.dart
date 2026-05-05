import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class ReviewRepository {
  ReviewRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<ReviewInfo>> getProductReviews(String productId) async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('reviews')
            .select('id,user_id,product_id,rating,body,is_published,admin_reply')
            .eq('product_id', productId)
            .eq('is_published', true)
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapReview).toList();
      } catch (_) {}
    }
    return _fallback.reviews.where((item) => item.productId == productId).toList();
  }

  Future<void> createReview({
    required String userId,
    required String productId,
    required int rating,
    required String body,
    String? orderId,
  }) async {
    final client = _client;
    if (client != null && orderId != null) {
      try {
        await client.from('reviews').insert({
          'user_id': userId,
          'product_id': productId,
          'order_id': orderId,
          'rating': rating,
          'body': body,
        });
        return;
      } catch (_) {}
    }
    _fallback.reviews.add(
      ReviewInfo(
        id: 'review-${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        productId: productId,
        rating: rating,
        body: body,
      ),
    );
  }

  Future<List<ReviewInfo>> adminGetReviews() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('reviews')
            .select('id,user_id,product_id,rating,body,is_published,admin_reply')
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapReview).toList();
      } catch (_) {}
    }
    return List<ReviewInfo>.from(_fallback.reviews);
  }

  Future<void> adminReplyReview(String reviewId, String reply) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('reviews').update({'admin_reply': reply}).eq('id', reviewId);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminHideReview(String reviewId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('reviews').update({'is_published': false}).eq('id', reviewId);
        return;
      } catch (_) {}
    }
  }

  ReviewInfo _mapReview(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return ReviewInfo(
      id: item['id'].toString(),
      userId: item['user_id'].toString(),
      productId: item['product_id'].toString(),
      rating: (item['rating'] as num?)?.toInt() ?? 0,
      body: (item['body'] ?? '').toString(),
      adminReply: item['admin_reply']?.toString(),
      isPublished: item['is_published'] == true,
    );
  }
}
