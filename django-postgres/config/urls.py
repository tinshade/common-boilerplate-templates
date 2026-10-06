from django.contrib import admin
from django.db import connection
from django.http import JsonResponse
from django.urls import path


def health(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT 1")
    return JsonResponse({"status": "ok", "database": "connected"})


urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/health", health),
]
