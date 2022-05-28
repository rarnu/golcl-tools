package tool

import (
	f0 "github.com/isyscore/isc-gobase/file"
	. "github.com/isyscore/isc-gobase/isc"
	"mactool/embed"
	"os/exec"
	"path/filepath"
)

func CreateHelper(basePath string, name string, subname string, isArm64 bool) {
	appName := name + " Helper"
	if subname != "" {
		appName += " (" + subname + ")"
	}
	appPath := filepath.Join(basePath, appName+".app")
	content := filepath.Join(appPath, "Contents")
	_ = f0.MkDirs(content)
	// resources
	_ = f0.MkDirs(filepath.Join(content, "Resources"))
	macOS := filepath.Join(content, "MacOS")
	_ = f0.MkDirs(macOS)
	// executable
	execFile := filepath.Join(macOS, appName)
	_ = f0.WriteFileBytes(execFile, IfThen(isArm64, embed.AppHelperA64, embed.AppHelperX64))
	_ = exec.Command("chmod", "+x", execFile).Run()
	// pkginfo
	_ = f0.WriteFile(filepath.Join(content, "PkgInfo"), "APPL????")

	str := ISCString(embed.PlistHelperFormat)
	str = str.ReplaceAll("{{appname}}", appName)
	// plist
	_ = f0.WriteFile(filepath.Join(content, "Info.plist"), string(str))
}
