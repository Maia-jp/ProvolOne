echo "Compilando Bison..."
bison -d gramar.y

echo "Compilando Flex..."
flex parser.lex

echo "Compilando Executavel..."
gcc lex.yy.c gramar.tab.c -ll -o OUT