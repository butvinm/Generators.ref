# Generators library for [Refal-5λ](https://github.com/bmstu-iu9/refal-5-lambda)

> [Русская версия](./README.md)

## Features

### Generator interface

Generator is any function that takes context and returns an updatable context and a value.

```refal
BoundedFib {
  () = (1 1) 1;
  (8 13) = Gen-Stop;
  (s.PP s.P)
    = <Add s.PP s.P> : s.Next
    = (s.P s.Next) s.Next;
}
```

### Functions

`Gen-Iter`

Expands generator to an object expression.

```refal
= <Gen-Iter &Fib> : 1 1 2 3 5 8 13
= <Gen-Iter &Fib (3 5)> : 8 13
```


`Gen-Range`

Python-like range generator. Yields integers from s.Start to s.Stop with step s.Step.


```refal
* Call without arguments will generate infinite sequence of integers starting from 0
= <Gen-Iter &Gen-Range> : (0 )(1 )(2 )(3 )(4 )(5 )(6 )(7 )(8 )(9 )...

* Call with start and stop values (macrodigits)
= <Gen-Iter &Gen-Range (3 10)>> : (3 )(4 )(5 )(6 )(7 )(8 )(9 )

* Call with start, stop and step values. Start and stop is macrodigits, step is a number
= <Gen-Iter &Gen-Range (3 10 2)>> : (3 )(5 )(7 )(9 )

* Call with start, stop and step values. All values are numbers
= <Gen-Iter &Gen-Range ((3 0) (10 0) 2)>> : (3 0 )(3 2 )(3 4 )(3 6 )(3 8 )
```

`Gen-TakeWhile`

Yields while values satisfy predicate.

```refal
= <Gen-Iter
    <Gen-TakeWhile
      { e.Val = <Compare 5 e.Val> : { '+' = True; e._ = False } }
      &Gen-Range (1 10)
    >
  > : ((0 )(1 )(2 )(3 )(4 )
```


## Roadmap

- [x] Iter
- [x] Range
- [x] TakeWhile
- [ ] DropWhile
- [ ] Filter
- [ ] Map
- [ ] Reduce
- [ ] MapAccum
