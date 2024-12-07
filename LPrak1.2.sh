#!/bin/bash

function list_users {
    echo "List of users"
    awk -F: '$3 >= 1000 { print $1, $6 }' /etc/passwd | sort
}
#   awk: это утилита для обработки текстовых данных.
#   -F':': устанавливает символ : в качестве разделителя полей. В файле /etc/passwd каждый пользователь представлен строкой, где данные разделены двоеточиями.
#   '{ print $1, $6 }': команда awk, которая выводит первое ($1) и шестое ($6) поля для каждой строки:
#       $1 — это имя пользователя.
#       $6 — это домашний каталог пользователя.
#       $3 >= 1000 - убирает и списка пользователей

function list_processes {
    echo "List of processes"
    ps -eo pid,comm --sort=pid
}
#    ps: команда для отображения информации о текущих процессах.
#   -e: этот параметр говорит команде ps, что нужно отобразить все процессы, запущенные в системе, а не только процессы текущего пользователя.
#   -o: указывает формат вывода. В данном случае, указываются поля, которые будут выводиться.
#    pid: идентификатор процесса (Process ID).
#    comm: имя команды или процесса.
#    --sort=pid: сортирует вывод по идентификатору процесса (PID) в порядке возрастания.

# функция для вывода подсказок (справки) о командах
function show_help {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -u, --users            List users and their home directories"
    echo "  -p, --processes        List running processes"
    echo "  -h, --help             Show this help message"
    echo "  -l PATH, --log PATH    Redirect output to a file at PATH"
    echo "  -e PATH, --errors PATH Redirect error output to a file at PATH"
}

log_path=""
error_path=""
action=""

# Функция для записи сообщений об ошибках в файл
log_error() {
    local message="$1"
    if [[ -n "$error_path" ]]; then
        echo "Error: $message" >> "$error_path"
    else
        echo "Error: $message" >&2
    fi
}

# getopts анализирует (парсит) опции и аргументы команд, которые были переданы
# $OPTIND - индекс опции; $OPTARG - доп. аргумент опции.
while getopts ":uphl:e:-:" opt; do
    case $opt in
        u)
            action="users"
            ;;
        p)
            action="processes"
            ;;
        h)
            show_help
            exit 0
            ;;
        l)
            if [[ -z "$OPTARG" ]]; then
                echo "Option -l requires an argument." >&2
                exit 1
            fi
            log_path="$OPTARG"
            ;;
        e)
            if [[ -z "$OPTARG" ]]; then
                log_error "Option -e requires an argument." >&2
                exit 1
            fi
            error_path="$OPTARG"
            ;;
        -)
            case "${OPTARG}" in
            users)
                action="users"
                ;;
            processes)
                action="processes"
                ;;
            help)
                show_help
                exit 0
                ;;
            log)
                log_path="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
                ;;
            errors)
                error_path="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
                ;;
             *)
                log_error "Invalid option: --${OPTARG}" >&2
                exit 1
                ;;
            esac
            ;;
        \?)
            log_error "Invalid opion: -$OPTARG" >&2
            exit 1
            ;;
        :)
            log_error "Option -$OPTARG requirs an argument." >&2
            exit 1
            ;;
    esac
done
# &> перенаправляет stdout, stderr в один файл
# >&2 перенаправляет stdout в stderr
# 2> перенаправляет stderr в указанный файл
# dev/null - спец. файл "черная дыра"

# Функция проверки доступности пути и создание файла, если необходимо
check_and_create_file() {
    local path="$1"
    if [[ ! -d "$(dirname "$path")" ]]; then
        log_error "Error: The '$path' directory does not exist." >&2
        exit 1
    fi

    if [[ -f "$path" ]]; then
        echo "Warning: The file '$path' exists. Will be overwritten." >&2
    fi
    touch "$path" 
    if [[ ! -w "$path" ]]; then
        log_error "Error: No write permission to '$path'" >&2
        exit 1
    fi
}

# Перенаправление стандартного вывода
if [[ -n "$log_path" ]]; then
    check_and_create_file "$log_path"
    exec > "$log_path"
fi

# Перенаправление вывода ошибок
if [[ -n "$error_path" ]]; then
    check_and_create_file "$error_path"
    exec 2> "$error_path"
fi


case $action in
    users)
        list_users
        ;;
    processes)
        list_processes
        ;;
    *)
        log_error "Error: no action specified." >&2
        show_help
        exit 1
        ;;
esac
