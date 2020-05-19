# #install the BiocManager suite
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("EBImage")

library(EBImage)

files <- list.files(path="LIST FILE PATH WHERE IMAGES ARE FOUND", pattern=".jpg", all.files=T, full.names=T, no.. = T)  

#make empty lists for the base files, BSF images, LSF images, and HSF images
imgFile <- list()
imgBSF <- list()
imgLSF <- list()
imgHSF <- list()

#set up LSF filtering
lsf <- makeBrush(31, shape = "gaussian", sigma = 5) #generate image weight weight and gaussian filter of width 5
lsf <- lsf/sum(lsf) #calculate lsf filtering cpf

#set up HSF filtering
hsf <- matrix(-1, nc = 3, nr = 3) #set the 3 x 3 kernel
hsf[2,2] <- 8.55 #change the center value of the kernel


#set up a loop to:
#(1) set all images to gray scale (serve as BSF images)
#(2) set all images to LSF
#(3) set all images to HSF

for (i in 1:length(files)) {
  #load all the images into the empty list imgFile
  imgFile[[i]] <- readImage(files[[i]])
  
  #set to grayscale (creates "BSF" images)
  imgBSF[[i]] <- imgFile[[i]]
  colorMode(imgBSF[[i]]) <- Grayscale
  
  #apply lsf filtering
  imgLSF[[i]] <- filter2(imgBSF[[i]], lsf)
  
  #apply hsf filtering
  imgHSF[[i]] <- filter2(imgBSF[[i]], hsf)
  
}


#view all BSF images
for (i in 1:length(imgBSF)) {
  displayBSF <- EBImage::display(imgBSF[[i]])
  print(displayBSF)
}


#view all LSF images
for (i in 1:length(imgLSF)) {
  displayLSF <- EBImage::display(imgLSF[[i]])
  print(displayLSF)
}


#view all hsf images
for (i in 1:length(imgHSF)) {
  displayHSF <- EBImage::display(imgHSF[[i]])
  print(displayHSF)
}


#write loops to save the image files (NOTE: all images will be saved to current working directory)

#BSF images
for (i in 1:length(imgBSF)) {
  #set as array
  imgBSFArray <- as.array(imgBSF)
  
  #define the file name for use in writeImage
  fileNameBSF <- paste("NAME FOR SAVING FILE", i, ".jpeg", sep = "")
  
  #save the images
  writeImage(imgBSFArray[[i]], files = fileNameBSF)
}


#LSF images
for (i in 1:length(imgLSF)) {
  #set as array
  imgLSFArray <- as.array(imgLSF)
  
  #define file name
  fileNameLSF <- paste("NAME FOR SAVING FILE", i, ".jpeg", sep = "")
  
  #save
  writeImage(imgLSFArray[[i]], files = fileNameLSF)
}


#HSF images
for (i in 1:length(imgHSF)) {
  #set as array
  imgHSFArray <- as.array(imgHSF)
  
  #define file name
  fileNameHSF <- paste("NAME FOR SAVING FILE", i, ".jpeg", sep = "")
  
  #save the images
  writeImage(imgHSFArray[[i]], files = fileNameHSF)
}

