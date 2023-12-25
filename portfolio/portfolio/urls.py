from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include

from portfolio import views
from blog import views as blog_views

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", views.home, name="home"),
    path("about/", views.about, name="about"),
    path("contact/", views.contact, name="contact"),
    path("contact/success/", views.contact_success, name="success_page"),
    path("cv/", views.cv, name="cv"),
    path("healthcheck/", views.healthcheck),
    path('blog/', include('blog.urls'))
    

]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
