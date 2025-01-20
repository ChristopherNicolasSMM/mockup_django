from pathlib import Path
import os

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'unsafe-secret-key')

DEBUG = True

ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', '*').split(',')

LOCALE_PATHS = [
    os.path.join(BASE_DIR, 'locale'),
]

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'financeiro',
    # Outras apps
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    # Middleware de internacionalização
    'django.middleware.locale.LocaleMiddleware',
]

ROOT_URLCONF = 'myproject.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'myproject.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


#LOGIN_REDIRECT_URL = '/'

#LOGOUT_REDIRECT_URL = '/login/'  # Altere para a URL desejada

# Local onde o Django busca arquivos estáticos durante o desenvolvimento
STATIC_URL = '/static/'

# Diretório raiz para coletar os arquivos estáticos (usado em produção)
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

# Diretórios adicionais onde o Django deve buscar arquivos estáticos
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'assets'), #Modelo HTML Admin

]

MEDIA_URL = '/media/'

MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

LANGUAGE_CODE = 'pt-BR'

LANGUAGES = [
    ('en', 'English'),
    ('pt-BR', 'Português Brasileiro'),
    ('es', 'Español'),
]

TIME_ZONE = 'America/Sao_Paulo'

DATE_FORMAT = "d/m/Y"

DATETIME_FORMAT = "d/m/Y H:i:s"

USE_L10N = False

USE_TZ = True

USE_I18N = True
