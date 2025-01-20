from django.db import models
from django.contrib.auth.models import User
from django.utils.timezone import now
from django.core.exceptions import ValidationError
import re

def validar_documento(value):
    if not re.match(r"^\d{11}$|^\d{14}$", value):
        print("Documento deve ser um CPF (11 dígitos) ou CNPJ (14 dígitos).")
        raise ValidationError("Documento deve ser um CPF (11 dígitos) ou CNPJ (14 dígitos).")


class ContaBanco(models.Model):

    id = models.AutoField(primary_key=True)
    banco = models.CharField(max_length=100, verbose_name="Banco")
    descricao = models.CharField(max_length=100, verbose_name="Descrição")
    conta = models.CharField(max_length=10, verbose_name="Conta", )
    digito = models.CharField(max_length=2, verbose_name="Dígito")
    agencia = models.CharField(max_length=4, verbose_name="Agência")
    pix = models.CharField(max_length=500, verbose_name="PIX", blank=True, null=True)

    documento = models.CharField(
            max_length=14,
            validators=[validar_documento],
            verbose_name="Documento (CPF ou CNPJ)",
            help_text="Digite um CPF ou CNPJ",
        )

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
        related_name="contabanco_criado_por",
        verbose_name="Criado por",
    )
    criado_em = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    ultimo_ajuste_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="contabanco_ultimo_ajuste_por",
        verbose_name="Último Ajuste por",
    )
    ultimo_ajuste_em = models.DateTimeField(auto_now=True, verbose_name="Último Ajuste em")

    class Meta:
        verbose_name = "Conta Banco"
        verbose_name_plural = "Contas Bancárias"
        ordering = ["-criado_em"]

    def __str__(self):
        return f"{self.banco} - {self.descricao}"
    

