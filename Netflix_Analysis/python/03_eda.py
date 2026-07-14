import pandas as pd

df = pd.read_csv("dataset/netflix_cleaned.csv")

print("=" * 50)
print("NETFLIX EXPLORATORY DATA ANALYSIS")
print("=" * 50)

print("\nMovies vs TV Shows")
print(df["type"].value_counts())

print("\nTop 10 Countries")
print(df["country"].value_counts().head(10))

print("\nTop Ratings")
print(df["rating"].value_counts().head(10))

print("\nTop Release Years")
print(df["release_year"].value_counts().head(10))

print("\nTop Directors")
print(df["director"].value_counts().head(10))