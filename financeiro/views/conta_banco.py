from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.core.paginator import Paginator
from django.http import JsonResponse, HttpResponseBadRequest
#from django.contrib import messages
from django.db import IntegrityError, DatabaseError
from ..models.conta_banco import ContaBanco

@login_required
def ContaBancoPageView(request):
    return render(request, "conta_banco/conta_banco.html", {"title": "Manutenção de Contas Bancárias"})

#Conta unica
def consultar_conta_banco(request, id):
    try:
        conta_banco = ContaBanco.objects.get(id=id)
        data = {
            "id": conta_banco.id,
            "banco": conta_banco.banco,
            "descricao": conta_banco.descricao,
            "conta": conta_banco.conta,
            "digito": conta_banco.digito,
            "agencia": conta_banco.agencia,
            "pix": conta_banco.pix,
            "documento": conta_banco.documento,
            "status": conta_banco.status,
        }
        return JsonResponse(data)
    except ContaBanco.DoesNotExist:
        return JsonResponse({"error": "Conta Banco não encontrada."}, status=404)


#Todas as contas
'''
#Todas as contas
def consultar_contas_banco(request):
    contas = ContaBanco.objects.all()
    data = []
    for conta in contas:
        data.append({
        '''
def consultar_contas_banco(request):
    contas = ContaBanco.objects.all()
    paginator = Paginator(contas, 10)  # 10 contas por página
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    data = [
        {
            "id": conta.id,
            "banco": conta.banco,
            "descricao": conta.descricao,
            "conta": conta.conta,
            "digito": conta.digito,
            "agencia": conta.agencia,
            "pix": conta.pix,
            "documento": conta.documento,
            "criado_por": conta.criado_por.username if conta.criado_por else "N/A",
            "criado_em": conta.criado_em.strftime("%d/%m/%Y"),
            "ultimo_ajuste_por": conta.ultimo_ajuste_por.username if conta.ultimo_ajuste_por else "N/A",
            "ultimo_ajuste_em": conta.ultimo_ajuste_em.strftime("%d/%m/%Y"),
            "status": "Ativo" if conta.status else "Inativo",
            }
        for conta in page_obj
    ]
    #return JsonResponse({"contas": data})
    return JsonResponse({"contas": data, "num_pages": paginator.num_pages})

def salvar_conta_banco(request):
    print('Passou por aqui 1')
    
    if request.method == "POST":
        conta_id = request.POST.get("id")
        banco = request.POST.get("banco")
        descricao = request.POST.get("descricao")
        conta = request.POST.get("conta")
        digito = request.POST.get("digito")
        agencia = request.POST.get("agencia")
        pix = request.POST.get("pix")
        documento = request.POST.get("documento")
        status = request.POST.get("status") == "True"

        if conta_id:
            try:
                conta_id = int(conta_id)
                conta_banco = get_object_or_404(ContaBanco, id=conta_id)
            except (ValueError, TypeError):
                return HttpResponseBadRequest("ID inválido.")
        else:
            conta_banco = ContaBanco(criado_por=request.user)

        conta_banco.banco = banco
        conta_banco.descricao = descricao
        conta_banco.conta = conta
        conta_banco.digito = digito
        conta_banco.agencia = agencia
        conta_banco.pix = pix
        conta_banco.documento = documento
        conta_banco.ultimo_ajuste_por = request.user
        conta_banco.status = status

        try:

            # Tentar salvar no banco de dados
            conta_banco.save()
            print("Conta salva com sucesso!")  # Log de sucesso
            print(JsonResponse({"message": "Conta salva com sucesso!"}, status=200))
            return redirect("conta_banco")

        except IntegrityError as e:
            print("Erro de integridade:", e)  # Log do erro
            print(JsonResponse({"error": "Erro de integridade ao salvar a conta."}, status=400))
            return redirect("conta_banco")

        except DatabaseError as e:
            print("Erro no banco de dados:", e)  # Log do erro
            print(JsonResponse({"error": "Erro no banco de dados."}, status=500))
            return redirect("conta_banco")

        except Exception as e:
            print("Erro desconhecido:", e)  # Log do erro
            print(JsonResponse({"error": "Erro desconhecido ao salvar a conta."}, status=500))
            return redirect("conta_banco")
