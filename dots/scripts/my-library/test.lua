local test = {}


function test.critical (result) if result("state") == "fail" then
	error(result("value")) end
end

function test.typ (typ, vars) for _,var in ipairs(vars) do
	if type(var) ~= typ then return fail(
		string.format("expected %s, got %s", typ, type(var))) end
end return success() end


return test
