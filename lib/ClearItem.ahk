ClearItem(item){
	StringUpper item, item, U
	StringReplace, item, item, `r`n, , All
	StringReplace, item, item, :, , All
	StringReplace, item, item, Й, И, All
	StringReplace, item, item, Ё, Е, All
	StringReplace, item, item, ', , All
	StringReplace, item, item, *, , All
	StringReplace, item, item, ЧЕРТЕЖ%A_Space%,,
	StringReplace, item, item, ЛЕЗВИЕ, КЛИНОК
	item := Trim(item)
	aItem := StrSplit(item, A_Space)
	if(aItem.Count() == 2){
		item := item " ЧЕРТЕЖ"
	}
	if(inStr(item, "ВОБАН")){
		StringReplace, item, item, ПРАИМ, ,	
		StringReplace, item, item, ОО, О, All
	}
	if(inStr(item, "КУБРАУ")){
		StringReplace, item, item, КУБРАУ, ,	
	}
	StringReplace, item, item, %A_Space%%A_Space%, %A_Space%, All
	return item
}