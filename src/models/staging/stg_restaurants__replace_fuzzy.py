from fuzzywuzzy import process, fuzz
def model(dbt, session):
    dbt.config(
        materialized = "table",
        packages = ["fuzzywuzzy"]
    )
        

    dishes_flattened_df = dbt.ref('stg_restaurants__dishes_flatten').to_pandas()
    dishes_df = dbt.ref('restaurants__dishes_turnover').to_pandas()

    dishes_list = dishes_df['NAME'].tolist()

    dishes_flattened_df['DISH_NAME'] = dishes_flattened_df['DISH_NAME'].apply(lambda x: process.extractOne(x, dishes_list)[0])

    dishes_flattened_df['DISH_ID'] = dishes_flattened_df['DISH_NAME'].apply(lambda x: dishes_df[dishes_df['NAME'] == x]['DISH_IDENTIFIER'].values[0])

    return dishes_flattened_df

