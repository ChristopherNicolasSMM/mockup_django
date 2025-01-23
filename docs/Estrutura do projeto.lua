inicio/
    ├── venv/ (Virtual Env) ---Configurações isoladas de ambiente
    │   ├── ---OBS: Arquivos não serão listados...
    ├── myproject/ ---(Pasta do projeto principal)
    │   ├── core/
    │   ├── settings/
    │   │   ├── __init__.py
    │   │   ├── base.py --- Exemplo de configurações, e no momento inicial é a que esta vigente
    │   │   ├── development.py
    │   │   ├── production.py
    │   ├── __init__.py
    │   ├── asgi.py
    │   ├── wsgi.py
    │   ├── urls.py
    ├── financeiro/ (App do projeto)
    │   ├── migrations/
    │   │   ├── __init__.py
    │   ├── admin/
    │   │   ├── __init__.py
    │   │   ├── origem_categoria.py
    │   │   ├── conta_banco.py
    │   ├── models/
    │   │   ├── __init__.py
    │   │   ├── conta_banco.py
    │   │   ├── origem_categoria.py
    │   ├── templates/
    │   │   ├── origem_categoria/
    │   │   │   ├── origem_categoria.html
    │   │   ├── conta_banco/
    │   │   │   ├── conta_banco.html
    │   ├── views/
    │   │   ├── __init__.py
    │   │   ├── origem_categoria.py
    │   │   ├── conta_banco.py
    │   ├── static/
    │   ├── relatorios/
    │   │   ├── modelos/
    │   │   ├── saida/
    │   │   ├── DynamicReportGenerator.py ---Arquivo com a classe para gerar relatório de acordo com modelo e json
    │   ├── tests/
    │   │   ├── __init__.py
    │   ├── __init__.py
    ├── requirements.txt (Dependências do projeto)
    ├── .gitignore (Se configurado)
    ├── manage.py
    ├── README.md
    ├── 
