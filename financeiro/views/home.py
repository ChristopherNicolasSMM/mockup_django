from django.shortcuts import render
from django.contrib.auth.decorators import login_required

@login_required
def HomePageView(request):
    """Renderiza a página inicial."""
    return render(request, 'home/home.html', {'title': 'Dashboard'})
