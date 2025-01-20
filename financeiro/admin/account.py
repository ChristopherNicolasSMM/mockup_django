from django.contrib import admin
from ..models.account import Account

@admin.register(Account)
class AccountAdmin(admin.ModelAdmin):
    list_display = ('name', 'balance', 'status')
    search_fields = ('name',)
    list_filter = ('status',)
