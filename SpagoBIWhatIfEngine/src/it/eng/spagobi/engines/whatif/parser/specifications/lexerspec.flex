/*
	Draft Lexer per metalinguaggio What-if
*/

/*
a lexical specification file for JFlex consists of three parts divided by a single line starting with %%:
UserCode 
 
Options and declarations 

Lexical rules

*/

/* --------------------------Usercode Section------------------------ */
   
import java_cup.runtime.*;
 
/*
The text up to the first line starting with %% is copied verbatim to the top of the generated lexer class (before the actual class declaration). Beside package and import statements there is usually not much to do here. If the code ends with a javadoc class comment, the generated class will get this comment, if not, JFlex will generate one automatically.
*/ 
%%

/* -----------------Options and Declarations Section----------------- */
/* see http://jflex.de/manual.html#SECTION00052000000000000000 */
   
/* 
   The name of the class JFlex will create will be Lexer.
   Will write the code to the file Lexer.java. 
*/
%class Lexer

/*
	Makes the generated class public
*/
%public 

/*
	Creates a main function in the generated class that expects the name of an input file on the command line and then runs the scanner on this input file by printing information about each returned token to the Java console until the end of file is reached. The information includes: line number (if line counting is enabled), column (if column counting is enabled), the matched text, and the executed action (with line number in the specification).
*/
/* %debug */

/*
defines the set of characters the scanner will work on. For scanning text files, %unicode should always be used. The Unicode version may be specified, e.g. %unicode 4.1. If no version is specified, the most recent supported Unicode version will be used - in JFlex 1.5.1, this is Unicode 6.3. See also section 5 for more information on character sets, encodings, and scanning text vs. binary files.
*/

/* %unicode */

/* 
   Will switch to a CUP compatibility mode to interface with a CUP
   generated parser.
*/
%cup

/*
  The current line number can be accessed with the variable yyline
  and the current column number with the variable yycolumn.
*/
%line
%column

/*
  Declarations
   
  Code between %{ and %}, both of which must be at the beginning of a
  line, will be copied letter to letter into the lexer class source.
  Here you declare member variables and functions that are used inside
  scanner actions.  
*/
%{   
	
	
	private boolean verbose = false;
	
	/*
		set verbose to true to enable print of information about tokens
	*/
	public void setVerbose(boolean value){
		this.verbose = value;
	}

    /* To create a new java_cup.runtime.Symbol with information about
       the current token, the token will have no value in this
       case. */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    /* Also creates a new java_cup.runtime.Symbol with information
       about the current token, but this object has a value. */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/*
  Macro Declarations
  
  Macros are abbreviations for regular expressions, used to make lexical specifications easier to read and understand. A macro declaration consists of a macro identifier followed by =, then followed by the regular expression it represents. This regular expression may itself contain macro usages. Although this allows a grammar like specification style, macros are still just abbreviations and not non terminals - they cannot be recursive or mutually recursive. Cycles in macro definitions are detected and reported at generation time by JFlex.
  
  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.  
*/

/* A line terminator is a \r (carriage return), \n (line feed), or
   \r\n. */
LineTerminator = \r|\n|\r\n
/* White space is a line terminator, space, tab, or line feed. */
WhiteSpace     = {LineTerminator} | [ \t\f]

DIGIT = [0-9]

NUMBER = {DIGIT}+(","{DIGIT}+)?

ALPHANUMERIC = [A-Za-z0-9]

VARIABLE = [:jletter:]+[:jletterdigit:]*

MEMBER = {ALPHANUMERIC}+"."{ALPHANUMERIC}+ | {ALPHANUMERIC}+"."{ALPHANUMERIC}+"."{ALPHANUMERIC}+
   


/*
lexical state declaration example: %state STRING declares a lexical state STRING that can be used in the ``lexical rules'' part of the specification. A state declaration is a line starting with %state followed by a space or comma separated list of state identifiers. There can be more than one line starting with %state.

*/
/* %state STRING */
   
%% 

/* ------------------------Lexical Rules Section---------------------- */  
/*
   This section contains regular expressions and actions, i.e. Java
   code, that will be executed when the scanner matches the associated
   regular expression. */
   
   /* YYINITIAL is the state at which the lexer begins scanning.  So
   these regular expressions will only be matched if the scanner is in
   the start state YYINITIAL. */
   
<YYINITIAL> {

    /* Don't do anything if whitespace is found */
    {WhiteSpace}       { /* just skip what was found, do nothing */ }   
   
    /* Return the token SEMI declared in the class sym that was found. */
    ";"                { if(verbose){System.out.print(" ; ");} return symbol(sym.SEMI); }
   
    /* Print the token found that was declared in the class sym and then
       return it. */
    "+"                { if(verbose){System.out.print(" + ");} return symbol(sym.PLUS); }	
	"-" 			   { if(verbose){System.out.print(" - ");} return symbol(sym.MINUS);}  					   
    "*"                { if(verbose){System.out.print(" * ");} return symbol(sym.TIMES); }
    "/"                { if(verbose){System.out.print(" / ");} return symbol(sym.DIVIDE); }
    "("                { if(verbose){System.out.print(" ( ");} return symbol(sym.LPAREN); }
    ")"                { if(verbose){System.out.print(" ) ");} return symbol(sym.RPAREN); }
    "%"                { if(verbose){System.out.print(" % ");} return symbol(sym.PERCENT); }
    "="                { if(verbose){System.out.print(" = ");} return symbol(sym.EQUAL); }
	
	/*
	*/
	{NUMBER} 		   { if(verbose){System.out.print(yytext());} String val = yytext().replaceAll(",",".");return new Symbol(sym.NUMBER, new Double(val)); } 
						
	{VARIABLE}		   { if(verbose){System.out.print(yytext());} return new Symbol(sym.VARIABLE, yytext()); }

	{MEMBER}		   { if(verbose){System.out.print(yytext());} return new Symbol(sym.MEMBER, yytext()); }


}


/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }   
