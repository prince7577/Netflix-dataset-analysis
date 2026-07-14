import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("dataset/netflix_cleaned.csv")

content = df["type"].value_counts()

plt.figure(figsize=(6,4))

content.plot(kind="bar")

plt.title("Movies vs TV Shows on Netflix")
plt.xlabel("Content Type")
plt.ylabel("Count")

plt.tight_layout()

plt.savefig("images/movies_vs_tvshows.png")

plt.show()

print("Chart saved successfully!")



# Top 10 Countries
plt.figure(figsize=(10,5))

df["country"].value_counts().head(10).plot(kind="bar")

plt.title("Top 10 Countries on Netflix")
plt.xlabel("Country")
plt.ylabel("Number of Titles")
plt.xticks(rotation=45)

plt.tight_layout()

plt.savefig("images/top_10_countries.png")

plt.show()

print("Top 10 Countries chart saved!")



# Top 10 Ratings

plt.figure(figsize=(10,5))

df["rating"].value_counts().head(10).plot(kind="bar")

plt.title("Top 10 Content Ratings")
plt.xlabel("Rating")
plt.ylabel("Number of Titles")

plt.xticks(rotation=45)

plt.tight_layout()

plt.savefig("images/top_ratings.png")

plt.show()

print("Top Ratings chart saved!")



# Content Released by Year

plt.figure(figsize=(12,5))

df["release_year"].value_counts().sort_index().plot(kind="line", marker="o")

plt.title("Netflix Content Released by Year")
plt.xlabel("Release Year")
plt.ylabel("Number of Titles")

plt.tight_layout()

plt.savefig("images/release_year_trend.png")

plt.show()

print("Release Year Trend chart saved!")


# Top 10 Directors

plt.figure(figsize=(12,6))

df[df["director"] != "Unknown"]["director"].value_counts().head(10).plot(kind="bar")

plt.title("Top 10 Directors on Netflix")
plt.xlabel("Director")
plt.ylabel("Number of Titles")

plt.xticks(rotation=45, ha="right")

plt.tight_layout()

plt.savefig("images/top_directors.png")

plt.show()

print("Top Directors chart saved!")


# Top 10 Genres

from collections import Counter

genres = df["listed_in"].str.split(", ").explode()

top_genres = genres.value_counts().head(10)

plt.figure(figsize=(10,6))

top_genres.plot(kind="bar")

plt.title("Top 10 Genres on Netflix")
plt.xlabel("Genre")
plt.ylabel("Number of Titles")

plt.xticks(rotation=45, ha="right")

plt.tight_layout()

plt.savefig("images/top_genres.png")

plt.show()

print("Top Genres chart saved!")


# Movies vs TV Shows Pie Chart

plt.figure(figsize=(6,6))

df["type"].value_counts().plot(
    kind="pie",
    autopct="%1.1f%%",
    startangle=90
)

plt.title("Movies vs TV Shows Distribution")
plt.ylabel("")

plt.tight_layout()

plt.savefig("images/movies_vs_tvshows_pie.png")

plt.show()

print("Movies vs TV Shows Pie Chart saved!")



# Content Added by Year

df["date_added"] = pd.to_datetime(df["date_added"])

added_per_year = df["date_added"].dt.year.value_counts().sort_index()

plt.figure(figsize=(12,5))

added_per_year.plot(kind="line", marker="o")

plt.title("Content Added to Netflix by Year")
plt.xlabel("Year")
plt.ylabel("Number of Titles Added")

plt.grid(True)

plt.tight_layout()

plt.savefig("images/content_added_per_year.png")

plt.show()

print("Content Added Per Year chart saved!")