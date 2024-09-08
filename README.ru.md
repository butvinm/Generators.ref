# Библиотека для работы с генераторами в [Refal-5λ](https://github.com/bmstu-iu9/refal-5-lambda)

> [English version](./README.md)

## Установка

Просто скопируйте файл `Generators.ref` в ваш проект или скопируйте нужные функции прямо в свой код.

## Использование

Генератор — это любая функция, которая принимает контекст и возвращает обновлённый контекст и значение, или `Gen-Stop`, если генератор исчерпан.

Чтобы инициализировать генератор, его нужно вызвать с пустым контекстом.

Например, давайте определим генератор чисел Фибоначчи (для простоты определим только для макроцифр):
```refal
Fib {
  () = (1 1) 1;
  (13 21) = Gen-Stop;
  (s.PP s.P) = <Add s.PP s.P> : s.Next = (s.P s.Next) s.Next;
}
```

Некоторые функции принимают предикаты в качестве аргументов. Предикатные функции принимают единственное объектное выражение и должны возвращать либо `True`, либо `False`.

Например:
```refal
IsEven {
  e.Val = <Mod (e.Val) 2> : { 0 = True; e._ = False; }
}
```

Большинство функций возвращают новый генератор, так что их можно связывать в цепочку. Когда все операции завершены, можно использовать `Gen-Iter` для итерации по генератору и получения финального объектного выражения.

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

Больше примеров можно найти в [тестах](./tests/) и документации в файле [Generators.ref](./Generators.ref).


## Дорожная карта

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
