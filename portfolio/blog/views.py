from django.shortcuts import render, get_object_or_404
from .models import Article

def article_list(request):
    articles = Article.objects.all()
    return render(request, 'blog_display.html', {"articles": articles})

def article_detail(request, article_slug):
    blog = get_object_or_404(Article, slug=article_slug)
    return render(request, 'blog_detail.html', {})