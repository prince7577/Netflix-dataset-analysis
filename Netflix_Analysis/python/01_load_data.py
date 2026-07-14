import pandas as pd

df = pd.read_csv("../dataset/netflix_titles.csv")

print(df.head())
print(df.shape)
print(df.columns)