package parser

import (
	"fmt"
	f0 "github.com/isyscore/isc-gobase/file"
	. "github.com/isyscore/isc-gobase/isc"
	"os"
	"path/filepath"
)

func GenFpcCode(p ISCList[Property], m ISCList[Method], prefix ISCString) {

	str := ""
	// create
	str += fmt.Sprintf("function %s_Create(AOwner: TCustomChart): T%s; extdecl;\nbegin\n  handleExceptionBegin\n", prefix, prefix)
	str += fmt.Sprintf("  Result :=  T%s.Create(AOwner);\n", prefix)
	str += "  handleExceptionEnd\nend;\n\n"
	str += fmt.Sprintf("procedure %s_Free(AObj: T%s); extdecl;\nbegin\n  handleExceptionBegin\n  AObj.Free;\n  handleExceptionEnd\nend;\n\n", prefix, prefix)
	str += fmt.Sprintf("function %s_StaticClassType: TClass; extdecl;\nbegin\n  Result := T%s;\nend;\n\n", prefix, prefix)

	export := ""
	// create
	export += fmt.Sprintf("  %s_Create,\n  %s_Free,\n  %s_StaticClassType,\n", prefix, prefix, prefix)

	eventList := ""
	p.ForEach(func(item Property) {
		if item.IsEvent {
			str += fmt.Sprintf("//EVENT_TYPE:%s\n", item.Type)
			str += fmt.Sprintf("procedure %s_Set%s(AObj: T%s; AEventId: NativeUInt); extdecl;\nbegin\n", prefix, item.Name, prefix)
			str += fmt.Sprintf("  {$DEFINE EventMethodName := On%s_%s}\n", item.Type, item.Name)
			str += fmt.Sprintf("  {$DEFINE EventName := %s}\n", item.Name)
			str += fmt.Sprintf("  EventMethodCode\nend;\n\n")
			export += fmt.Sprintf("  %s_Set%s,\n", prefix, item.Name)
			eventList += fmt.Sprintf("On%s_%s\n", item.Type, item.Name)
		} else {
			if item.HasGet {
				str += fmt.Sprintf("function %s_Get%s(AObj: T%s): %s; extdecl;\nbegin\n  handleExceptionBegin\n  Result := AObj.%s;\n  handleExceptionEnd\nend;\n\n",
					prefix, item.Name, prefix, item.Type, item.Name)
				export += fmt.Sprintf("  %s_Get%s,\n", prefix, item.Name)
			}
			if item.HasSet {
				str += fmt.Sprintf("procedure %s_Set%s(AObj: T%s; AValue: %s); extdecl;\nbegin\n  handleExceptionBegin\n  AObj.%s := AValue;\n  handleExceptionEnd\nend;\n\n",
					prefix, item.Name, prefix, item.Type, item.Name)
				export += fmt.Sprintf("  %s_Set%s,\n", prefix, item.Name)
			}
		}
	})

	m.ForEach(func(item Method) {
		params := item.Params.JoinToStringFull(";", "", "", func(it Parameter) string {
			s := ""
			if it.IsVar {
				s += "var "
			}
			s += it.Name + ": " + it.Type
			return s
		})
		callParam := item.Params.JoinToStringFull(",", "", "", func(it Parameter) string {
			return it.Name
		})
		if params != "" {
			params = "; " + params
		}

		if item.MethodType == "procedure" {
			str += fmt.Sprintf("procedure %s_%s(AObj: T%s%s); extdecl;\nbegin\n", prefix, item.Name, prefix, params)
			str += "  handleExceptionBegin\n"
			str += fmt.Sprintf("  AObj.%s(%s);\n", item.Name, callParam)
			str += "  handleExceptionEnd\nend;\n\n"
			export += fmt.Sprintf("  %s_%s,\n", prefix, item.Name)
		}
		if item.MethodType == "function" {
			str += fmt.Sprintf("function %s_%s(AObj: T%s%s): %s; extdecl;\nbegin\n", prefix, item.Name, prefix, params, item.ReturnType)
			str += "  handleExceptionBegin\n"
			str += fmt.Sprintf("  Result := AObj.%s(%s);\n", item.Name, callParam)
			str += "  handleExceptionEnd\nend;\n\n"
			export += fmt.Sprintf("  %s_%s,\n", prefix, item.Name)
		}
	})

	dir, _ := os.Getwd()
	outFilePath := filepath.Join(dir, string(prefix+".out.inc"))
	_ = f0.WriteFile(outFilePath, str+"\nexports\n"+export+"\n\n"+eventList)
}

var keepType = ISCList[string]{
	"TPoint", "HDC", "TClass", "TAnchorKind", "TAlign", "TLayoutAdjustmentPolicy", "HWND",
	"TTabOrder", "TAnchors", "TBiDiMode", "TRect", "TControlState", "TControlStyle", "TCursor",
	"TColor",
}

func dtypeToGoType(t string) (string, string, bool) {
	if t == "Boolean" {
		return t, "bool", true
	}
	if t == "Integer" {
		return t, "int32", true
	}
	if t == "Int64" {
		return t, "int64", true
	}
	if t == "Double" {
		return t, "float64", true
	}
	if t == "Float" {
		return t, "float32", true
	}

	if keepType.Contains(t) {
		return t, t, false
	}

	return t, "uintptr", true
}

func GenGoApiCode(p ISCList[Property], m ISCList[Method], prefix ISCString) {
	str := ""
	// create
	str += fmt.Sprintf("func %s_Create(obj uintptr) uintptr {\n    ret, _, _ := getLazyProc(\"%s_Create\").Call(obj)\n    return ret\n}\n\n", prefix, prefix)
	str += fmt.Sprintf("func %s_Free(obj uintptr) {\n    _, _, _ = getLazyProc(\"%s_Free\").Call(obj)\n}\n\n", prefix, prefix)
	str += fmt.Sprintf("func %s_StaticClassType() TClass {\n    ret, _, _ := getLazyProc(\"%s_StaticClassType\").Call()\n    return TClass(ret)\n}\n\n", prefix, prefix)

	p.ForEach(func(item Property) {
		if item.IsEvent {
			str += fmt.Sprintf("func %s_Set%s(obj uintptr, fn any) {\n    _, _, _ = getLazyProc(\"%s_Set%s\").Call(obj, addEventToMap(obj, fn))\n}\n\n",
				prefix, item.Name, prefix, item.Name)
		} else {
			oldTyp, newTyp, conv := dtypeToGoType(item.Type)
			if item.HasSet {
				str += fmt.Sprintf("func %s_Get%s(obj uintptr) %s {\n    ret, _, _ := getLazyProc(\"%s_Get%s\").Call(obj)\n    return %s\n}\n\n",
					prefix, item.Name /*item.Type*/, newTyp, prefix, item.Name, IfThen(conv, "ret // convert from "+oldTyp, "ret"))
			}
			if item.HasSet {
				str += fmt.Sprintf("func %s_Set%s(obj uintptr, value %s) {\n    _, _, _ = getLazyProc(\"%s_Set%s\").Call(obj, %s)\n}\n\n",
					prefix, item.Name /*item.Type*/, newTyp, prefix, item.Name, IfThen(conv, "value /* convert from "+oldTyp+" */", "value"))
			}
		}
	})

	m.ForEach(func(item Method) {
		params := item.Params.JoinToStringFull(", ", "", "", func(it Parameter) string {
			oldTyp, newTyp, conv := dtypeToGoType(it.Type)
			s := it.Name + " " + newTyp
			if conv {
				s += " /* convert from " + oldTyp + " */ "
			}
			return s
		})
		callParam := item.Params.JoinToStringFull(", ", "", "", func(it Parameter) string {
			return it.Name
		})
		if params != "" {
			params = ", " + params
		}
		if callParam != "" {
			callParam = ", " + callParam
		}
		if item.MethodType == "procedure" {
			str += fmt.Sprintf("func %s_%s(obj uintptr%s) {\n    _, _, _ = getLazyProc(\"%s_%s\").Call(obj%s)\n}\n\n",
				prefix, item.Name, params, prefix, item.Name, callParam)
		}
		if item.MethodType == "function" {
			oldTyp, newTyp, conv := dtypeToGoType(item.ReturnType)
			str += fmt.Sprintf("func %s_%s(obj uintptr%s) %s {\n    ret, _, _ := getLazyProc(\"%s_%s\").Call(obj%s)\n    return %s\n}\n\n",
				prefix, item.Name, params /*item.ReturnType*/, newTyp, prefix, item.Name, callParam, IfThen(conv, "ret // convert from "+oldTyp, "ret"))
		}
	})

	dir, _ := os.Getwd()
	outFilePath := filepath.Join(dir, string(prefix+".out.goapi"))
	_ = f0.WriteFile(outFilePath, str)
}
