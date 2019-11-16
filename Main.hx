import Tokenizer;
import Parser;
import Calculator;
import js.Browser;
import js.html.TextAreaElement;


class Main {
	public static function main() {
		Browser.window.onload = onload;
	};

	private static function onload() {
		Browser.document.getElementById('button').onclick = calc;
	}

	private static function calc():Int {
		var formulaDom = cast(Browser.document.getElementById('formula'), TextAreaElement);
        var ansDom = Browser.document.getElementById('ans');
        var code = formulaDom.value;
		var tokenizer = new Tokenizer(code);
		var tokens = tokenizer.tokenize();
		var parser = new Parser(tokens);
		var node = parser.parse();
		var calculator = new Calculator();
		var ans = calculator.calculate(node);
        ansDom.innerText = Std.string(ans);
		return ans;
	}
}
