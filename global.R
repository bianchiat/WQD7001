library(jsonlite)
library(geojsonio)
library(dplyr)
library(leaflet)

# From http://data.okfn.org/data/datasets/geo-boundaries-world-110m
geojson<- geojsonio::geojson_read("countries.geojson",
                                  what = "sp")
Country <-as.character(geojson$admin)
pop_est <-as.numeric(as.character(geojson$pop_est))

#Segregate Country and Popdata from list
Df<-cbind(Country,pop_est)
Df1<-as.data.frame(Df)
Df1$pop_est<-as.numeric(as.character(Df1$pop_est))
Df1$Country<-as.character(Df1$Country)


#Read csv file
df<-read.csv("TB Combined dataset_3.csv",na.strings = NA,fill = NA)


#filter relevant data
df1<-df %>%
  filter(Year=="2016")%>%
  group_by(Country)

dff<-left_join(Df1,df1, by="Country")



#show top 10 country with most success rate new TB.cases
dff%>%
  arrange(desc(TB_Death_HIVneg_per100k_pop))%>%
  top_n(10)
summary(dff)


dff2<-dff%>%
  mutate(TB_Death_HIVneg_per100k_pop = replace(TB_Death_HIVneg_per100k_pop,TB_Death_HIVneg_per100k_pop<1 ,1))

dff2<-dff2%>%
  mutate(TB_Death_HIVneg_per100k_pop = round(TB_Death_HIVneg_per100k_pop,digits=3))


# Add the now-styled GeoJSON object to the map
bins<-seq(0,1,by=0.1)
pal <- colorBin(palette = c("green","yellow","Red"),domain = c(0,1),bins = bins)


