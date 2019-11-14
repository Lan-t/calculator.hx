import Tokenizer;
import js.Error;

enum Node {
	Num(value:Int);
	UnaryOperator(Token:String, hs:Node);
	BinaryOperator(Token:String, lhs:Node, rhs:Node);
	EoF;
	Err;
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
				case Token.Operator(token):
					if (token == '+') {
						this.index++;
						node = BinaryOperator('+', node, this.mul());
					} else if (token == '-') {
                        this.index ++;
						node = BinaryOperator('-', node, this.mul());
                    }
					else
						break;
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
				case Token.Operator(token):
					if (token == '*') {
						this.index++;
						node = BinaryOperator('*', node, this.cons());
					} else if (token == '/') {
                        this.index ++;
						node = BinaryOperator('/', node, this.cons());
                    }
					else
						break;
				case _:
					break;
			}
		}

		return node;
	}

	private function cons():Node {
		var node: Null<Node> = null;

		while (true) {
			switch (this.tokens[this.index]) {
				case Token.Operator(token):
					if (token == '(') {
						this.index ++;
						node = this.expression();
						if (!Type.enumEq(this.tokens[this.index], Operator(')'))) {
							throw new Error(")がない");
						}
						this.index ++;
					}
					else
						break;
				case _:
					break;
			}
		}

		return if (node == null) this.num() else node;
	}

	private function num():Node {
		return switch (this.tokens[this.index]) {
			case Token.Num(value):
				this.index++;
				Num(value);
			case _:
                trace(this.tokens[this.index]);
				throw new Error("しらない");
				return Err;
		}
	}
}
