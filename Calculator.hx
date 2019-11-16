import Parser;
import js.Error;
import haxe.ds.StringMap;

class Calculator {
	var funcs:StringMap<Node>;

	public function new() {
		this.funcs = new StringMap<Node>();
	}

	public function calculate(node):Int {
		return switch (node) {
			case Definition(funcs):
				for (i in 0...funcs.length) {
					if (funcs[i] == null) {}
					else this.calculate(funcs[i]);
				}
				var main = this.funcs.get('main');
				if (main == null) 0
				else this.calculate(main);
			case Func(name, v, exp):
				this.funcs.set(name, exp);
				0;
			case Num(value):
				value;
			case BinaryOperator(token, lhs, rhs) if (token == '+'):
				calculate(lhs) + calculate(rhs);
			case BinaryOperator(token, lhs, rhs) if (token == '-'):
				calculate(lhs) - calculate(rhs);
			case BinaryOperator(token, lhs, rhs) if (token == '/'):
				Std.int(calculate(lhs) / calculate(rhs));
			case BinaryOperator(token, lhs, rhs) if (token == '*'):
				Std.int(calculate(lhs) * calculate(rhs));
            case BinaryOperator(token, lhs, rhs) if (token == '%'):
                calculate(lhs) % calculate(rhs);
            case Err(i, m):
                throw new Error('Err.');
			case _:
				throw new Error('未実装');
		}
	}
}
