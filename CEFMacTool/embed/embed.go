package embed

import _ "embed"

//go:embed InfoPlist
var PlistFormat string

//go:embed InfoPlist_Helper
var PlistHelperFormat string

//go:embed AppHelper_x64
var AppHelperX64 []byte

//go:embed AppHelper_a64
var AppHelperA64 []byte
