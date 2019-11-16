import Parser;
import js.Error;
import haxe.ds.StringMap;
import haxe.ds.Option;


typedef FuncContext = {v:Option<String>, exp:Node};

class Calculator {
	var funcs:StringMap<FuncContext>;
	var vars:StringMap<Int>;

	public function new() {
		this.funcs = new StringMap<FuncContext>();
		this.vars = new StringMap<Int>();
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
				else this.call(main, None);
			case Func(name, v, exp):
				this.funcs.set(name, {v:v, exp:exp});
				0;
			case If(cond, lhs, rhs):
				var c = this.calculate(cond);
				if (c != 0) this.calculate(lhs);
				else this.calculate(rhs);
			case Num(value):
				value;
			case Var(name):
				var v = this.vars.get(name);
				if (v == null) {trace(this.vars);throw new Error('unknown variable');}
				else v;
			case Call(name, v):
				var f = this.funcs.get(name);
				if (f == null) throw new Error('unknown function');
				else this.call(f, v);
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
                throw new Error('Err at $i, $m');
			case _:
				throw new Error('未実装');
		}
	}

	private function call(func_context:FuncContext, arg:Option<Node>):Int {
		var ret:Int;
		switch (func_context.v) {
			case None:
				ret = this.calculate(func_context.exp);
			case Some(v):
				var tmp = this.vars.get(v);
				this.vars.set(v, switch (arg) {
					case None:
						throw new Error('no arg');
					case Some(a):
						this.calculate(a);
				});
				ret = this.calculate(func_context.exp);
				if (tmp == null) this.vars.remove(v);
				else this.vars.set(v, tmp);
		}
		return ret;
	}
}
