
options("scipen"=100)


for(i in 1:length(ls())) {
  name<-as.character(ls()[i])
  print(sprintf("name=%s|size=%s", ls()[i], object.size(get(name))/1000000))
  
  
}


            