**BASH-console-utility**
Разработка консольной утилиты на языке BASH, которая обрабатывает аргументы командной строки и выполняет определенные действия.

**План выполнения:**
*1.* Разработать консольную утилиту на языке BASH, которая обрабатывает аргументы командной строки и выполняет следующие действия:
• для аргументов -u и --users выводит перечень пользователей и их домашних директорий на экран, отсортированных по алфавиту,
• для аргументов -p и --processes выводит перечень запущенных процессов, отсортированных по их идентификатору,
• для аргументов -h и --help выводит справку с перечнем и описанием аргументов и останавливает работу,
• для аргументов -l PATH и –log PATH замещает вывод на экран выводом в файл по заданному пути PATH,
• для аргументов -e PATH и –errors PATH замещает вывод ошибок из потока stderr в файл по заданному пути PATH.
*2.* Обработка аргументов командной строки должны производиться при  помощи механизмов getopt или getopts.
*3.* Обработка каждого типа действия должна производится в отдельной функции.
*4.* Программа должна проверять доступ к пути и выводить соответствующие сообщения об ошибках. При этом программа должна фильтровать или обрабатывать выводы в stderr используемых команд.
*5.* Задание должно быть выложено на github.
