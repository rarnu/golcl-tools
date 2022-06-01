package parser

import (
	f0 "github.com/isyscore/isc-gobase/file"
	. "github.com/isyscore/isc-gobase/isc"
)

func ParseFile(filePath string) (ISCList[Property], ISCList[Method]) {
	list := ListToMapFrom[string, ISCString](f0.ReadFileLines(filePath)).Map(func(item string) ISCString {
		return ISCString(item).TrimSpace()
	}).Filter(func(item ISCString) bool {
		return !item.IsEmpty()
	})
	p := list.Filter(func(item ISCString) bool {
		return item.StartsWith("property")
	})
	m := list.Filter(func(item ISCString) bool {
		return item.StartsWith("procedure") || item.StartsWith("function") || item.StartsWith("constructor") || item.StartsWith("destructor")
	})
	retp := ListToMapFrom[ISCString, Property](p).Map(func(item ISCString) Property {
		return ParseProperty(item)
	})
	retm := ListToMapFrom[ISCString, Method](m).Map(func(item ISCString) Method {
		return ParseMethod(item)
	})
	return retp, retm
}
