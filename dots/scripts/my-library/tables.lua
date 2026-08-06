local tables = {}


function tables.merge (t1, t2, ...)
	test.critical(test.typ("table", {t1, t2, ...}))
	local result = {}
	local count = select("#", ...)
	for i=1, count do
		local arg = select(i, ...)
		for k,v in pairs(arg) do result[k] = v end
	end
return result end

function tables.contains (t1, t2)
	test.critical(test.typ("table", {t1, t2})("state"))
	for k,v in pairs(t1) do
		local result = iff( test.typ("table", {v, t2[k]}),
			function () return tables.contains(v, t2[k]) end,
			function () if v ~= t2[k] then
			return false end end)
		if not result then return false end
	end
return true end
