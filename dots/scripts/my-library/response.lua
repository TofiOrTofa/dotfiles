response = {}


function response.success (v) local result
	result = {["state"]="success", ["value"]=v}
return function (key) return result[key] end end

function response.fail (e) local result
	result = {["state"]="fail", ["value"]=v}
return function (key) return result[key] end end


return response = {}
