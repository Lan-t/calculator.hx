using buddy.Should;

typedef TestCode = {code: String, ret: Int};

class Test extends buddy.SingleSuite {
	public function new() {
		describe('test.', {
            var tests:Array<TestCode> = [
                {code: 'main() = 10 + 19;', ret: 29},
                {code: 'main() = 10 - 5;', ret: 5},
                {code: 'main() = 10 * 10;', ret: 100},
                {code: 'main() = 10 / 10;', ret: 1}, 
                {code: 'main() = 10 / 3;', ret: 3},
                {code: 'main() = 10 % 3;', ret: 1},
                {code: 'main() = a(); a() = 3;', ret: 3},
                {code: 'main() = b(3); b(c) = c * 3;', ret: 9},
                {code: 'main() = if (1) 10 : 20;', ret: 10},
                {code: 'main() = if (0) 10 : 20;', ret: 20},
                {code: 'main() = f(4); f(x) = if (x) f(x-1) * x : 1;', ret: 24}
            ];

            for (test in tests) {
                it(test.code, {
                    calc(test.code).should.be(test.ret);
                });
            }
		});
	}

    private static function calc(code: String) {
		var tokenizer = new Tokenizer(code);
		var tokens = tokenizer.tokenize();
		var parser = new Parser(tokens);
		var node = parser.parse();
		var calculator = new Calculator();
		var ans = calculator.calculate(node);
		return ans;
    }
}
