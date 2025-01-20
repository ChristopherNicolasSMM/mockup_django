---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################

--- Aqui contém 2 mensagens ao GPT deve ser adaptada a 2 mensagem para ajudar na geração de CRUDs...

---##########################################################################################################################

Vou informar agora como esta os seguintes arquivos, todos estão corretos e quero que os guarde para usar como base.
Lembrando que estou lidando com comelo similar ao MVC onde tenho view, model, template, admin, como pastas e não arquivos.

Pasta: View, Arquivo origem_categoria.py

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


Pasta: Model, Arquivo origem_categoria.py

from django.db import models
from django.contrib.auth.models import User
from django.utils.timezone import now

class BaseModel(models.Model):
    id = models.AutoField(primary_key=True)  # Campo id explícito
    nome = models.CharField(max_length=255, verbose_name="Nome")
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
        related_name="%(class)s_criado_por",
        verbose_name="Criado por"
    )
    criado_em = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    ultimo_ajuste_por = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="%(class)s_ultimo_ajuste_por",
        verbose_name="Último Ajuste por"
    )
    ultimo_ajuste_em = models.DateTimeField(auto_now=True, verbose_name="Último Ajuste em")

    class Meta:
        abstract = True
        ordering = ["-criado_em"]

class Origem(BaseModel):
    class Meta:
        verbose_name = "Origem"
        verbose_name_plural = "Origens"

    def __str__(self):
        return self.nome

class Categoria(BaseModel):
    class Meta:
        verbose_name = "Categoria"
        verbose_name_plural = "Categorias"

    def __str__(self):
        return self.nome


Pasta: Admin, Arquivo origem_categoria.py

from django.contrib import admin
from ..models import Origem, Categoria

@admin.register(Origem)
class OrigemAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'status', 'criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')
    list_filter = ('status', 'criado_em', 'ultimo_ajuste_em')
    search_fields = ('nome', 'criado_por__username', 'ultimo_ajuste_por__username')
    readonly_fields = ('criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')

    def save_model(self, request, obj, form, change):
        """
        Sobrescreve o comportamento padrão para preencher os campos de auditoria.
        """
        if not obj.pk:  # Novo registro
            obj.criado_por = request.user
        obj.ultimo_ajuste_por = request.user
        super().save_model(request, obj, form, change)


@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'status', 'criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')
    list_filter = ('status', 'criado_em', 'ultimo_ajuste_em')
    search_fields = ('nome', 'criado_por__username', 'ultimo_ajuste_por__username')
    readonly_fields = ('criado_por', 'criado_em', 'ultimo_ajuste_por', 'ultimo_ajuste_em')

    def save_model(self, request, obj, form, change):
        """
        Sobrescreve o comportamento padrão para preencher os campos de auditoria.
        """
        if not obj.pk:  # Novo registro
            obj.criado_por = request.user
        obj.ultimo_ajuste_por = request.user
        super().save_model(request, obj, form, change)


Pasta: Template/origem_categoria, Arquivo origem_categoria.html

{% extends "base.html" %}
{% block title %}Dashboard{% endblock %}
{% block content %}


<section class="section dashboard">
    <div class="row">
        <!-- Left side columns -->
        <div class="col-lg-12">
            <div class="row">


                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Manutenção Origens & Categorias</h5>

                        <!-- Bordered Tabs Justified -->
                        <ul class="nav nav-tabs nav-tabs-bordered d-flex" id="borderedTabJustified" role="tablist">
                            <li class="nav-item flex-fill" role="presentation">
                                <button class="nav-link w-100 active" id="home-tab" data-bs-toggle="tab"
                                    data-bs-target="#bordered-justified-home" type="button" role="tab"
                                    aria-controls="verPesquisar" aria-selected="true">Origem</button>
                            </li>

                            <li class="nav-item flex-fill" role="presentation">
                                <button class="nav-link w-100" id="profile-tab" data-bs-toggle="tab"
                                    data-bs-target="#bordered-justified-profile" type="button" role="tab"
                                    aria-controls="inserirModificar" aria-selected="false">Categoria</button>
                            </li>
                        </ul>
                        <div class="tab-content pt-2" id="borderedTabJustifiedContent">
                            <div class="tab-pane fade show active" id="bordered-justified-home" role="tabpanel"
                                aria-labelledby="verPesquisar-tab">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Origem</h5>

                                        <!-- Table with stripped rows -->
                                        <table class="table datatable" id="origemTableBody">
                                            <thead>
                                                <tr>
                                                    <th>Origem</th>
                                                    <th>Status</th>
                                                    <th>Criado por:</th>
                                                    <th data-type="date" data-format="DD/MM/YYYY">Criado em:</th>
                                                    <th>Ultimo Ajuste por:</th>
                                                    <th data-type="date" data-format="DD/MM/YYYY">Ultimo Ajuste em::
                                                    </th>
                                                    <th>Ação</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                        <!-- End Table with stripped rows -->
                                    </div>
                                </div>
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Cadastrar ou Modificar</h5>

                                        <!-- Multi Columns Form -->
                                        <form class="row g-3" method="POST" action="{% url 'salvar_origem' %}">
                                            {% csrf_token %}
                                            <input type="hidden" id="inputOrigemId" name="id">
                                            <div class="col-md-12">
                                                <label for="inputOrigemName" class="form-label">Nome</label>
                                                <input type="text" class="form-control" id="inputOrigemName"
                                                    name="nome">
                                            </div>
                                            <div class="col-md-4">
                                                <label for="inputOrigemStatus" class="form-label">Status</label>
                                                <select id="inputOrigemStatus" class="form-select" name="status">
                                                    <option value="True">Ativo</option>
                                                    <option value="False">Inativo</option>
                                                </select>
                                            </div>
                                            <div class="text-center">
                                                <button type="submit" class="btn btn-primary">Salvar</button>
                                                <button type="reset" class="btn btn-secondary">Resetar</button>
                                            </div>
                                        </form>
                                        <!-- End Multi Columns Form -->
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="bordered-justified-profile" role="tabpanel"
                                aria-labelledby="inserirModificar-tab">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Categoria</h5>

                                        <!-- Table with stripped rows -->
                                        <table class="table datatable" id="categoriaTableBody">
                                            <thead>
                                                <tr>
                                                    <th>Categoria</th>
                                                    <th>Status</th>
                                                    <th>Criado por:</th>
                                                    <th data-type="date" data-format="DD/MM/YYYY">Criado em:</th>
                                                    <th>Ultimo Ajuste por:</th>
                                                    <th data-type="date" data-format="DD/MM/YYYY">Ultimo Ajuste em::
                                                    </th>
                                                    <th>Ação</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <!-- End Table with stripped rows -->

                                        <div class="card">
                                            <div class="card-body">
                                                <h5 class="card-title">Cadastrar ou Modificar</h5>

                                                <!-- Multi Columns Form -->
                                                <form class="row g-3" method="post"
                                                    action="{% url 'salvar_categoria' %}">
                                                    {% csrf_token %}
                                                    <input type="hidden" id="inputCategoriaId" name="id">
                                                    <div class="col-md-12">
                                                        <label for="inputCategoriaName" class="form-label">Nome</label>
                                                        <input type="text" class="form-control" id="inputCategoriaName"
                                                            name="nome">
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label for="inputCategoriaStatus"
                                                            class="form-label">Status</label>
                                                        <select id="inputCategoriaStatus" class="form-select"
                                                            name="status">
                                                            <option value="True">Ativo</option>
                                                            <option value="False">Inativo</option>
                                                        </select>
                                                    </div>
                                                    <div class="text-center">
                                                        <button type="submit" class="btn btn-primary">Salvar</button>
                                                        <button type="reset" class="btn btn-secondary">Resetar</button>
                                                    </div>
                                                </form>

                                                ><!-- End Multi Columns Form -->
                                            </div>
                                        </div>
                                    </div>
                                </div><!-- End Bordered Tabs Justified -->

                            </div>
                        </div>
                    </div>
                </div><!-- End Left side columns -->
            </div>
</section>
<script>

    document.addEventListener("DOMContentLoaded", function () {
        fetch("{% url 'consultar_origens' %}")
            //fetch("/consultar-origens/")
            .then(response => response.json())
            .then(data => {
                const tableBody = document.getElementById("origemTableBody");
                tableBody.innerHTML = ""; // Limpa o conteúdo existente

                data.origens.forEach(origem => {
                    const row = `
                        <tr data-id="${origem.id}">
                            <td>${origem.nome}</td>
                            <td>${origem.status}</td>
                            <td>${origem.criado_por}</td>
                            <td>${origem.criado_em}</td>
                            <td>${origem.ultimo_ajuste_por}</td>
                            <td>${origem.ultimo_ajuste_em}</td>
                            <td>
                               <!-- <button class="btn btn-sm btn-primary" onclick="logRowId(this)" data-id="$ origem.i }">Editar</button> -->
                                <button class="btn btn-sm btn-primary" onclick="editRowOrigem(this)">Editar</button>
                            </td>
                        </tr>
                    `;
                    tableBody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error("Erro ao carregar dados de origens:", error);
            });
    });

    document.addEventListener("DOMContentLoaded", function () {
        //fetch("{% url 'consultar_categorias' %}")
        fetch("/consultar-categorias/")
            .then(response => response.json())
            .then(data => {
                const tableBody = document.getElementById("categoriaTableBody");
                tableBody.innerHTML = ""; // Limpa o conteúdo existente

                data.categorias.forEach(categoria => {
                    const row = `
                        <tr data-id="{{ categoria.id }}">
                            <td>${categoria.nome}</td>
                            <td>${categoria.status}</td>
                            <td>${categoria.criado_por}</td>
                            <td>${categoria.criado_em}</td>
                            <td>${categoria.ultimo_ajuste_por}</td>
                            <td>${categoria.ultimo_ajuste_em}</td>
                            <td>
                                <!-- <button class="btn btn-sm btn-primary" onclick="logRowId(this)" data-id="${categoria.id}">Editar</button> -->
                                <button class="btn btn-sm btn-primary" onclick="editRowCategoria(this)">Editar</button>
                            </td>
                        </tr>
                    `;
                    tableBody.innerHTML += row;
                });
            })
            .catch(error => {
                console.error("Erro ao carregar dados das categorias:", error);
            });
    });


    function editRowOrigem(button) {
        const row = button.closest("tr");
        const cells = row.querySelectorAll("td");
        const data = Array.from(cells).map(cell => cell.textContent.trim());

        // Preencher os campos do formulário
        document.getElementById("inputOrigemId").value = row.dataset.id || ""; // Certifique-se de usar um valor numérico ou vazio
        document.getElementById("inputOrigemName").value = data[0];
        document.getElementById("inputOrigemStatus").value = data[1] === "Ativo" ? "True" : "False";
    }


    function editRowCategoria(button) {
        const row = button.closest("tr");
        const cells = row.querySelectorAll("td");
        const data = Array.from(cells).map(cell => cell.textContent.trim());

        document.getElementById("inputCategoriaId").value = row.dataset.id || ""; // Certifique-se de usar um valor numérico ou vazio
        document.getElementById("inputCategoriaName").value = data[0];
        document.getElementById("inputCategoriaStatus").value = data[1] === "Ativo" ? "True" : "False";
    }


    function logRowId(button) {
        // Obtém o ID do atributo data-id
        const id = button.getAttribute("data-id");

        // Exibe o ID no console
        console.log("ID selecionado:", id);

        // Se quiser acessar a linha inteira:
        const row = button.closest("tr");
        console.log("Dados da linha:", row.innerText);

    }

    data.origens.forEach(origem => {
        const row = `
        <tr>
            <td>${origem.nome}</td>
            <td>${origem.status}</td>
            <td>${origem.criado_por}</td>
            <td>${origem.criado_em}</td>
            <td>${origem.ultimo_ajuste_por}</td>
            <td>${origem.ultimo_ajuste_em}</td>
            <td>
                <button 
                    class="btn btn-sm btn-primary" 
                    onclick="logRowId(this)" 
                    data-id="${origem.id}">Editar</button>
            </td>
        </tr>
    `;
        tableBody.innerHTML += row;
    });















</script>

{% endblock %}





---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################

Utilizando estes arquivos como base vou pedir para que faça alguns cruds pra mim.

Vamos iniciar com o objeto: "Objeto..."
Que terá os seguintes campos: (Campo1 desc..., campo2 desc..., ....)
Faça os ajustes necessários para adaptar o padrão estbelecido para atender este novo objeto.


---##########################################################################################################################
---##########################################################################################################################
---##########################################################################################################################



---> Exemplo de uso...................

Utilizando estes arquivos como base vou pedir para que faça alguns cruds pra mim.

Vamos iniciar com o objeto: conta_banco
Que terá os seguintes campos: (banco = char 100, descricao = char 100, conta char 10, digito char 2, agencia char 4, pix = char 500, documento = CPF ou CNPJ  )



Faça os ajustes necessários para adaptar o padrão estbelecido para atender este novo objeto.

---##########################################################################################################################