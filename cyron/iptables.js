'use strict';
'require view';
'require form';
'require uci';
'require firewall';
'require ui';

var CBIProtocolSelect =  form.MultiValue.extend({
    addChoice: function(value, label) {
        if (!Array.isArray(this.keylist) || this.keylist.indexOf(value) == -1)
            this.value(value, label);
    },

    renderWidget: function(section_id, option_index, cfgvalue) {
        var value = cfgvalue, choices = this.transformChoices();

        var widget = new ui.Dropdown(L.toArray(value), choices, {
            id: this.cbid(section_id),
            sort: this.keylist,
            multiple: true,
            optional: true,
            display_items: 7,
            create: false,
        });

        return widget.render();
    }
})

return view.extend({

    render: function(data) {
        var m, s, o;

        m = new form.Map('iptables', _('IP Tables'), _('Edit Prerouting and Postrouting routes for specific addresses'));
        s = m.section(form.TypedSection, 'defaults', _('IP Tables'));
        s.anonymous = true;

        s = m.section(form.GridSection, 'rule', '');
        s.addremove = true;
        s.anonymous = true;

        o = s.option(form.Value, 'name', ('Name'));

	o = s.option(form.ListValue, 'chain', ('Chain'));
	o.value("INPUT");
	o.value("FORWARD");
	o.value("OUTPUT");
	
	o = s.option(form.Value, 'src', ('Source'));
	o.datatype = 'ip4addr';

        o = s.option(form.ListValue, "proto", ('Protocol'));
	o.value("tcp");
	o.value("udp");

        o = s.option(form.Value, "dest", ('Destination'));
	o.datatype = 'ip4addr';

        o = s.option(form.ListValue, "target", ('Target'));
        o.value("ACCEPT");                           
        o.value("DROP");                         
        o.value("REJECT");


        return m.render();
    }
});
