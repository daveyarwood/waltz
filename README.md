# waltz

A portable music theory library written in Forth.

## Background

_TODO_

## Why Forth?

- It's easy to learn Forth and dead simple to understand a Forth program.

- It's really easy to implement a Forth interpreter in practically any language.

- The syntax of Forth makes for very readable code, even if you're not familiar with Forth. Example Waltz code:

  ```
  120 bpm whole 1 dot beats ms
  ```

  > Given the tempo 120 bpm;
  >
  > And a whole note with one dot;
  >
  > Get the number of beats of the note;
  >
  > Then get the duration in milliseconds of that number of beats.

## Development

### Running Tests

```
rspec test
```

## License

Copyright © 2016 Dave Yarwood

Distributed under the Eclipse Public License version 1.0.
