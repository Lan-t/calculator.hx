# calculator

Haxe入門。

usage:

```sh
$ haxe compile.hxml
$ python -m http.server
$ google-chrome https://localhost:8000/main.html
```

func_name(arg) = expsession;
...

- 最初にmainが計算される。
- 引数は０個か１個取れる。
- if (条件) 真値 : 偽値

example:

```
main() = 9 + aaa() + bbb(11);
aaa() = 10;
bbb(x) = x + 10;
```

\>\> 40

```
factorial(x) = if (x) factorial(x-1)*x : 1;

main() = factorial(10);
```

\>\> 3628800
