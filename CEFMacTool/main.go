package main

import (
	f0 "github.com/isyscore/isc-gobase/file"
	"mactool/tool"
	"os"
)

func main() {
	if len(os.Args) != 2 && len(os.Args) != 3 {
		os.Exit(1)
	}
	isChrome := false
	if len(os.Args) == 3 {
		isChrome = os.Args[2] == "--chrome"
	}
	filePath := os.Args[1]
	if !f0.FileExists(filePath) {
		os.Exit(1)
	}
	dir := f0.ExtractFilePath(filePath)
	name := f0.ExtractFileName(filePath)
	isArm64 := tool.FileIsArm64(filePath)
	tool.CreateBundle(dir, name, isChrome, isArm64)
}

