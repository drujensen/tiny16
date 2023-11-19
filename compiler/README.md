# Tiny16 assembly compiler

Simple Assembly to executable for the tiny16 computer

## Installation

Install Crystal 1.0
```
brew install crystal
```

Build the tiny16 assembly compiler
```
shards build
```

## Usage

Write your assembly file.  This will use the 16 opcodes made available by the tiny16 computer.  You can find examples in the `/examples` folder.

Then compile the application:
```
bin/t16as ./examples/multiply.s
```

This will generate an a.out binary file.

## Development

This is a minimalistic solution.  There is no error checking and the assembly code is laid out to match memory one-to-one.

## Contributing

1. Fork it (<https://github.com/drujensen/tiny16-compiler/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dru Jensen](https://github.com/drujensen) - creator and maintainer
