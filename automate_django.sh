#!/bin/bash

# Function to create a Django project with a core app containing a custom User model
create_django_project() {
    project_name="$1"
    app_name="$2"

    # Create virtual environment
    mkdir "$project_name"
    cd "$project_name" || exit
    pip install virtualenv
    virtualenv venv

    # Activate virtual environment based on operating system
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        source venv/bin/activate
    elif [[ "$OSTYPE" == "msys" ]]; then
        source venv/Scripts/activate
    else
        echo "Unsupported operating system. Please activate the virtual environment manually."
        exit 1
    fi

    # Install Django
    pip install django

    # Create Django project
    django-admin startproject "$project_name"
    cd "$project_name" || exit

    # Create core app
    python manage.py startapp "$app_name"

    # Create User model in core app
    cat <<EOF > "$app_name"/models.py
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models

class UserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(email, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.email
EOF

    # Register User model in admin
    cat <<EOF > "$app_name"/admin.py
from django.contrib import admin
from .models import User

admin.site.register(User)
EOF

    # Add core app to INSTALLED_APPS in settings.py
    sed -i "s/    'django.contrib.staticfiles',/    'django.contrib.staticfiles',\n    '$project_name.$app_name',/g" "$project_name"/settings.py

    # Run migrations
    python manage.py makemigrations "$app_name"
    python manage.py migrate
}

# Check if necessary tools are installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install Python 3 before running this script."
    exit 1
fi

# Check if correct number of arguments provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project_name> <app_name>"
    exit 1
fi

# Call function to create Django project with core app and custom User model
create_django_project "$1" "$2"
