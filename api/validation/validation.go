package validation

func IsEmpty(data interface{}) bool {

	switch data.(type) {
	case string:
		cvtData := data.(string)
		return (cvtData + "y") == "y"
	default:
		return false
	}
}
