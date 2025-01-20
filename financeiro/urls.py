from django.urls import path
from .views import account, home, login, movimentacao, origem_categoria, conta_banco

urlpatterns = [
    path('', home.HomePageView, name='home'),  # Página inicial


    path('accounts/login/', login.LoginView.as_view(), name='login'),
    path('login/', login.LoginView.as_view(), name='login'),
    path('logout/', login.logout_view, name='logout'),
    
    path('origem_categoria/', origem_categoria.OrigemCategoriaPageView, name='origem_categoria'),
    path('salvar_origem/', origem_categoria.salvar_origem, name='salvar_origem'),
    path('salvar_categoria/', origem_categoria.salvar_categoria, name='salvar_categoria'),
    path('consultar-origens/', origem_categoria.consultar_origens, name='consultar_origens'),
    path('consultar-categorias/', origem_categoria.consultar_categorias, name='consultar_categorias'),


    path('/account_list', account.AccountListView, name='account_list'),
    path('<int:account_id>/', account.AccountDetailView, name='account_detail'),
    
    path('lancamento/', movimentacao.MovimentacaoPageView, name='lancamento'),



    path("conta-banco/", conta_banco.ContaBancoPageView, name="conta_banco"),
    path("consultar-contas-banco/", conta_banco.consultar_contas_banco, name="consultar_contas_banco"),
    path("salvar-conta-banco/", conta_banco.salvar_conta_banco, name="salvar_conta_banco"),
    path('consultar-conta-banco/<int:id>/', conta_banco.consultar_conta_banco, name='consultar_conta_banco'),

]

