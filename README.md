# Simple Compiler

Rewrite my old compiler https://github.com/forsaken1/compiler

Grammar: C lang (cutted)

Status: syntax analysis



## Todo

1. [x] lexical analysis

2. [ ] syntax analysis

3. [ ] semantic analysis

4. [ ] code generation

5. [ ] optimization

6. [ ] code-not-shitication



## Installation

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