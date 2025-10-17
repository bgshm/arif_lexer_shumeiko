%{
#include <iostream>
#include <string>

#include <FlexLexer.h>

FlexLexer* lexer = new yyFlexLexer;

#define yylex lexer->yylex

void yyerror(const char *s);
%}

%union {
    double dval;
}

%token <dval> NUMBER
%token EOL
%type <dval> expr

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

program:
    program line | line ;

line:
    EOL
    | expr EOL { std::cout << "=> " << $1 << std::endl; }
    ;

expr:
    NUMBER          { $$ = $1; }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { if ($3 != 0) { $$ = $1 / $3; } else { yyerror("Error: Division by zero."); $$ = 0; } }
    | '(' expr ')'  { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    ;

%%

int main() {
    std::cout << "Simple C++ Calculator. Enter expressions." << std::endl;
    while(true) {
        std::cout << "> ";
        if (yyparse() != 0) {
            std::cerr << "Parsing failed." << std::endl;
            break;
        }
    }
    return 0;
}

void yyerror(const char *s) {
    std::cerr << s << std::endl;
}