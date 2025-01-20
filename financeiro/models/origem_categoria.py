from django.db import models
from django.contrib.auth.models import User
from django.utils.timezone import now

class BaseModel(models.Model):
    id = models.AutoField(primary_key=True)  # Campo id explícito
    nome = models.CharField(max_length=255, verbose_name="Nome")
    status = models.BooleanField(
        default=True,
        verbose_name="Status",
        choices=[
            (True, "Ativo"),
            (False, "Inativo"),
        ]
    )
    criado_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="%(class)s_criado_por",
        verbose_name="Criado por"
    )
    criado_em = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    ultimo_ajuste_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="%(class)s_ultimo_ajuste_por",
        verbose_name="Último Ajuste por"
    )
    ultimo_ajuste_em = models.DateTimeField(auto_now=True, verbose_name="Último Ajuste em")

    class Meta:
        abstract = True
        ordering = ["-criado_em"]

class Origem(BaseModel):
    class Meta:
        verbose_name = "Origem"
        verbose_name_plural = "Origens"

    def __str__(self):
        return self.nome

class Categoria(BaseModel):
    class Meta:
        verbose_name = "Categoria"
        verbose_name_plural = "Categorias"

    def __str__(self):
        return self.nome
