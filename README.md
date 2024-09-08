# Generators library for [Refal-5λ](https://github.com/bmstu-iu9/refal-5-lambda)

> [Русская версия](./README.ru.md)

## Installation

Just copy the `Generators.ref` file to your project or include part of it directly in your code.

## Usage

Generator is any function that accepts a context and returns an updated context and a value or `Gen-Stop` if the generator is exhausted.

To initialize a generator it should be called with an empty context.

For example, lets define Fibonacci numbers generator (assume macrodigits for simplicity):
```refal
Fib {
  () = (1 1) 1;
  (13 21) = Gen-Stop;
  (s.PP s.P) = <Add s.PP s.P> : s.Next = (s.P s.Next) s.Next;
}
```

Some functions accept predicates as arguments. Predicate functions accept single object expression and should return either `True` or `False`.

For example:
```refal
IsEven {
  e.Val = <Mod (e.Val) 2> : { 0 = True; e._ = False; }
}
```

Most of the functions return a new generator so you can chain them together. When all operations are done you can use `Gen-Iter` to iterate over the generator and get the object expression.

```refal
*$FROM Generators.ref
$EXTERN Gen-Iter, Gen-Range, Gen-Filter, Gen-TakeWhile, Gen-Filter, Gen-DropWhile, Gen-Chain, Gen-Map, Gen-Reduce;

$ENTRY Go {
    = <Gen-Iter <Gen-Range 0 10 2>> : (0 )(2 )(4 )(6 )(8 )
    = <Gen-Iter <Gen-TakeWhile <LessThan 5> <Gen-Range 0 10>>> : (0 )(1 )(2 )(3 )(4 )
    = <Gen-Iter <Gen-Filter &IsEven <Gen-Range 0 10>>> : (0 )(2 )(4 )(6 )(8 )
    = <Gen-Iter <Gen-Chain <Gen-Range 0 2> <Gen-Range 2 3> <Gen-Range 3 5>>> : (0 )(1 )(2 )(3 )(4 )
    = <Gen-Iter <Gen-Map { e.Val = <Mul 3 e.Val> } <Gen-Range 0 5>>> : (0 )(3 )(6 )(9 )(12 )
    = <Gen-Reduce &Add 0 <Gen-Range 0 5>> : 10
    = Done
}
```

For more examples see [tests](./tests/) and documentation in the [Generators.ref](./Generators.ref) file.


## Roadmap

- [x] Iter
- [x] Range
- [x] TakeWhile
- [x] DropWhile
- [x] Filter
- [x] Chain
- [x] Map
- [x] Reduce
- [ ] MapAccum
- [ ] Batched
