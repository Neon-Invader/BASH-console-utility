#!/bin/bash

# Инициализация переменной для команды
command=""

# Обработка аргументов с использованием getopts
while getopts ":u:-:" opt; do
    case $opt in
        u)  # Обработка флага -u
            command="users"
            ;;
        -)  # Обработка длинного флага, например --users
            case "${OPTARG}" in
                users)
                    command="users"
                    ;;
                *)
                    echo "Неподдерживаемый параметр —${OPTARG}" >&2
                    exit 1
                    ;;
            esac
            ;;
        \?) # Обработка неверных опций
            echo "Неподдерживаемый флаг: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Опция -$OPTARG требует аргумент." >&2
            exit 1
            ;;
    esac
done

# Сдвигаем позиционные параметры
shift $((OPTIND -1))

# Здесь можно использовать переменную command для дальнейших действий
echo "Выбранная команда: $command"
