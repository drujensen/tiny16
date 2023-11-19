default: build

clean:
	rm -f bin/t16as program.hex

build:
	shards build

run:
	./bin/t16as examples/up_and_down.s

install:
	cp bin/t16as /usr/local/bin/
