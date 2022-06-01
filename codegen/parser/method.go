package parser

import (
	. "github.com/isyscore/isc-gobase/isc"
)

type Parameter struct {
	Name  string
	Type  string
	IsVar bool
}

type Method struct {
	MethodType string
	HasReturn  bool
	Name       string
	ReturnType string
	Params     ISCList[Parameter]
}

func ParseParams(str ISCString) []Parameter {
	return ListToMapFrom[ISCString, Parameter](str.Split(";")).Map(func(item ISCString) Parameter {
		s := item.TrimSpace()
		isVar := false
		if s.StartsWith("const") {
			s = s.SubStringAfter("const ").TrimSpace()
		}
		if s.StartsWith("out ") {
			isVar = true
			s = s.SubStringAfter("out ").TrimSpace()
		}
		if s.StartsWith("var ") {
			isVar = true
			s = s.SubStringAfter("var ").TrimSpace()
		}
		n := ISCString("")
		t := ISCString("")
		if s.Contains(":") {
			// 有类型参数
			n = s.SubStringBefore(":").TrimSpace()
			t = s.SubStringAfter(":").TrimSpace()
		} else {
			// 无类型参数
			n = s.TrimSpace()
			t = s.TrimSpace()
		}
		return Parameter{
			Name:  string(n),
			Type:  string(t),
			IsVar: isVar,
		}
	})
}

func ParseMethod(item ISCString) Method {
	item = item.ReplaceAll("override;", "").ReplaceAll("abstract;", "").ReplaceAll("virtual;", "").ReplaceAll("overload;", "")
	mt := item.SubStringBefore(" ").TrimSpace()
	s := item.SubStringAfter(" ").TrimSpace()
	n := ISCString("")
	var pa []Parameter
	if s.Contains("(") {
		n = s.SubStringBefore("(").TrimSpace()
		s = s.SubStringAfter("(").TrimSpace()
		params := s.SubStringBefore(")").TrimSpace()
		pa = ParseParams(params)
		s = s.SubStringAfter(")").TrimSpace()
	} else {
		if s.Contains(":") {
			n = s.SubStringBefore(":").TrimSpace()
		} else {
			n = s.SubStringBefore(";").TrimSpace()
		}
	}
	hasRet := s.Contains(":")
	rt := ISCString("")
	if hasRet {
		rt = s.SubStringAfter(":").SubStringBefore(";").TrimSpace()
	}
	if n.EndsWith(";") {
		n = n.DropLast(1)
	}
	return Method{
		MethodType: string(mt.ToLower()),
		HasReturn:  hasRet,
		Name:       string(n),
		ReturnType: string(rt),
		Params:     pa,
	}
}
