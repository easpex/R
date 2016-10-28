
## below is the function code which receives folder and changes specific strings in the files in all subfolders
jsRename<-function(path ="") {
  ## if there're no more subfolders then apply the function to the files
  if(length(list.dirs(path = path, recursive = FALSE)) == 0) {
    # loop to rename files based on the patterns defined below
    for(i in 1:length(list.files(path = path))) {
      file<-sprintf("%s\\%s", path, list.files(path = path)[i])
      x<-gsub(pattern = "joey.kosheryashin.com", replacement = "tout.Mabubot.com", fixed = TRUE, x = readChar(file, file.info(file)$size))
      x<-gsub(pattern = "xmax.kosheryashin.com", replacement = "une.Mabubot.com", fixed = TRUE, x = x)
      x<-gsub(pattern = "maximus.kosheryashin.com", replacement = "ce.Mabubot.com", fixed = TRUE, x = x)
      x<-gsub(pattern = "amalek.kosheryashin.com", replacement = "que.Mabubot.com", fixed = TRUE, x = x)
      x<-gsub(pattern = "j.ToWambleesha.com", replacement = "ibibib2.com", fixed = TRUE, x = x)
      x<-gsub(pattern = "https://deltacdn12.net/Penalty_Short.mp4", replacement = "https://une.Mabubot.com/isvid-creative/Penalty_Short.mp4", fixed = TRUE, x = x)
      x<-gsub(pattern = "https://deltacdn12.net/pics/general-news.tv/newstv-banners-300x250.png", replacement = "https://une.Mabubot.com/isvid-creative/newstv-banners-300x250.png", fixed = TRUE, x = x)
      
      ## write the new good file with all the changes to the same file name
      write(x = x,file = sprintf("%s\\%s", path, list.files(path = path)[i]))
      
      ## remove the temp file
      rm(x)
    }
    
  } else {
    
    ## if there're no files in the folder and then go to other subfolders
    for(i in 1:length(list.dirs(path = path, recursive = FALSE))) {
      ## print the subfolders
      print(sprintf("%s\\%s", path, list.files(path = path)[i]))
      
      ## go inside each subfolder and repeat all the above actions
      jsRename(path = sprintf("%s\\%s", path, list.files(path = path)[i]))
    }
  }
}

## example path (make sure to separate folder by 2 slashes!!!)
jsRename(path = "C:\\Documents\\Reports\\jsTemplates")

