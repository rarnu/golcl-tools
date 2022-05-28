package tool

import (
	f0 "github.com/isyscore/isc-gobase/file"
	"os/exec"
	"path/filepath"
)

func CreateBundle(dir string, app string, isChrome bool, isArm64 bool) {
	base := filepath.Join(dir, app+".app")
	_ = f0.MkDirs(base)
	contents := filepath.Join(base, "Contents")
	_ = f0.MkDirs(contents)
	macOS := filepath.Join(contents, "MacOS")
	_ = f0.MkDirs(macOS)
	res := filepath.Join(contents, "Resources")
	_ = f0.MkDirs(res)
	// PkgInfo
	filePkgInfo := filepath.Join(contents, "PkgInfo")
	_ = f0.WriteFile(filePkgInfo, "APPL????")
	// copy executable
	execFile := filepath.Join(macOS, app)
	_ = f0.CopyFile(filepath.Join(dir, app), execFile)
	_ = exec.Command("chmod", "+x", execFile).Run()
	// info.plist
	filePlist := filepath.Join(contents, "Info.plist")
	CreatePlist(filePlist, app, isChrome)

	if isChrome {
		framework := filepath.Join(contents, "Frameworks")
		_ = f0.MkDirs(framework)

		CreateHelper(framework, app, "", isArm64)
		CreateHelper(framework, app, "GPU", isArm64)
		CreateHelper(framework, app, "Plugin", isArm64)
		CreateHelper(framework, app, "Renderer",isArm64)
	}
}

