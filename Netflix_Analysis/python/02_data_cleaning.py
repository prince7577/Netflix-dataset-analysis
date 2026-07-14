import pandas as pd

df = pd.read_csv("dataset/netflix_titles.csv")

df["director"] = df["director"].fillna("Unknown")
df["cast"] = df["cast"].fillna("Unknown")
df["country"] = df["country"].fillna("Unknown")
df["rating"] = df["rating"].fillna("Not Rated")
df["duration"] = df["duration"].fillna("Unknown")

df = df.dropna(subset=["date_added"])

df.to_csv("dataset/netflix_cleaned.csv", index=False)

print("Cleaning completed!")