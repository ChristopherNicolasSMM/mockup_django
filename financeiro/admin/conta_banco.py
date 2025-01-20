from django.contrib import admin
from ..models.conta_banco import ContaBanco

@admin.register(ContaBanco)
class ContaBancoAdmin(admin.ModelAdmin):
    list_display = (
        "id", 
        "banco", 
        "descricao", 
        "conta", 
        "digito", 
        "agencia", 
        "documento", 
        "criado_por", 
        "criado_em", 
        "ultimo_ajuste_por", 
        "ultimo_ajuste_em",
    )
    list_filter = ("banco", "criado_em", "ultimo_ajuste_em")
    search_fields = ("banco", "descricao", "conta", "documento", "criado_por__username")
    readonly_fields = ("criado_por", "criado_em", "ultimo_ajuste_por", "ultimo_ajuste_em")

    def save_model(self, request, obj, form, change):
        if not obj.pk:  # Novo registro
            obj.criado_por = request.user
        obj.ultimo_ajuste_por = request.user
        super().save_model(request, obj, form, change)
