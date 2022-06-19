# Para cada corpus y versión, cambiar la ruta, nºficheros SS, el nombre de corpus, version y del archivo final
setwd("Dropbox/estudio_parametros/corpora/teatro-sgo-copia/annotation")
library(stylo)

pasadas = 10
df = data.frame()
total_ficheros = 15 # nº ficheros en el secondary_set
list.mfws = c(100,500,1000,2000,3000,4000,5000,7000,10000)
list.features = c("w", "c")
list.ngrams = c(1,2,3,4)
list.distances = c("dist.delta", "dist.wurzburg", "dist.eder", "dist.minmax")


for (x in 1:pasadas) { # bucle de pasadas
  do.call(file.remove, list(list.files("./primary_set", full.names = TRUE)))
  do.call(file.remove, list(list.files("./secondary_set", full.names = TRUE)))
  file.copy(file.path("./directorio_base", list.files("./directorio_base")), to = "./primary_set", overwrite = TRUE)
  

#Coger lista de elegidos para secondary_set

contador = 0
nueva_lista = c()
lista_primerset = list.files("./primary_set")
for(i in 1:length(lista_primerset)){
  random = round(runif(1, min = 1, max = length(lista_primerset)), digits =0)
  print(random)
  autor = strsplit(lista_primerset[random], "_")[[1]]
  #print("autor")
  #print(autor[1])
  encontrado = 0
  if(length(nueva_lista)>0) {
    for (j in 1:length(nueva_lista)) {
      k = nueva_lista[j]
      autor2 = strsplit(lista_primerset[k], "_")[[1]]
      #print(autor2[1])
      if (setequal(autor[1], autor2[1]) == TRUE | random == nueva_lista[j]) { 
        #print("encontrado")
        encontrado=1
        break
      }
    }
  }
  if (encontrado ==0) {
    contador = contador+1
    nueva_lista[contador] <- random
    
  }
  if(length(nueva_lista)==total_ficheros) {  #
    break
  }
}
nueva_lista
sort(nueva_lista)

# Mover los archivos elegidos al secondary_set
for(i in 1:length(nueva_lista)){
  k = nueva_lista[i]
  Desde = paste("./primary_set/", lista_primerset[k], sep = "")
  Hasta = paste("./secondary_set/", lista_primerset[k], sep = "")
  file.copy(Desde, Hasta)
  file.remove(Desde)
}


for(i in 1:length(list.mfws)){
  for(j in 1:length(list.features)){
    for(k in 1:length(list.ngrams)){
      for(l in 1:length(list.distances)){
        print(list.mfws[i])
        print(list.features[j])
        print(list.ngrams[k])
        print(list.distances[l])
        if ((list.features[j] == "w" & k !=1) || (list.features[j] == "c" & k ==1)) {
          next
        }
        
        result = classify(gui = FALSE, corpus.lang = "Spanish", classification.method= "delta" , distance.measure= list.distances[l], mfw.min = list.mfws[i], mfw.max = list.mfws[i], analyzed.features = list.features[j], ngram.size = list.ngrams[k], encoding = "UTF-8")
        nsuccess = result$success.rate
        attributes(nsuccess)
        print(result)
    df <- rbind(df,data.frame(corpus = "Teatro-SdO", version = "annotation", mfw=list.mfws[i],features=list.features[j],ngrams=list.ngrams[k], distances = list.distances[l], success = nsuccess[1], iterations = x, media = 0))
        
      }
    }
  }
}
}
df
df2 = df[order(df$distances, df$mfw, df$features, df$ngrams, decreasing = FALSE),]

df2

media = 0
total = 0
#print(nrow(df2))
for (i in 1:nrow(df2)){ 
  #print(df2$iterations[i])
  total = total + df2$success[i]
  #print(total)
 if (df2$iterations[i] == 10) {
   media = total/10
  total = 0
   df2$media[i] = media 
 }
}
df2
df3 = data.frame()
j = 1
for (i in 1:nrow(df2)){ 
  
  if (df2$iterations[i] == 10) {
    df3 <- rbind(df3, data.frame(corpus = df2$corpus[i], version = df2$version[i], mfw = df2$mfw[i], features = df2$features[i], ngrams = df2$ngrams[i], distances = df2$distances[i], media = df2$media[i]))
  }
}
df3
df4 = df3[order(df3$media, decreasing = TRUE),]
write.csv(cbind(df4), file = "Results_teatroSdO-annotation_corregido.csv")

