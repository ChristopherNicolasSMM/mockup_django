from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.views import View
from django.contrib import messages

class LoginView(View):
    def get(self, request):
        if request.user.is_authenticated:
            return redirect('home')  # Redirecionar para a página inicial após o login
        return render(request, 'login\login.html')

    def post(self, request):
        username = request.POST.get('username')
        password = request.POST.get('password')

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')  # Altere 'home' para a URL desejada
        else:
            messages.error(request, 'Usuário ou senha inválidos.')
            return render(request, 'login\login.html')

def logout_view(request):
    logout(request)
    return redirect('login')  # Redirecionar para a página de login após o logout
