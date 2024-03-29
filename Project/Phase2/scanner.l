%{
  #include <stdio.h>
  #include <string.h>

  // Type of tokens.
  typedef enum {key, id, op, punc, integer, doub, ch, sci, str, nl, noth, error} Type;
  typedef enum {false, true} bool; // Boolean algebra.

  void print(Type type); // Print out the output messages.

  int numLines = 0; // Count the number of lines of the input file.
  char line[1000] = ""; // Buffer for the texts of a line.
  bool inComment = false; // See if the current position is in a comment.
  bool mulComment = false; // See which type of comment.
  bool inError = false; // See if encounter error.
  bool sourceOn = true; // Control pragma source on or off.
  bool tokenOn = true; // Control pragma token on or off.
%}

DIGIT [0-9]
ID [_a-zA-Z][_a-zA-Z0-9]*
OP [+-/%<>=!&*]
PUNC [:;,.\[\](){}]
INTEGER 0|[1-9]{DIGIT}*
DOUBLE {DIGIT}*\.{DIGIT}+|{DIGIT}+\.{DIGIT}*
SCI {DIGIT}+[eE][+-]?{DIGIT}+|{DOUBLE}[eE][+-]?{DIGIT}+
CHAR '([^'])?'
STRING \"([^"])*\"|\"\"
WHITESPACE [ \t]+
%%
"#pragma source on" {sourceOn = true;
                     print(noth);}
"#pragma source off" {sourceOn = false;
                      print(noth);}
"#pragma token on" {tokenOn = true;
                    print(noth);}
"#pragma token off" {tokenOn = false;
                     print(noth);}
"#pragma". {print(error);}
"/*" {inComment = true;
      mulComment = true;
      print(noth);}
"//" {inComment = true;
      mulComment = false;
      print(noth);}
"*/" {inComment = false;
      mulComment = false;
      print(noth);}
"void" {print(key);}
"int" {print(key);}
"double" {print(key);}
"bool" {print(key);}
"char" {print(key);}
"null" {print(key);}
"for" {print(key);}
"while" {print(key);}
"do" {print(key);}
"if" {print(key);}
"else" {print(key);}
"switch" {print(key);}
"return" {print(key);}
"break" {print(key);}
"continue" {print(key);}
"const" {print(key);}
"true" {print(key);}
"false" {print(key);}
"struct" {print(key);}
"case" {print(key);}
"default" {print(key);}
"fclose" {print(key);}
"clearerr" {print(key);}
"feof" {print(key);}
"ferror" {print(key);}
"fflush" {print(key);}
"fgetpos" {print(key);}
"fopen" {print(key);}
"fread" {print(key);}
"freopen" {print(key);}
"fseek" {print(key);}
"fsetpos" {print(key);}
"ftell" {print(key);}
"fwrite" {print(key);}
"remove" {print(key);}
"rename" {print(key);}
"rewind" {print(key);}
"setbuf" {print(key);}
"setvbuf" {print(key);}
"tmpfile" {print(key);}
"tmpnam" {print(key);}
"fprintf" {print(key);}
"printf" {print(key);}
"sprintf" {print(key);}
"vfprintf" {print(key);}
"vprintf" {print(key);}
"vsprintf" {print(key);}
"fscanf" {print(key);}
"scanf" {print(key);}
"sscanf" {print(key);}
"fgetc" {print(key);}
"fgets" {print(key);}
"fputc" {print(key);}
"fputs" {print(key);}
"getc" {print(key);}
"getchar" {print(key);}
"gets" {print(key);}
"putc" {print(key);}
"putchar" {print(key);}
"puts" {print(key);}
"ungetc" {print(key);}
"perror" {print(key);}
{PUNC} {print(punc);}
"++" {print(op);}
"--" {print(op);}
"<=" {print(op);}
">=" {print(op);}
"==" {print(op);}
"!=" {print(op);}
"&&" {print(op);}
"||" {print(op);}
{OP} {print(op);}
{DOUBLE}{DOUBLE}+ {print(error);}
{INTEGER} {print(integer);}
{DOUBLE} {print(doub);}
{SCI} {print(sci);}
{ID} {print(id);}
{CHAR} {print(ch);}
{STRING} {print(str);}
{DIGIT}[a-zA-Z0-9]+ {print(error);}
{DIGIT}+[eE][+-]?[a-zA-Z]+|{DOUBLE}[eE][+-]?[a-zA-Z]+ {print(error);}
{ID}@+ {print(error);}
\n {inComment = (mulComment == true) ? true : false;
    mulComment = (inComment == 1) ? true : false;
    print(nl);
    strcpy(line, "");}
{WHITESPACE} {print(noth);}
'\" {print(noth);}
. {print(error);}
%%
int main(int argc, char **argv)
{
  yyin = fopen(argv[1], "r"); // Input file
  yylex();
  return 0;
}
int yywrap()
{
  return 1; // EOF
}
void print(Type type)
{
  switch(type)
  {
    case key:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#key:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case id:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#id:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case op:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#op:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case punc:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#punc:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case integer:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#integer:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case doub:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#double:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case ch:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#char:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case sci:
      if (inComment == false && inError == false && tokenOn == true)
      {
        printf("#sci:%s\n", yytext);
      }
      strcat(line, yytext);
      break;
    case str:
      if (inComment == false && inError == false && tokenOn == true)
      {
        char printStr[1000];
        strncpy(printStr, yytext + 1, yyleng - 2);
        printStr[yyleng - 2] = '\0';
        printf("#string:%s\n", printStr);
      }
      strcat(line, yytext);
      break;
    case nl:
      if (inError == false && sourceOn == true)
      {
        printf("%d:%s\n", ++numLines, line);
        break;
      }
      else if (inError == false && sourceOn == false)
      {
        ++numLines;
        break;
      }
      else if (inError == true)
      {
        fprintf(stderr, "Error at line %d: %s\n", ++numLines, line);
        exit(1);
      }
      else
      {
        break;
      }
    case noth:
      strcat(line, yytext);
      break;
    case error:
      if (inComment == true)
      {
        break;
      }
      else
      {
        if (inError == false)
        {
          inError = true;
          strcpy(line, yytext);
        }
        else
        {
          strcat(line, yytext);
        }
      }
  }
}