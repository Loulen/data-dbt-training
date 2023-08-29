{% macro export_to_s3(external_stage, prefix, filename, columns_to_export, compression = 'None',
    single = 'True', overwrite = 'True', max_file_size = 200000000, delimiter = ',', dry_run = True) %}

    {# This macro unloads models into an s3
        - To really export to the s3, you need to set the dry_run parameter to False -
        The best practice is to add a project variable to the dbt_project.yml file and set it to True by default. 
        Then, when you really need to unload to s3, call the command with the --vars parameter '{"dry_run":False}'. 
        
        !! Today, only JSON, JSON Lines and CSV fomats are developed and available !! #}

    {% set query %}

        copy into @{{ external_stage }}/{{ prefix }}/{{ filename }}.csv

        from (
            {# CSV format #}
            {# This first part add the header of the csv file #}
            select
                {% for column in columns_to_export %}
                    upper('{{ column }}') AS {{ column }}
                    {{ delimiter if not loop.last }}
                {% endfor %}
            union all
            {# The second part here add the data #}
            select
                {% for column in columns_to_export %}
                    {{ column }}::string
                    {{ delimiter if not loop.last }}
                {% endfor %}
            from 
                    {{ this }}
        )

        {# Parameters #}
        file_format = (
            type = 'csv'
            compression = {{ compression }}
        )
        single = {{ single }}
        overwrite = {{ overwrite }}
        max_file_size = {{ max_file_size }}

    {% endset %}

    {# Allow to verify the query and prevent unwanted export#}
    {% if execute %}
        {% if dry_run %}
            {{ log(query, info=true) }}
        {% else %}
            {% do run_query(query) %}
        {% endif %}
    {% endif %}
{% endmacro %}