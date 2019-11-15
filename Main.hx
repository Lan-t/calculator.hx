import Tokenizer;
import Parser;
import Calculator;
import js.Browser;
import js.html.InputElement;


class Main {
	public static function main() {
		Browser.window.onload = onload;
	};

	private static function onload() {
		Browser.document.getElementById('button').onclick = calc;
	}

	private static function calc():Int {
		var formulaDom = cast(Browser.document.getElementById('formula'), InputElement);
        var ansDom = Browser.document.getElementById('ans');
        var code = formulaDom.value;
		var tokenizer = new Tokenizer(code);
		var tokens = tokenizer.tokenize();
		var parser = new Parser(tokens);
		var node = parser.parse();
		var ans = Calculator.calculate(node);
        ansDom.innerText = Std.string(ans);
		return ans;
	}
}
