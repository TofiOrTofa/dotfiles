return{


	map = (function (tbl,func) test(tbl,func) --> {key = func}
		local out = {}
		for k,v in pairs(tbl) do
			out[k] = (func(v,k)) --> в функцию передаётся сначало value, а потом key
	end return(out) end),
	map_value = (function (tbl,func) test(tbl,func) --> {func}
		local out = {}
		for k,v in pairs(tbl) do
			table.insert(out,func(v,k))
	end return(out) end),-- эта функция в отличии от map выдаёт чистый список


	filter = (function (tbl,func) test(tbl,func)
		local out = {}
		for k,v in pairs(tbl) do
			if(func(v,k))then out[k]=v end
	end return(out) end),
	filter_value = (function (tbl,func) test(tbl,func)
		local out = {}
		local n = 0; for k,v in pairs(tbl) do
			if(func(v,k))then n=n+1;out[n]=v end
	end return(out) end),


}
