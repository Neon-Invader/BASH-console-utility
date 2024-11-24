#!/bin/bash

# Переменные для хранения значений опций
command=""
filename=""

# Функция для вывода справки
function usage {
    echo "Использование: $0 [-u] [-f filename] [--users] [--file filename]"
    echo "  -u, --users          Показывает существующих пользователей"
    echo "  -f filename, --file filename  Указывает файл для работы"
    exit 1
}

# Функция для отображения пользователей
function show_users {
    echo "Существующие пользователи:"
    if ! cut -d: -f1 /etc/passwd; then
        echo "Ошибка: не удалось получить список пользователей."
    fi
}

# Функция для проверки доступа к файлу
function check_access {
    if [[ ! -e "$filename" ]]; then
        echo "Ошибка: файл '$filename' не существует."
        exit 1
    elif [[ ! -r "$filename" ]]; then
        echo "Ошибка: у вас нет прав на чтение файла '$filename'."
        exit 1
    fi
}

# Функция для работы с файлом
function process_file {
    check_access
    
    echo "Обработка файла: $filename"
    if ! cat "$filename"; then
        echo "Ошибка: не удалось прочитать файл '$filename'."
    fi
}

# Обработка аргументов командной строки
while getopts ":uf:-:" opt; do
    case $opt in
        u)  # Обработка флага -u
            command="users"
            ;;
        f)  # Обработка флага -f
            filename="$OPTARG"
            ;;
        -)  # Обработка длинных опций
            case "${OPTARG}" in
                users) command="users" ;;
                file)  filename="${!OPTIND}" ; OPTIND=$((OPTIND + 1)) ;;
                *)     echo "Неизвестная опция --${OPTARG}" ; usage ;;
            esac
            ;;
        \?)
            echo "Недопустимый параметр - ${OPTARG}" >&2
            usage
            ;;
    esac
done

# Выполнение соответствующих действий
if [[ "$command" == "users" ]]; then
    show_users
elif [[ -n "$filename" ]]; then
    process_file
else
    usage
fi
