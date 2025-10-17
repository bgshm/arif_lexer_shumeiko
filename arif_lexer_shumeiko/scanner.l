/* scanner.l -- Фінальна версія для генерації C++ коду */
%{
#include "parser.tab.h"
#include <cstdlib>
%}

/* Вказуємо генерувати C++ клас */
%option c++

/* Інші опції для простоти */
%option noyywrap

%%

[0-9]+(\.[0-9]+)?  {
                      /* ‼️ ВИПРАВЛЕНО: Використовуємо . замість -> */
                      yylval.dval = atof(yytext);
                      return NUMBER;
                   }

[ \t]              ;

\n                 { return EOL; }

.                  { return yytext[0]; }

%%