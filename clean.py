import pandas as pd

df = pd.read_csv('./data/time_spent.csv')


# Group by email and calculate the average of 'time_evaluate' column for each group
df['time_evaluate'] = df.groupby('email')['time_evaluate'].transform('mean')
df = df.drop_duplicates(subset=['email'])

print(df.head())