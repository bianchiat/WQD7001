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
#head(Df)
Df1<-as.data.frame(Df)
#str(Df1)
Df1$pop_est<-as.numeric(as.character(Df1$pop_est))
Df1$Country<-as.character(Df1$Country)
#typeof(Df1$pop_est)
#head(Df1)


#Read csv file
df<-read.csv("TB Combined dataset_3.csv",na.strings = NA,fill = NA)
#df<-read.csv("TB Combined dataset-20190515(2).csv",na.strings = NA,fill = NA)
#df<-read.csv("TB Combined dataset-20190523 (2).csv",na.strings = NA,fill = NA)
#tail(df)
#str(df)
#df$Deaths.due.to.tuberculosis.among.HIV.negative.people..per.100.000.population.
#Country[44]


#filter relevant data
df1<-df %>%
  filter(Year=="2015")%>%
  group_by(Country)
#Country[28]

#head(Df1)
#head(df1)
dff<-left_join(Df1,df1, by="Country")
#str(dff)
#head(dff)

#dff1<-(-dff$pop_est<0)
#dff[dff1,1]


#show top 10 country with most success rate new TB.cases
dff%>%
  arrange(desc(TB_Death_HIVneg_per100k_pop))%>%
  top_n(10)
summary(dff)

#dff%>%
  #transmute(log10DeathTB=log10(TB_Death_HIVneg_per100k_pop))%>%
  #summary(log10DeathTB)


dff2<-dff%>%
  mutate(TB_Death_HIVneg_per100k_pop = replace(TB_Death_HIVneg_per100k_pop,TB_Death_HIVneg_per100k_pop<1 ,1))

dff2<-dff2%>%
  #mutate(TB_Death_HIVneg_per100k_pop = log10(TB_Death_HIVneg_per100k_pop))
  mutate(TB_Death_HIVneg_per100k_pop = round(TB_Death_HIVneg_per100k_pop,digits=3))
  

#dff2<-dff%>%
  #mutate(TB_Death_HIVminusper100k_pop = replace(TB_Death_HIVminusper100k_pop,TB_Death_HIVminusper100k_pop<1 ,1))
#summary(dff2$Treatment.success.rate..new.TB.cases)





# Add the now-styled GeoJSON object to the map
#bins<-c(0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0)
bins<-seq(0,1,by=0.1)

pal <- colorBin(palette = c("green","yellow","Red"),domain = c(0,1),bins = bins)

#leaflet(geojson) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                              #attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>')%>%
  #addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5,
              #label = paste(dff$Country, ":", (dff2$Deaths.due.to.tuberculosis.among.HIV.negative.people..per.100.000.population.)),
              #color = pal(log10(dff2$Deaths.due.to.tuberculosis.among.HIV.negative.people..per.100.000.population.))
  #)%>%
  #setView(lng = 0, lat = 40, zoom = 2) %>%
  #addLegend("bottomleft",title = "Deaths.due.to.TB.among.HIV.-ve.per.100k.population.",pal = pal, 
            #values =log10(dff2$Deaths.due.to.tuberculosis.among.HIV.negative.people..per.100.000.population.), opacity = 0.5)



#?addLegend



#map <- leaflet(geojson) %>% addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
#attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>')
#pal <- colorNumeric(
#palette = "YlGnBu",
#domain = dff$pop_est
#)
#map %>%
#addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
#color = ~pal(pop_est)
#) %>%
#addLegend("bottomright", pal = pal, values = ~pop_est,
#title = "Est. GDP (2010)",
#labFormat = labelFormat(prefix = "$"),
#opacity = 1
#)

#qpal <- colorQuantile("RdYlBu", dff$pop_est, n = 5)
#map %>%
#addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
#color = ~qpal(dff$pop_est)
#) %>%
#addLegend(pal = qpal, values = ~dff$pop_est, opacity = 1)
