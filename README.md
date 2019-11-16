# calculator

Haxe入門。

usage:

```sh
$ haxe compile.hxml
$ python -m http.server
$ google-chrome localhost:8000/main.html
```

func_name(arg) = expsession;
...

- 最初にmainが計算される。
- 引数は０個か１個取れる。

example:

```
main() = 9 + aaa() + bbb(11);
aaa() = 10;
bbb(x) = x + 10;
```

\>\> 40
