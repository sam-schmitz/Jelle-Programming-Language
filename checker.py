# checker.py
#  Syntax Checker for Jelle

from lexer import Lexer, TokCat


class JelleChecker:

    def __init__(self, progstr):
        self.tokens = Lexer(progstr)

    def check_program(self):
        """ <PROGRAM> ::= {<STMT> SEMI} """
        while self.tokens.peek != TokCat.END:   #While the token is not the end keep checking for stmts followed by SEMIs
            self.check_stmt()
            self.tokens.expect(TokCat.SEMI)

    def check_stmt(self):
        """ <STMT> ::= <INPUT_STMT> | <ASSIGN_STMT> | <DISPLAY_STMT> """
        start = self.tokens.expect(TokCat.INPUT, TokCat.ID, TokCat.DISPLAY,
        consume=False)  #Check the first token to see what type of statement
        if start == TokCat.INPUT:
            self.check_input()
        elif start == TokCat.ID:
            self.check_assignment()
        elif start == TokCat.DISPLAY:
            self.check_display()

    def check_input(self):
        """   <INPUT_STMT> ::= INPUT ID {COMMA ID} """
        self.tokens.expect(TokCat.INPUT)
        self.tokens.expect(TokCat.ID)
        while(self.tokens.peek == TokCat.COMMA):    #While a COMMA is next than look for an ID to follow
            self.tokens.get()
            self.tokens.expect(TokCat.ID)

    def check_assignment(self):
        """  <ASSIGN_STMT> ::= ID ASSIGN <E> """
        self.tokens.expect(TokCat.ID)
        self.tokens.expect(TokCat.ASSIGN)
        self.check_expr()

    def check_display(self):
        """ <DiSPLAY_STMT> ::= DISPLAY <DISPLAY_ARG> {COMMA <DSIPLAY_ARG} """
        self.tokens.expect(TokCat.DISPLAY)
        self.check_display_arg()
        while self.tokens.peek != TokCat.SEMI:    #While the next char isn't NL look for COMMA and display_arg
            self.tokens.expect(TokCat.COMMA)
            self.check_display_arg()

    def check_display_arg(self):
        """ <DISPLAY_ARG> ::= STRING | NL | <E> """
        if self.tokens.peek == TokCat.STRING:   #If the next character is a STRING check
            self.tokens.expect(TokCat.STRING)
        elif self.tokens.peek == TokCat.NL: #IF the next char is a NL check
            self.tokens.expect(TokCat.NL)
        else:   #If the next char is neither NL or STRING it must be an E
            self.check_expr()

    def check_expr(self):
        """ <E> ::= <E1> {ADDOP <E1>} """
        self.check_expr1()  #Guarenteed to need to check for an E1
        while self.tokens.peek == TokCat.ADDOP:
            self.tokens.expect(TokCat.ADDOP)
            self.check_expr1()

    def check_expr1(self):
        """ <E1> ::= <E2> {MULOP <E2>} """
        self.check_expr2()  #Guarenteed to need to check for an E2
        while self.tokens.peek == TokCat.MULOP:   #If the next character is a MULOP act acordingly
            self.tokens.expect(TokCat.MULOP)
            self.check_expr2()

    def check_expr2(self):
        """ <E2> ::= {ADDOP} <E3> """
        while True: #Stay in a loop until all ADDOPs are acounted for
            if self.tokens.peek == TokCat.ADDOP:   #Look for an ADDOP and check it
                self.tokens.expect(TokCat.ADDOP)
            else:   #If an ADDOP is not detected than break and look for an E3
                break
        self.check_expr3()

    def check_expr3(self):
        """ <E3> ::= <E4> EXPOP <E3> | <E4> """
        self.check_expr4()  #No mater what an E4 will be there
        if self.tokens.peek == TokCat.EXPOP:   #check to see if an EXPOP follows and react acordingly
            self.tokens.expect(TokCat.EXPOP)
            self.check_expr3()

    def check_expr4(self):
        """ <E4> ::= NUMBER | LPAREN <E> RPAREN | ID
                   | ID LPAREN [<E> {COMMA <E>}] RPAREN
        """
        start = self.tokens.expect(TokCat.NUMBER, TokCat.LPAREN, TokCat.ID, consume=False)  #check to see if one of the Tokens allowed is there
        if start == TokCat.NUMBER:
            self.tokens.get()
        if start == TokCat.LPAREN:
            self.tokens.expect(TokCat.LPAREN)  #Check for an expresion surrounded by PARENS
            self.check_expr()
            self.tokens.expect(TokCat.RPAREN)
        if start == TokCat.ID:
            self.tokens.expect(TokCat.ID) #Check for an ID
            if self.tokens.peek == TokCat.LPAREN: #if the next character is an LPAREN act acordingly
                self.tokens.expect(TokCat.LPAREN)
                if self.tokens.peek != TokCat.RPAREN:
                    self.check_expr()
                    while self.tokens.peek == TokCat.COMMA:
                        self.tokens.get()
                        self.check_expr()
                self.tokens.expect(TokCat.RPAREN)

def main():
    fname = input("file: ")
    with open(fname) as infile:
        program = infile.read()
    checker = JelleChecker(program)
    checker.check_program()
    print("Looks Good!")


if __name__ == "__main__":
    main()
