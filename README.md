# Simple Compiler

Переписываю свой старый компилятор https://github.com/forsaken1/compiler

По урезанной грамматике языка С, со старыми тестами

Статус: синтаксический анализ



## Todo

1. [x] Лексический анализ

2. [ ] Синтаксический анализ

3. [ ] Семантический анализ

4. [ ] Генерация

5. [ ] Оптимизация

6. [ ] Кодонеговнофикация (+ нормальные тесты)



## Установка и запуск

```bash
brew install crystal-lang
git clone git@github.com:forsaken1/simple-compiler.git
cd simple-compiler

crystal build simple-compiler.cr         # build compiler
./simple-compiler path/to/file.txt       # compile file without optimization
./simple-compiler -s path/to/file.txt    # returns list of tokens (scanner)
./simple-compiler -p path/to/file.txt    # returns syntax tree (parser)
./simple-compiler -g path/to/file.txt    # returns assembler code (generator)
./simple-compiler -o path/to/file.txt    # compile file with optimization
./simple-compiler -g -o path/to/file.txt # returns assembler code with optimization

crystal tester.cr # run all tests (don't work without simple-compiler)
```