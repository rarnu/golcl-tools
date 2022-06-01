package main

import (
	"gen/parser"
	f0 "github.com/isyscore/isc-gobase/file"
	. "github.com/isyscore/isc-gobase/isc"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		os.Exit(1)
	}
	filePath := os.Args[1]
	if !f0.FileExists(filePath) {
		os.Exit(1)
	}
	props, mthds := parser.ParseFile(filePath)
	name := ISCString(f0.ExtractFileName(filePath)).SubStringBeforeLast(".")
	parser.GenFpcCode(props, mthds, name)
	parser.GenGoApiCode(props, mthds, name)
}
