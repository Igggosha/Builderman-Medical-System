local Map = {}

function Map.map(x, input_start, input_end, output_start, output_end)
	return (x - input_start) / (input_end - input_start) * (output_end - output_start) + output_start
end

return Map
