# Django Project with Custom User Model

This is a Django project created with a custom User model using a Bash script. The script automates the process of creating a Django project with a core app containing a custom User model.

## Requirements

- Python 3.x
- Django

## Usage

1. Clone this repository:

    ```bash
    git clone <repository_url>
    ```

2. Navigate to the directory where the script is located.

3. Run the script with the following command:

    ```bash
    ./automate_django.sh <project_name> <app_name>
    ```

    Replace `<project_name>` with the desired name for your Django project and `<app_name>` with the desired name for your core app.

4. Follow the prompts provided by the script.

## Project Structure

- `project_name/`: Django project directory.
  - `settings.py`: Django project settings file.
  - `app_name/`: Core app directory.
    - `models.py`: Contains the custom User model.
    - `admin.py`: Registers the custom User model in the Django admin.

## Custom User Model

The custom User model is defined in the `app_name/models.py` file. It inherits from Django's `AbstractBaseUser` and `PermissionsMixin` classes and provides customizations for the user model fields and authentication methods.

## Contributing

Contributions are welcome! If you have suggestions or improvements for this script or the README file, feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
