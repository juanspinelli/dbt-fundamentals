{%- macro limit_data_in_dev(column_name, dev_days_on_data=3) -%}
{%- if target.name == 'dev' -%}
where {{ column_name }}  >= current_date - INTERVAL '{{ dev_days_on_data }} DAY'
{% endif -%}
{% endmacro -%}