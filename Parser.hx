import Tokenizer;
import haxe.ds.Option;

enum Node {
	Num(value:Int);
	UnaryOperator(Token:String, hs:Node);
	BinaryOperator(Token:String, lhs:Node, rhs:Node);
	EoF;
	Err(index:Int, message:String);
}

class Parser {
	var tokens:Array<Token>;
	var index:Int;

	public function new(tokens:Array<Token>) {
		this.tokens = tokens;
		this.index = 0;
	}

	public function parse() {
		return this.expression();
	}

	private function expression():Node {
		var node = this.add();

		return node;
	}

	private function add():Node {
		var node = this.mul();
		while (true) {
			switch (this.tokens[this.index]) {
				case Token.Operator(token) if (token == '+'):
					this.index++;
					node = BinaryOperator('+', node, this.mul());
				case Token.Operator(token) if (token == '-'):
					this.index++;
					node = BinaryOperator('-', node, this.mul());
				case _:
					break;
			}
		}

		return node;
	}

	private function mul():Node {
		var node = this.cons();

		while (true) {
			switch (this.tokens[this.index]) {
				case Token.Operator(token) if (token == '*'):
					this.index++;
					node = BinaryOperator('*', node, this.cons());
				case Token.Operator(token) if (token == '/'):
					this.index++;
					node = BinaryOperator('/', node, this.cons());
				case _:
					break;
			}
		}

		return node;
	}

	private function cons():Node {
		var node:Option<Node> = None;

		while (true) {
			switch (this.tokens[this.index]) {
				case Token.Operator(token) if (token == '('):
					this.index++;
					node = Some(this.expression());
					if (!Type.enumEq(this.tokens[this.index], Token.Operator(')'))) {
						node = Some(Err(this.index, ')が無い'));
					}
					this.index++;
				case _:
					break;
			}
		}

		return switch (node) {
			case Some(n):
				n;
			case None:
				this.num();
		}
	}

	private function num():Node {
		return switch (this.tokens[this.index]) {
			case Token.Num(value):
				this.index++;
				Num(value);
			case _:
				return Err(this.index, '知らないトークン');
		}
	}
}
