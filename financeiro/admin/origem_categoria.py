from django.contrib import admin
from ..models import Origem, Categoria

@admin.register(Origem)
class OrigemAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'status', 'criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')
    list_filter = ('status', 'criado_em', 'ultimo_ajuste_em')
    search_fields = ('nome', 'criado_por__username', 'ultimo_ajuste_por__username')
    readonly_fields = ('criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')

    def save_model(self, request, obj, form, change):
        """
        Sobrescreve o comportamento padrão para preencher os campos de auditoria.
        """
        if not obj.pk:  # Novo registro
            obj.criado_por = request.user
        obj.ultimo_ajuste_por = request.user
        super().save_model(request, obj, form, change)


@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'status', 'criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')
    list_filter = ('status', 'criado_em', 'ultimo_ajuste_em')
    search_fields = ('nome', 'criado_por__username', 'ultimo_ajuste_por__username')
    readonly_fields = ('criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')

    def save_model(self, request, obj, form, change):
        """
        Sobrescreve o comportamento padrão para preencher os campos de auditoria.
        """
        if not obj.pk:  # Novo registro
            obj.criado_por = request.user
        obj.ultimo_ajuste_por = request.user
        super().save_model(request, obj, form, change)
