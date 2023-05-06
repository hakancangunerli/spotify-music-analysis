# %%
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# %%
df = pd.read_excel('MusicList.xlsx')

df = df.loc[:, ~df.columns.str.contains('^Unnamed')]


df = df[df['top genre'].notna()]

# replace every genre description with a general description of what they are 
# e.g. chicago rap -> rap 
genres = ["hip hop", "pop", "rock", "country", "drill", "jazz", "turkish", "lo-fi", "classical", "blues", "reggae", "folk", "metal", "dance", "electronic", "indie", "soul", "latin", "world", "other", "r&b", "rap", "house"]

for i in range(len(genres)):
    df.loc[df['top genre'].str.contains(genres[i]), 'top genre'] = genres[i]
    

# %%
# we need to get rid of some genres that are weirdly defined 
df.loc[df['top genre'].str.contains('hip-hop'), 'top genre'] = "hip hop"
df.loc[df['top genre'].str.contains('electro'), 'top genre'] = "electronic"
df.loc[df['top genre'].str.contains('oyun-havasi'), 'top genre'] = "turkish"
df.loc[df['top genre'].str.contains('arabesk'), 'top genre'] = "turkish"
df.loc[df['top genre'].str.contains('beatlesque'), 'top genre'] = "rock"
df.loc[df['top genre'].str.contains('bass'), 'top genre'] = "electronic"
df.loc[df['top genre'].str.contains('edm'), 'top genre'] = "electronic"
df.loc[df['top genre'].str.contains('baglama'), 'top genre'] = "turkish"
df.loc[df['top genre'].str.contains('dubstep'), 'top genre'] = "electronic"



#drop if it is not in the list of genres
df = df[df['top genre'].isin(genres)]

df

# %%


fig = px.scatter_3d(df, x="pop", y="dnce", z="top genre" , color="top genre", symbol="artist",size = "dur",)  
fig.update_scenes(xaxis_autorange="reversed")
fig.update_scenes(yaxis_autorange="reversed")
fig.update_scenes(zaxis_autorange="reversed")
fig.show()

fig.write_image("./fig1.svg")



# %% [markdown]
# ![]<img src="./fig1.svg">

# %%


fig2 = px.pie(df, values="pop", names="top genre", title="Popularity by Genre", color_discrete_sequence=px.colors.qualitative.Dark24)
fig2.update_traces(textposition='inside', textinfo='percent+label')
fig2.show()

fig2.write_image("./fig2.svg")

# %% [markdown]
# ![]<img src="./fig2.svg">


