module ApplicationHelper
  def autocomplete_input(attributes={})
    #*need* object: this form's object : "person"
    #*need* instance: searcheable object : 'account'
    # instance_key: primary key of this instance : 'account_id'
    # value: original or default value for instance : 'Yahoo Corp.'
    # value_key: original or default value for instance_key: 252
    #*need* ajax_url: remote url for ajax call without format: url_for(:controller=> :accounts, :action=> :search, :id=>'all')
    # ajax_query_additional_params (Array): ["maxRows: 7", "anything :20"]
    #*need* ajax_query_searchable_param Object's string (String): "name" (@person.account.name)
    #*need* ajax_query_searchable_param_key Object's foreign key (String): "id" (@person.account.id)
    # min_length minimal chars to start searching: 2

    if attributes.nil? then return false end
    if attributes.empty? then return false end
    object=attributes[:object]
    instance=attributes[:instance]
    if object.nil? or instance.nil? then return false end
    object=object.to_s.downcase
    instance=instance.to_s.downcase
    instance_key=attributes[:instance_key] || instance + "_id"
    value=attributes[:value] || ""
    value_key=attributes[:value_key] || ""
    value_key_html=""
    unless value_key.to_s.empty? then
      value_key_html=" value=\""+value_key.to_s+"\""
    end
    ajax_url=attributes[:ajax_url]
    ajax_query_additional_params=attributes[:ajax_query_additional_params] || ""
    ajax_query_searchable_param=attributes[:ajax_query_searchable_param] || "name"
    ajax_query_searchable_param_key=attributes[:ajax_query_searchable_param_key] || "id"
    min_length=attributes[:min_length] || 2

    ajax_query_additional_params_formatted=""
    unless ajax_query_additional_params.nil? then
      case ajax_query_additional_params
        when Array then
          i=0
          ajax_query_additional_params.each do |aqap|
            if i==0 then
              ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + aqap.to_s
            else
              ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + ",\n" + aqap.to_s
            end
            i=i.next
          end
        when String then
          ajax_query_additional_params_formatted=ajax_query_additional_params
        when Hash then
          i=0
          ajax_query_additional_params.each do |aqap_key,aqap_value|
            if i==0 then
              ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + aqap_key.to_s + ": " + aqap_value.to_s
            else
              ajax_query_additional_params_formatted=ajax_query_additional_params_formatted + ",\n" + aqap_key.to_s + ": " + aqap_value.to_s
            end
            i=i.next
          end
      end
    end
    jquery_request_data_params="data: {\n"
    unless ajax_query_additional_params_formatted.empty? then
      jquery_request_data_params=jquery_request_data_params + ajax_query_additional_params_formatted + ",\n"
    end
    jquery_request_data_params=jquery_request_data_params + "#{ajax_query_searchable_param}: request.term\n},"
    search_field_id="search_#{object}_#{instance}"
    value_div_id="#{object}_#{instance}_log"
    hidden_field_id="#{object}_#{instance_key}"
    hidden_field_name="#{object}[#{instance_key}]"
    function_log_name="log_#{object}_#{instance}"

    html_text = <<HTML1
<table><tbody><tr>
    <td><input id="#{search_field_id}" class="ui-autocomplete-input"/></td>
    <td><div id="#{value_div_id}" class="ui-widget-content">#{value}</div></td>
</tr></tbody></table>
<input type="hidden" id="#{hidden_field_id}" name="#{hidden_field_name}" #{value_key_html} >

HTML1

    js_text = <<JS1

$(function() {

    function #{function_log_name}( label, id ) {
        $( "##{value_div_id}" ).html(label);
        $( "##{hidden_field_id}").val(id);
    }

    $( "##{search_field_id}" ).autocomplete({
        source: function( request, response ) {
            $.ajax({
                url: "#{ajax_url}.json",
                dataType: "json",
                #{jquery_request_data_params}
                success: function( data ) {
                    response( $.map( data, function( item ) {
                        return {
                            label: item.#{ajax_query_searchable_param},
                            value: item.#{ajax_query_searchable_param},
                            id: item.#{ajax_query_searchable_param_key}
                        }
                    }));
                }
            });
        },
        minLength: #{min_length},
        select: function( event, ui ) {
            if (ui.item) {
                #{function_log_name}( ui.item.value, ui.item.id );
            } else {
                #{function_log_name}( this.value, this.value );
            }
        },
        open: function() {
            $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });
});

JS1
    concat(raw(javascript_tag(js_text)))
    concat(raw(html_text))
  end
end
