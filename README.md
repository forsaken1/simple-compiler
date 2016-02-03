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
crystal tester.cr # tests
```