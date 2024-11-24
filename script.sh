#!/bin/bash

# Функция для вывода справки
print_help() 
{
    echo "Использование: $0 [OPTIONS]"
    echo ""
    echo "Опции:"
    echo "  -u, --users               Показать пользователей и их домашние директории (отсортировано по алфавиту)."
    echo "  -p, --processes           Показать запущенные процессы (отсортировано по ID)."
    echo "  -h, --help                Показать справку."
    echo "  -l PATH, --log PATH       Записать вывод в файл по заданному пути PATH."
    echo "  -e PATH, --errors PATH    Записать поток ошибок в файл по заданному пути PATH."
    exit 0
}

# Инициализация переменных для логирования
log_file=""
error_file=""

# Обработка аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--users)
            command="users"
            shift
            ;;
        
        -p|--processes)
            command="processes"
            shift
            ;;
        
        -h|--help)
            print_help
            ;;
        
        -l)
            log_file="$2"
            shift 2
            ;;
        
        --log)
            log_file="$2"
            shift 2
            ;;
        
        -e)
            error_file="$2"
            shift 2
            ;;
        
        --errors)
            error_file="$2"
            shift 2
            ;;
        
        *)
            echo "Неизвестная опция: $1" >&2
            exit 1
            ;;
    esac
done

# Вывод информации пользователей или процессов
if [ "$command" == "users" ]; then
    output=$(awk -F: '{ print $1, $6 }' /etc/passwd | sort)
elif [ "$command" == "processes" ]; then
    output=$(ps -eo pid,comm --sort=pid)
else
    echo "Не указана команда" >&2
    exit 1
fi

# Запись в лог-файл, если указан
if [ -n "$log_file" ]; then
    echo "$output" > "$log_file"
fi

# Запись ошибок в файл, если указан
if [ -n "$error_file" ]; then
    echo "Сообщение об ошибке" >&2 > "$error_file"
fi

# Вывод на экран
echo "$output"
