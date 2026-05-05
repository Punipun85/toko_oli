import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toko_oli/core/data/app_fallback_store.dart';
import 'package:toko_oli/core/models/app_entities.dart';

class ArticleRepository {
  ArticleRepository({SupabaseClient? client})
      : _client = client,
        _fallback = AppFallbackStore.instance;

  final SupabaseClient? _client;
  final AppFallbackStore _fallback;

  Future<List<ArticleInfo>> getPublishedArticles() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('articles')
            .select()
            .eq('status', 'published')
            .order('published_at', ascending: false);
        return (response as List<dynamic>).map(_mapArticle).toList();
      } catch (_) {}
    }
    return _fallback.articles.where((item) => item.status == 'published').toList();
  }

  Future<ArticleInfo?> getArticleDetail(String slug) async {
    final items = await adminGetArticles();
    for (final article in items) {
      if (article.slug == slug || article.id == slug) {
        return article;
      }
    }
    return null;
  }

  Future<List<ArticleInfo>> adminGetArticles() async {
    final client = _client;
    if (client != null) {
      try {
        final response = await client
            .from('articles')
            .select()
            .order('created_at', ascending: false);
        return (response as List<dynamic>).map(_mapArticle).toList();
      } catch (_) {}
    }
    return List<ArticleInfo>.from(_fallback.articles);
  }

  Future<void> adminCreateArticle(ArticleInfo article) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('articles').insert({
          'title': article.title,
          'slug': article.slug,
          'content': article.content,
          'status': article.status,
        });
        return;
      } catch (_) {}
    }
  }

  Future<void> adminUpdateArticle(ArticleInfo article) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('articles').update({
          'title': article.title,
          'slug': article.slug,
          'content': article.content,
          'status': article.status,
        }).eq('id', article.id);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminPublishArticle(String articleId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('articles').update({
          'status': 'published',
          'published_at': DateTime.now().toIso8601String(),
        }).eq('id', articleId);
        return;
      } catch (_) {}
    }
  }

  Future<void> adminDeleteArticle(String articleId) async {
    final client = _client;
    if (client != null) {
      try {
        await client.from('articles').delete().eq('id', articleId);
        return;
      } catch (_) {}
    }
  }

  ArticleInfo _mapArticle(dynamic raw) {
    final item = raw as Map<String, dynamic>;
    return ArticleInfo(
      id: item['id'].toString(),
      title: (item['title'] ?? '').toString(),
      slug: (item['slug'] ?? '').toString(),
      content: (item['content'] ?? '').toString(),
      status: (item['status'] ?? '').toString(),
    );
  }
}
