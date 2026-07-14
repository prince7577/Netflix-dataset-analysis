import pandas as pd

# Load dataset
df = pd.read_csv("dataset/netflix_titles.csv")

print("========== NETFLIX DATASET ==========")
print("Shape:", df.shape)

print("\nColumns:")
print(df.columns)

print("\nFirst 5 Rows:")
print(df.head())

# Data Types
print("\n========== DATA TYPES ==========")
print(df.dtypes)

# Missing Values
print("\n========== MISSING VALUES ==========")
print(df.isnull().sum())

# Duplicate Rows
print("\n========== DUPLICATE ROWS ==========")
print(df.duplicated().sum())



# Fill missing values
df["director"] = df["director"].fillna("Unknown")
df["cast"] = df["cast"].fillna("Unknown")
df["country"] = df["country"].fillna("Unknown")
df["rating"] = df["rating"].fillna("Not Rated")
df["duration"] = df["duration"].fillna("Unknown")

# Remove rows where date_added is missing
df = df.dropna(subset=["date_added"])

print("\n========== AFTER CLEANING ==========")
print(df.isnull().sum())


print("\nMovies vs TV Shows")
print(df["type"].value_counts())


print("\nTop Ratings")
print(df["rating"].value_counts())


print("\nTop 10 Countries")
print(df["country"].value_counts().head(10))


print("\nTop Release Years")
print(df["release_year"].value_counts().head(10))


print("\nTop Directors")
print(df["director"].value_counts().head(10))


import pandas as pd
import matplotlib.pyplot as plt


print("\nMovies vs TV Shows")
print(df["type"].value_counts())

df["type"].value_counts().plot(kind="bar")

plt.title("Movies vs TV Shows")
plt.xlabel("Type")
plt.ylabel("Count")

plt.show()


