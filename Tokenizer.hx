import js.Error;

enum Token {
    EoF;
    Num(value: Int);
    Nil;
    Operator(token: String);
}


class Tokenizer {
    var code: String;
    var index: Int;

    public function new(code: String) {
        this.code = code;
    }

    public function tokenize(): Array<Token> {
        this.index = 0;
        var tokens = new Array<Token>();
        while (this.index < code.length) {
            if (' \n\t\r'.indexOf(this.code.charAt(this.index)) != -1) {
                this.index ++;
                continue;
            }
            tokens.push(
                if ("0123456789".indexOf(this.code.charAt(this.index)) != -1) this.resolve_num()
                else if ("+-/*%()".indexOf(this.code.charAt(this.index)) != -1) this.resolve_single_token()
                else this.resolve_nil()
            );
        }
        tokens.push(EoF);
        return tokens;
    }

    private function resolve_num(): Token {
        var res: String = '';

        while (true) {
            var n = this.code.charCodeAt(this.index);
            if (48 <= n && n <= 57) {
                res += String.fromCharCode(n);
                this.index ++;
            } else {
                break;
            }
        }

        return Num(Std.parseInt(res));
    }

    private function resolve_single_token(): Token {
        var n = this.code.charAt(this.index);
        this.index ++;
        return Operator(n);
    }

    private function resolve_nil(): Token {
        this.index ++;
        throw new Error("unknown token");
        return Nil;
    }
}
