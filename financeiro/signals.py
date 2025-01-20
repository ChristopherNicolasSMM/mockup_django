from django.db.models.signals import pre_save, post_save
from django.dispatch import receiver
from django.utils.timezone import now
from models import origem_categoria


@receiver(pre_save, sender=origem_categoria.Origem)
@receiver(pre_save, sender=origem_categoria.Categoria)
def set_audit_fields(sender, instance, **kwargs):
    if not instance.pk:  # Novo registro
        instance.criado_em = now()
    instance.ultimo_ajuste_em = now()
