from django.urls import path
from blog import views

urlpatterns = [
    path('', views.article_list, name='article-list'),
    path('article/<slug:article_slug>/', views.article_detail, name='article-detail'),
]
