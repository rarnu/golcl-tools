package parser

import (
	. "github.com/isyscore/isc-gobase/isc"
)

type Property struct {
	Name    string
	Type    string
	HasGet  bool
	HasSet  bool
	IsEvent bool
}

func ParseProperty(item ISCString) Property {
	s := item.SubStringAfter("property ").TrimSpace()
	n := s.SubStringBefore(":").TrimSpace()
	s = s.SubStringAfter(":").TrimSpace()
	t := s.SubStringBefore(" ").TrimSpace()
	hg := s.Contains(" read ")
	hs := s.Contains(" write ")

	return Property{
		Name:    string(n),
		Type:    string(t),
		HasGet:  hg,
		HasSet:  hs,
		IsEvent: n.StartsWith("On"),
	}
}
