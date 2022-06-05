[![GitHub release](https://img.shields.io/github/release/aarongodin/jsonpointer.svg)](https://github.com/aarongodin/jsonpointer/releases)
[![CI](https://github.com/aarongodin/jsonpointer/actions/workflows/crystal.yml/badge.svg)](https://github.com/aarongodin/jsonpointer/actions/workflows/crystal.yml)
![GitHub](https://img.shields.io/github/license/aarongodin/jsonpointer?style=plastic)

# jsonpointer

Parsing and resolution of JSON Pointer strings in Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     jsonpointer:
       github: aarongodin/jsonpointer
   ```

2. Run `shards install`

## Usage

Create new pointer instances by calling the `#from` method using a source string for the pointer:

```crystal
require "jsonpointer"

input = JSON.parse(
  <<-JSON
  {
    "root": {
      "child": [
        { "name": "first" },
        { "name": "second" },
        { "name": "third" },
      ]
    }
  }
  JSON
)

pointer = JSONPointer.from("/root/child/2/name")
pointer.get?(input) # => "third"
```

The accessor returned from `JSONPointer#from` has both `#get` and `#get?` methods. The `#get` raises an error when a value is not found in the input JSON, while `#get?` returns `nil`.

You can retrieve the original source string using `#source`:

```crystal
require "jsonpointer"

pointer = JSONPointer.from("/root/child")
pointer.source # => "/root/child"
```

## Contributing

1. Fork it (<https://github.com/aarongodin/jsonpointer/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### References

* [node-jsonpointer](https://github.com/janl/node-jsonpointer#readme) - used as a reference and test suite for this shard
* [RFC 6901](https://datatracker.ietf.org/doc/html/rfc6901)