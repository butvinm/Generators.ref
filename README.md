# Generators library for [Refal-5λ](https://github.com/bmstu-iu9/refal-5-lambda)

This library provides a set of utilities for generating sequences of values in Refal-5λ, enabling lazy iteration, filtering, generation and transformation of data.

## Installation

Just copy the Generators.ref file to your project, or if you prefer, include only the functions you need directly in your code.

## Concepts overview

Generator is any function that accepts a context (an internal state or input data) and returns an updated context along with a value or Gen-Stop if the generator is exhausted.

To initialize a generator it should be called with an empty context.

For example, lets define Fibonacci numbers generator (assume macrodigits for simplicity):
```refal
Fib {
  () = (0 1) 1;
  (8 13) = Gen-Stop;
  (s.PP s.P)
    = <Add s.PP s.P> : s.Next
    = (s.P s.Next) s.Next;
}
```

Some functions accept predicates as arguments. Predicate functions accept single object expression and should return either `True` or `False`.

For example:
```refal
IsEven {
  e.Val, <Mod (e.Val) 2> : 0 = True;
  e._ = False;
}
```

Most of the functions return a new generator so you can chain them together. When all operations are done you can use `Gen-Iter` to iterate over the generator and get the list of values.

## Functions

- [x] `Gen-Iter`: Iterate over the generator and return the list of values wrapped in brackets.
- [x] `Gen-FlatIter`: Iterate over the generator and return the list of values without brackets.
- [x] `Gen-Range`: Generate a range of numbers, like range in Python.
- [x] `Gen-TakeWhile`: Take values from the generator while the predicate is true.
- [x] `Gen-DropWhile`: Drop values from the generator while the predicate is true.
- [x] `Gen-Filter`: Filter values from the generator using the predicate.
- [x] `Gen-Chain`: Chain multiple generators together - as one is exhausted, the next one is used.
- [x] `Gen-Map`: Apply a function to each value of the generator.
- [x] `Gen-Reduce`: Reduce the generator to a single value using the function.
- [x] `Gen-Pipe`: Pipe multiple generators together - each pipe is a function that takes yielded value of previous generator and returns a new generator that yields the next value. Like nested loops.
- [x] `Gen-Take`: Take a specified number of values from the generator.
- [x] `Gen-FromList`: Create a generator from a list of values.
- [x] `Gen-ChopHead`: Returns the first value and the generator without it.
- [x] `Gen-Zip`: Zip multiple generators into a single generator that yields tuples of combined values.
- [ ] `Gen-MapAccum`: Like reduce but also returns a list of intermediate values.
- [ ] `Gen-Batched`: Split the generator into batches of a specified size.

## Usage

```refal
Fib {
  () = (0 1) 1;
  (8 13) = Gen-Stop;
  (s.PP s.P)
    = <Add s.PP s.P> : s.Next
    = (s.P s.Next) s.Next;
}

LessThan {
  e.Bound
    = {
      e.Val = <Compare (e.Bound) e.Val> : { '+' = True; e._ = False; }
    }
}

$ENTRY Go {
  = <Gen-Iter &Fib>
  : (1) (1) (2) (3) (5) (8) (13)

  = <Gen-Iter &Fib (3 5)>
  : (8) (13)

  = <Gen-FlatIter &Fib>
  : 1 1 2 3 5 8 13

  = <Gen-FlatIter <Gen-Range 0 10>>
  : 0 1 2 3 4 5 6 7 8 9

  = <Gen-FlatIter <Gen-Take 13 <Gen-Range>>>
  : 0 1 2 3 4 5 6 7 8 9 10 11 12

  = <Gen-FlatIter <Gen-Range (5) (0) '-' 1>>
  : 5 4 3 2 1

  = <Gen-FlatIter
    <Gen-TakeWhile <LessThan 5> <Gen-Range>>
  >
  : 0 1 2 3 4

  = <Gen-FlatIter
    <Gen-Map &Inc <Gen-Range 0 5>>
  >
  : 1 2 3 4 5 6

  = <Gen-Reduce &Add 0 <Gen-Range 0 5>>
  : 10

  = <Gen-FlatIter
    <Gen-DropWhile <LessThan 5> <Gen-Range>>
  >
  : 5 6 7 8 9

  = <Gen-FlatIter
    <Gen-Filter
      <LessThan 5>
      <Gen-FromList (0) (34) (2) (1) (5) (3) (8) (13) (21) (55) (89)>
    >
  >
  : 0 2 1 3

  = <Gen-FlatIter
    <Gen-Chain
      <Gen-Range 0 3>
      <Gen-Range 5 8>
      <Gen-Range 10 13>
    >
  >
  : 0 1 2 5 6 7 10 11 12

/* Equivalent to:
  for a in range(1, 3):
    for b in range(a + 1, 4):
      for c in range(b + 1, 5):
        print(a, b, c)
*/
  = <Gen-Iter
    <Fetch
      <Gen-Pipe
        { = <Gen-Range 1 3> }
        { t.A = <Gen-Map { t.B = t.A t.B} <Gen-Range <Inc t.A> 4>> }
        { t.A t.B = <Gen-Map { t.C = t.A t.B t.C} <Gen-Range <Inc t.B> 5>> }
      >
    >
  >
  : (1 2 3) (1 2 4) (1 3 4) (2 3 4)

  = <{ t.H t.T = Head t.H Tail <Gen-FlatIter t.T> }
    <Gen-ChopHead <Gen-Range 0 5>>
  >
  : Head 1 Tail 2 3 4 5

  = <Gen-Iter
    <Gen-Zip
      <Gen-Range 0 5>
      <Gen-Range 5 10>
    >
  >
  : ((0) (5)) ((1) (6)) ((2) (7)) ((3) (8)) ((4) (9))

  = <Prout Success>;
}
```

For more examples see [tests](./tests/Test.ref) and library [source code](./Generators.ref).
