# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.5
#   kernelspec:
#     display_name: Julia 1.8.4
#     language: julia
#     name: julia-1.8
# ---

using Pkg; 
# Pkg.add("DataFrames"); Pkg.add("CSV");Pkg.add("XLSX"); Pkg.add("PyPlot"); Pkg.add("Plots") Pkg.add("StatsBase")
using DataFrames, CSV, XLSX;
# using Plots;
using StatsBase  # import the Statistics module to use countmap()

# +
df = DataFrame(XLSX.readtable("MusicList.xlsx", "Sheet1"));

first(df,5)

# +
genres = ["ambient","hip hop", "pop", "rock", "country", "drill", "jazz", "turkish", "lo-fi", "classical", "blues", "reggae", "folk", "metal", "dance", "electronic", "indie", "soul", "latin", "world", "other", "r&b", "rap", "house"]

for i in 1:length(genres)
    df[occursin.(genres[i], coalesce.(df[:, "top genre"], "")), "top genre"] .= genres[i]
end


# +
# convert top genre type to string 
df[!, "top genre"] = string.(df[!, "top genre"])

df[df[:, "top genre"] .== "hip-hop", "top genre"] .= "hip hop"
df[df[:, "top genre"] .== "electro", "top genre"] .= "electronic"
df[df[:, "top genre"] .== "oyun havasi", "top genre"] .= "turkish"
df[df[:, "top genre"] .== "arabesk", "top genre"] .= "turkish"
df[df[:, "top genre"] .== "beatlesque", "top genre"] .= "rock"
df[df[:, "top genre"] .== "bass", "top genre"] .= "electronic"
df[df[:, "top genre"] .== "edm", "top genre"] .= "electronic"
df[df[:, "top genre"] .== "baglama", "top genre"] .= "turkish"
df[df[:, "top genre"] .== "dubstep", "top genre"] .= "electronic"
df[df[:, "top genre"] .== "japanese chillhop", "top genre"] .= "lo-fi"
# permanent wave to electronic 
df[df[:, "top genre"] .== "permanent wave", "top genre"] .= "electronic"
# plugg to electronic, electro swing
df[df[:, "top genre"] .== "plugg", "top genre"] .= "rap"
df[df[:, "top genre"] .== "electro swing", "top genre"] .= "electronic"


# drop the missing in top genre 
df = df[.!ismissing.(df[:, "top genre"]), :]

# drop the rows wiht the value "missing" in top genre
df = df[df[:, "top genre"] .!= "missing", :]


genre_counts = countmap(df."top genre")


# Define the subgenre lists and their corresponding genres, classified by ChatGPT
subgenre_lists = Dict(
    "ambient" => ["sleep", "focus", "melancholia", "binaural", "rain"],
    "hip hop" => ["bboy", "g funk", "boom bap", "rap"],
    "pop" => ["eurovision", "boy band", "lilith", "dreamo"],
    "rock" => ["dixieland", "new romantic", "big band", "british invasion", "late romantic era", "rare groove", "surf music", "australian garage punk"],
    "country" => ["alt z", "canadian psychedelic"],
    "drill" => ["grime", "drift phonk"],
    "jazz" => ["bebop"],
    "turkish" => ["azeri traditional", "ney"],
    "lo-fi" => ["chillhop", "chillwave", "calming instrumental", "background piano"],
    "classical" => ["orchestra", "baroque", "klezmer"],
    "blues" => [],
    "reggae" => [],
    "folk" => ["irish singer-songwriter"],
    "metal" => ["digital hardcore"],
    "dance" => ["eurobeat", "super eurobeat", "vapor twitch", "tropical alternativo", "francoton", "cumbia", "funk carioca"],
    "electronic" => ["aussietronica","glitchbreak","hard bass","hi-nrg","electra","hardcore techno", "bass music", "avant-garde", "compositional ambient", "downtempo", "big beat", "atmospheric dnb", "deep dnb", "bubble trance", "weirdcore", "glitchcore", "background music", "brostep", "future bass", "complextro", "disco", "big room", "epicore", "drum and bass","dark clubbing"],
    "indie" => ["new french touch", "french shoegaze", "indie"],
    "soul" => ["adult standards", "motown", "mellow gold", "funk"],
    "latin" => ["bossa nova", "bossa nova cover", "tropical alternativo", "nu-cumbia", "cumbia", "afroswing"],
    "world" => ["chanson","balalaika", "israeli traditional", "musica santomense", "cuban alternative", "ccm", "afrofuturism", "afrofuturismo brasileiro"],
    "other" => ["french movie tunes", "escape room", "corrido", "comic", "mashup", "anime", "disney", "soundtrack", "shush","sound", "french movie tunes", "hopebeat", "background music", "german soundtrack", "destroy techno", "future funk", "basshall", "chillstep", "dream smp", "deep funk", "australian psych"],
    "r&b" => ["neo mellow", "chill baile"],
    "rap" => ["gqom", "j-idol"],
    "house" => []
)

# change the genres of the subgenres to the corresponding genres

for (genre, subgenres) in subgenre_lists
    for subgenre in subgenres
        df[df[:, "top genre"] .== subgenre, "top genre"] .= genre
    end
end


# # get the strings in the genre_counts

genre_counts_keys = collect(keys(genre_counts))


elements = intersect(genre_counts_keys, genres)

# remove these elements from the genre_counts

for i in 1:length(elements)
    delete!(genre_counts, elements[i])
end

genre_counts_keys = collect(keys(genre_counts))

print(length(genre_counts_keys))
print(genre_counts_keys)
# -

# change column name from top genre to top_genre 
rename!(df, :"top genre" => :top_genre)


# +
using PlotlyJS;

fig2 = plot(pie(x=df.top_genre,labels=df.top_genre, names=df.top_genre),
            Layout(title="Popularity by Genre", 
            textinfo="label+percent",
            textposition="inside",
            ))
