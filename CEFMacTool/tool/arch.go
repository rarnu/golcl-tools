package tool

import (
	"bytes"
	. "github.com/isyscore/isc-gobase/isc"
	"os/exec"
)

func FileIsArm64(filePath string) bool {
	cmd := exec.Command("file", filePath)
	var buf bytes.Buffer
	cmd.Stdout = &buf
	_ = cmd.Run()
	out := ISCString(buf.Bytes()).ToLower()
	return out.Contains("arm64") || out.Contains("aarch64")
}