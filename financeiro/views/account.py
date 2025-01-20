from django.shortcuts import render, get_object_or_404
from ..models.account import Account

def AccountListView(request):
    """Lista todas as contas."""
    accounts = Account.objects.all()
    return render(request, 'accounts/account_list.html', {'accounts': accounts})

def AccountDetailView(request, account_id):
    """Detalha uma conta específica."""
    account = get_object_or_404(Account, id=account_id)
    return render(request, 'accounts/account_detail.html', {'account': account})
