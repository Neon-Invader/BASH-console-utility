#!/bin/bash

# Переменные для хранения значений опций
log_file=""
error_file=""

# Функция для вывода справки
function usage
{
    echo "Использование: $0 [-u] [-p] [-l PATH] [-e PATH] [-h]"
    echo "  -u, --users          Показывает существующих пользователей и их домашние директории."
    echo "  -p, --processes      Показывает запущенные процессы, отсортированные по ID."
    echo "  -l PATH, --log PATH  Записывает вывод в файл по заданному пути."
    echo "  -e PATH, --errors PATH  Записывает ошибки в файл по заданному пути."
    echo "  -h, --help           Выводит справку."
    exit 1
}

# Функция для отображения пользователей
function show_users
{
    local output
    output=$(getent passwd | awk -F: '{print $1, $6}' | sort) 2> >(tee -a "$error_file" >&2)
    if [[ -n "$output" ]]; then
        echo "$output"
    else
        echo "Ошибка: не удалось получить список пользователей." >&2
    fi
}

# Функция для отображения процессов
function show_processes
{
    local output
    output=$(ps -eo pid,comm --sort=pid) 2> >(tee -a "$error_file" >&2)
    if [[ -n "$output" ]]; then
        echo "$output"
    else
        echo "Ошибка: не удалось получить список процессов." >&2
    fi
}

# Функция для записи в файл
function write_to_file
{
    local output="$1"
    if [[ -n "$log_file" ]]; then
        echo "$output" >> "$log_file" 2> >(tee -a "$error_file" >&2)
    else
        echo "$output"
    fi
}

# Обработка аргументов командной строки
while getopts ":upl:e:h" opt; do
    case ${opt} in
        u)
            output=$(show_users)
            write_to_file "$output"
            ;;
        p)
            output=$(show_processes)
            write_to_file "$output"
            ;;
        l)
            log_file="$OPTARG"
            ;;
        e)
            error_file="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Неизвестный аргумент: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Опция -$OPTARG требует аргумент." >&2
            usage
            ;;
    esac
done
