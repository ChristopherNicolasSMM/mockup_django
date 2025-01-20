--Criar virtual env. ###
python -m venv venv

--Ativar no windows com vs code
.\venv\Scripts\Activate

--Criar Aplicação Django
django-admin startproject myproject .




myproject/
    ├── core/ (App principal, caso precise)
    ├── settings/ (Separação de configurações)
    │   ├── base.py
    │   ├── development.py
    │   ├── production.py
    ├── Dockerfile
    ├── docker-compose.yml
    ├── requirements.txt
    ├── manage.py
    ├── static/
    ├── media/


    Executar o Projeto Localmente
    Ative o ambiente virtual: No PowerShell:
    
    .\venv\Scripts\Activate
    Instale as dependências: No terminal:
    
    pip install -r requirements.txt
    Realize as migrações do banco de dados:
    
    python manage.py migrate
    Execute o servidor de desenvolvimento:
    
    python manage.py runserver
    
"Estando tudo ok tem de executar via porta 8000, após isso iniciar criação das aplicações dentro do projeto"

    python manage.py startapp nome_da_aplicacao

--Para que a aplicação seja reconhecida pelo Django, adicione-a à lista INSTALLED_APPS no arquivo settings/base.py.

INSTALLED_APPS = [
    # Django apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'nome_da_aplicacao',
]


---Criar usuário admin para django admin
python manage.py createsuperuser



--Gerar requirements
pip freeze > requirements.txt


---instalar requirements
pip install -r requirements.txt












--########Automatize o Deploy na VPS###########
-- 1 - Adicione um script de deploy:
--Exemplo arquivo deploy.sh
#!/bin/bash
git pull origin main
docker-compose down
docker-compose up --build -d

-- 2 - Configure variáveis dinâmicas no ambiente:
--No arquivo .env
DJANGO_SECRET_KEY=your-production-secret-key
DEBUG=0
ALLOWED_HOSTS=yourdomain.com













#################@@@@@@@@@@@@@

# create_project.sh
#!/bin/bash
git clone https://github.com/your-repo/django-template.git $1
cd $1
mv myproject $1
sed -i "s/myproject/$1/g" $(grep -rl myproject .)
