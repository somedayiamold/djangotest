from django.db import models

# Create your models here.

class JobContext(models.Model):
    data = models.BinaryField()

    class Meta:
        verbose_name = 'JobContext'
