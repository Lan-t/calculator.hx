enum Token {
	EoF;
	Ide(value:String);
	Num(value:Int);
	Error(index:Int, message:String);
	Operator(token:String);
}

class Tokenizer {
	var code:String;
	var index:Int;

	public function new(code:String) {
		this.code = code;
	}

	public function tokenize():Array<Token> {
		this.index = 0;
		var tokens = new Array<Token>();
		while (this.index < code.length) {
			if (' \n\t\r'.indexOf(this.code.charAt(this.index)) != -1) {
				this.index++;
				continue;
			}
			tokens.push(
                if ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_".indexOf(this.code.charAt(this.index)) != -1) this.resolve_ide()
                else if ("0123456789".indexOf(this.code.charAt(this.index)) != -1) this.resolve_num()
                else if ("+-/*%=;()".indexOf(this.code.charAt(this.index)) != -1) this.resolve_single_token() 
                else this.resolve_error());
		}
		tokens.push(EoF);
		return tokens;
	}

	private function resolve_ide():Token {
		var res:String = '';

		while (true) {
			var n = this.code.charCodeAt(this.index);
			if ((n == 95) || (97 <= n && n <= 122) || (65 <= n && n <= 90)) {
				res += String.fromCharCode(n);
				this.index++;
			} else {
				break;
			}
		}

		return Ide(res);
	}

	private function resolve_num():Token {
		var res:String = '';

		while (true) {
			var n = this.code.charCodeAt(this.index);
			if (48 <= n && n <= 57) {
				res += String.fromCharCode(n);
				this.index++;
			} else {
				break;
			}
		}

		return Num(Std.parseInt(res));
	}

	private function resolve_single_token():Token {
		var n = this.code.charAt(this.index);
		this.index++;
		return Operator(n);
	}

	private function resolve_error():Token {
		this.index++;
		return Error(this.index, '知らないトークン');
	}
}
