package.path = package.path .. ';/etc/tr069/?.lua'
local tr069 = require('tr069')

-- declarations

local uci_config = "iptables"
local IGD_prefix = "InternetGatewayDevice"
local IPTABLES_prefix = "Iptables"
local IPTABLES_suffix = "Rule"
local IPTABLES_path = IGD_prefix..'.'..IPTABLES_prefix..'.'..IPTABLES_suffix..'.{i}.'

local parameter_list = {}

local function get_index_sect(uri)
	local index
	for var in string.gmatch(uri,"[.](%d)[.]") do
		index = var
	end
	local index_num = tonumber(index) - 1
	local item = "@rule["..index_num.."]"
	return item
end

local function get_option(param)
	local option
	option = string.gsub(param, "%w+.%w+.%w+.Rule.%d.","")  
	option = string.lower(option)
	return option
end

local function get_value(param)
	local index_sect = get_index_sect(param)
	local option = get_option(param)
	local val = tr069.get_uci(uci_config, index_sect, option)
	return val
end


local function set_value(param, value)
	tr069.dlog(param)
	tr069.dlog(value)
        local index_sect = get_index_sect(param)
        local option = get_option(param)
        tr069.set_uci(uci_config, index_sect, option, value)
        return 0
end

parameter_list[IPTABLES_path .. "Name"] = {get_value, set_value}
parameter_list[IPTABLES_path .. "Chain"] = {get_value, set_value}
parameter_list[IPTABLES_path .. "Dest_Port"] = {get_value, set_value}
parameter_list[IPTABLES_path .. "Proto"] = {get_value, set_value}
parameter_list[IPTABLES_path .. "Src"] = {get_value, set_value}
parameter_list[IPTABLES_path .. "Target"] = {get_value, set_value} 

local function register_parameters()
	return tr069.get_parameter_list(parameter_list)
end

local function set_parameter(uri,value)
	tr069.set_node(parameter_list, uri, value)
	return 0
end

local function get_parameter(uri)
	return tr069.get_node(parameter_list, uri)
end

local function sync()
end

local function add_instance(uri)
	local index = get_index_sect(uri)
	tr069.set_uci(uci_config, "rule")
	tr069.set_uci(uci_config, index, "name", "")
	tr069.set_uci(uci_config, index, "chain", "")
	tr069.set_uci(uci_config, index, "dest_port", "")
	tr069.set_uci(uci_config, index, "proto", "")
	tr069.set_uci(uci_config, index, "src", "")
	tr069.set_uci(uci_config, index, "target", "")
	return 0
end

local function del_instance(uri)
	local index = get_index_sect(uri)

	return tr069.delete_uci("tr069", index)
end

 local function get_instances(uri)
	local array = {}
	local array_count = 0
	uci_c:foreach(uci_config, "rule", function (s)
		local name = s[".name"]
		array[array_count] = array_count + 1
		array_count = array_count + 1
	end)
	return array
end

return {
    node = IPTABLES_path,
    parameters = register_parameters,
    get = get_parameter,
    set = set_parameter,
    sync = sync,
    add_node = add_instance,
    del_node = del_instance,
    get_instances = get_instances
}
