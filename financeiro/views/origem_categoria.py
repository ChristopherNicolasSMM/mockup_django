from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect, get_object_or_404
from ..models import Origem, Categoria
from django.http import JsonResponse
from django.http import HttpResponseBadRequest

@login_required
def OrigemCategoriaPageView(request):
    return render(request, 'origem_categoria/origem_categoria.html', {'title': 'Manutenção de Origem & Categoria'})

def consultar_origens(request):
    origens = Origem.objects.all()
    data = []
    for origem in origens:
        data.append({
            "id": origem.id,
            "nome": origem.nome,
            "status": "Ativo" if origem.status else "Inativo",
            "criado_por": origem.criado_por.username,
            "criado_em": origem.criado_em.strftime("%d/%m/%Y"),
            "ultimo_ajuste_por": origem.ultimo_ajuste_por.username,
            "ultimo_ajuste_em": origem.ultimo_ajuste_em.strftime("%d/%m/%Y")
        })
    return JsonResponse({"origens": data})

def consultar_categorias(request):
    categorias = Categoria.objects.all()
    data = []
    for categoria in categorias:
        data.append({
            "id": categoria.id,
            "nome": categoria.nome,
            "status": "Ativo" if categoria.status else "Inativo",
            "criado_por": categoria.criado_por.username,
            "criado_em": categoria.criado_em.strftime("%d/%m/%Y"),
            "ultimo_ajuste_por": categoria.ultimo_ajuste_por.username,
            "ultimo_ajuste_em": categoria.ultimo_ajuste_em.strftime("%d/%m/%Y")
        })
    return JsonResponse({"categorias": data})

def salvar_origem(request):
    if request.method == "POST":
        origem_id = request.POST.get("id")
        nome = request.POST.get("nome")
        status = request.POST.get("status") == "True"

        if origem_id:
            try:
                origem_id = int(origem_id)
                origem = get_object_or_404(Origem, id=origem_id)
            except (ValueError, TypeError):
                return HttpResponseBadRequest("ID inválido.")  # Retorna erro se o ID não for numérico
        else:
            origem = Origem(criado_por=request.user)

        origem.nome = nome
        origem.status = status
        origem.ultimo_ajuste_por = request.user
        origem.save()
        return redirect("origem_categoria")


def salvar_categoria(request):
    if request.method == "POST":
        categoria_id = request.POST.get("id")
        nome = request.POST.get("nome")
        status = request.POST.get("status") == "True"

        if categoria_id:  # Editando
            categoria = get_object_or_404(Categoria, id=categoria_id)
        else:  # Criando novo
            categoria = Categoria(criado_por=request.user)
        categoria.nome = nome
        categoria.status = status
        categoria.ultimo_ajuste_por = request.user
        categoria.save()
        return redirect("OrigemCategoriaPageView")  # Substitua pela sua view
