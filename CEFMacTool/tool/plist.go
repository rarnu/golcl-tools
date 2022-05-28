package tool

import (
	f0 "github.com/isyscore/isc-gobase/file"
	. "github.com/isyscore/isc-gobase/isc"
	"mactool/embed"
)

func CreatePlist(filePath string, app string, isChrome bool) {
	str := ISCString(embed.PlistFormat)
	if isChrome {
		str = str.ReplaceAll("{{NSPrincipalClass}}", "\t<key>NSPrincipalClass</key>\n\t<string>TCrCocoaApplication</string>")
	} else {
		str = str.ReplaceAll("{{NSPrincipalClass}}", "")
	}
	str = str.ReplaceAll("{{appname}}", app)
	f0.WriteFile(filePath, string(str))
}