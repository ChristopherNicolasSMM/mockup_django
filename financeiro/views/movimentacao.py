from django.shortcuts import render
from django.contrib.auth.decorators import login_required

@login_required
def MovimentacaoPageView(request):
    return render(request, 'lancamento/lancamento.html', {'title': 'Movimentações'})
