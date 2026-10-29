{# Extracts one value from GA4's nested event_params array.
   type: string_value | int_value | float_value | double_value #}
{% macro event_param(key, type='string_value') %}
    (select value.{{ type }} from unnest(event_params) where key = '{{ key }}')
{% endmacro %}
