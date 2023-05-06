## ----setup, include=FALSE-------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -------------------------------------------------------------------------------------------------------------------------------
library(readxl)
#install.packages("dplyr")

library("dplyr")
df <- read_excel("./MusicList.xlsx")


head(df)


## ---- echo=FALSE----------------------------------------------------------------------------------------------------------------

genres <- c("ambient","hip hop", "pop", "rock", "country", "drill", "jazz", "turkish", "lo-fi", "classical", "blues", "reggae", "folk", "metal", "dance", "electronic", "indie", "soul", "latin", "world", "other", "r&b", "rap", "house")


for (i in 1:length(genres)) {
  df[grepl(genres[i], coalesce(df$`top genre`, "")), "top genre"] <- genres[i]
}

df



## -------------------------------------------------------------------------------------------------------------------------------
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] == "hip-hop"] <- "hip hop"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] == "electro"] <- "electronic"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] == "oyun havasi"] <- "turkish"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] == "arabesk"] <- "turkish"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] == "beatlesque"] <- "rock"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "bass"] <- "electronic"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "edm"] <- "electronic"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "baglama"] <- "turkish"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "dubstep"] <- "electronic"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "japanese chillhop"] <- "lo-fi"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "permanent wave"] <- "electronic"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "plugg"] <- "rap"
df[complete.cases(df[, "top genre"]), "top genre"][df[complete.cases(df[, "top genre"]), "top genre"] ==  "electro swing"] <- "electronic"

df <- df[!is.na(df[,"top genre"]),]

df


## -------------------------------------------------------------------------------------------------------------------------------
subgenre_lists <- list(
    "ambient" = c("sleep", "focus", "melancholia", "binaural", "rain"),
    "hip hop" = c("bboy", "g funk", "boom bap", "rap"),
    "pop" = c("eurovision", "boy band", "lilith", "dreamo"),
    "rock" = c("dixieland", "new romantic", "big band", "british invasion", "late romantic era", "rare groove", "surf music", "australian garage punk"),
    "country" = c("alt z", "canadian psychedelic"),
    "drill" = c("grime", "drift phonk"),
    "jazz" = c("bebop"),
    "turkish" = c("azeri traditional", "ney"),
    "lo-fi" = c("chillhop", "chillwave", "calming instrumental", "background piano"),
    "classical" = c("orchestra", "baroque", "klezmer"),
    "folk" = c("irish singer-songwriter"),
    "metal" = c("digital hardcore"),
    "dance" = c("eurobeat", "super eurobeat", "vapor twitch", "tropical alternativo", "francoton", "cumbia", "funk carioca"),
    "electronic" = c("aussietronica","glitchbreak","hard bass","hi-nrg","electra","hardcore techno", "bass music", "avant-garde", "compositional ambient", "downtempo", "big beat", "atmospheric dnb", "deep dnb", "bubble trance", "weirdcore", "glitchcore", "background music", "brostep", "future bass", "complextro", "disco", "big room", "epicore", "drum and bass","dark clubbing"),
    "indie" = c("new french touch", "french shoegaze", "indie"),
    "soul" = c("adult standards", "motown", "mellow gold", "funk"),
    "latin" = c("bossa nova", "bossa nova cover", "tropical alternativo", "nu-cumbia", "cumbia", "afroswing"),
    "world" = c("chanson","balalaika", "israeli traditional", "musica santomense", "cuban alternative", "ccm", "afrofuturism", "afrofuturismo brasileiro"),
    "other" = c("french movie tunes", "escape room", "corrido", "comic", "mashup", "anime", "disney", "soundtrack", "shush","sound", "french movie tunes", "hopebeat", "background music", "german soundtrack", "destroy techno", "future funk", "basshall", "chillstep", "dream smp", "deep funk", "australian psych"),
    "r&b" = c("neo mellow", "chill baile"),
    "rap" = c("gqom", "j-idol")
)



for (genre in names(subgenre_lists)) {
  subgenres <- subgenre_lists[[genre]]
  for (subgenre in subgenres) {
    df[df[["top genre"]] == subgenre, "top genre"] <- genre
  }
}


## -------------------------------------------------------------------------------------------------------------------------------
head(df)


## -------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)

# Create a table of genre counts
genre_count <- table(df$`top genre`)

# Create a pie chart
pie(genre_count, 
    main="Distribution of Music Genres", 
    col=rainbow(length(genre_count)),
    labels=paste(names(genre_count), ": ", round(100*genre_count/sum(genre_count),1), "%", sep=""))

# Add a legend
legend("topright", legend = names(genre_count), fill = rainbow(length(genre_count)))

knitr::purl("Ranalysis.Rmd")

