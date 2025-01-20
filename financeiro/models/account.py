from django.db import models

class Account(models.Model):
    """Modelo para gerenciar contas financeiras."""
    name = models.CharField(max_length=50, unique=True, verbose_name="Nome da Conta")
    balance = models.FloatField(default=0.0, verbose_name="Saldo")
    status = models.CharField(
        max_length=10,
        choices=[('Ativo', 'Ativo'), ('Bloqueado', 'Bloqueado')],
        default='Ativo',
        verbose_name="Status"
    )

    def __str__(self):
        return f"{self.name} ({self.status})"
