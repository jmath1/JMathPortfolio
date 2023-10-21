from django.db import models

# Create your models here.
class Article(models.Model):
    body = models.TextField()
    published = models.BooleanField(default=False)