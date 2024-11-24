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
    # Здесь можно добавить команду для получения списка пользователей, например:
    cut -d: -f1 /etc/passwd
}

# Функция для работы с файлом
function process_file {
    if [[ -z "$filename" ]]; then
        echo "Не указан файл для обработки."
        usage
    fi
    
    echo "Обработка файла: $filename"
    # Здесь можно добавить операции с файлом, например, вывести его содержимое
    cat "$filename"
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
        -)  # Обработка длинных флагов
            case "${OPTARG}" in
                users)
                    command="users"
                    ;;
                file)
                    filename="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
                    ;;
                *)
                    echo "Неподдерживаемый параметр --${OPTARG}" >&2
                    usage
                    ;;
            esac
            ;;
        \?) # Обработка неверного флага
            echo "Неверный параметр: -$OPTARG" >&2
            usage
            ;;
        :)  # Обработка пропущенных аргументов
            echo "Параметр -$OPTARG требует аргумент." >&2
            usage
            ;;
    esac
done

# Вызов соответствующей функции в зависимости от команды
if [[ "$command" == "users" ]]; then
    show_users
fi

if [[ -n "$filename" ]]; then
    process_file
fi
