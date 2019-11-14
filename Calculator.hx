import Parser;
import js.Error;

class Calculator {
    static public function calculate(node): Int {
        return switch (node) {
            case Num(value):
                value;
            case BinaryOperator(token, lhs, rhs):
                if (token == '+') return calculate(lhs) + calculate(rhs)
                else if (token == '-') return calculate(lhs) - calculate(rhs)
                else if (token == '/') return Std.int(calculate(lhs) / calculate(rhs))
                else if (token == '*') return Std.int(calculate(lhs) * calculate(rhs))
                else throw new Error(token);
            case _:
                throw new Error("未実装");
                0;
        }
    }
}