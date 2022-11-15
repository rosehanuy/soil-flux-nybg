def get_regression(df):
    y, X = dmatrices('CO2_Flux ~ Soil_Temp', data=df, return_type='dataframe')
    model = sm.OLS(y,X)
    result = model.fit()
    print(result.summary())
    return result