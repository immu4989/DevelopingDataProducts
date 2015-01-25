library(SnowballC)
library(stringr)
library(tm)
library(RWeka)
#To count and sort
library(plyr) 


shinyServer(function(input, output,sessoin) {
  
  h <- reactive({
    return(input$headline)
  })
    
        
  matchSubject <- function (x)
  {
    #####################
    ### economiaHeads ###
    #####################
    economiaHeads <- read.csv("economiaHeads.txt", header=FALSE)
    colnames(economiaHeads) <- c("bigrams", "economia")
    economiaHeads$bigrams <- as.character(economiaHeads$bigrams)
    economiaHeads$economia <- as.integer(economiaHeads$economia)
    
    ##################
    ### sportHeads ###
    ##################
    sportHeads <- read.csv("sportHeads.txt", header=FALSE)
    colnames(sportHeads) <- c("bigrams", "economia")
    sportHeads$bigrams <- as.character(sportHeads$bigrams)
    sportHeads$economia <- as.integer(sportHeads$economia)
    head(sportHeads$bigrams,5)
    
    ####################
    ### cultureHeads ###
    ####################
    cultureHeads <- read.csv("cultureHeads.txt", header=FALSE)
    colnames(cultureHeads) <- c("bigrams", "economia")
    cultureHeads$bigrams <- as.character(cultureHeads$bigrams)
    cultureHeads$economia <- as.integer(cultureHeads$economia)
    head(sportHeads$bigrams,5)
    
    numberItemsEco <- length(economiaHeads$economia)
    numberItemsSpo <- length(sportHeads$economia)
    numberItemsCul <- length(cultureHeads$economia)
    
    ##################################
    ### Creating Ngrams from input ###
    ##################################
    
    headline <- Corpus(VectorSource(input$headline))
    #To solve steaming problem in tolower
    headline <- tm_map(headline, content_transformer(tolower))
    headline <- tm_map(headline, removePunctuation)
    headline <- tm_map(headline , stripWhitespace)
    headline <- tm_map(headline, removeWords, stopwords("italian")) 
    headline <- tm_map(headline, stemDocument, language = "italian") 
    
    # Bigrams
    BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
    inputNgrams <- BigramTokenizer(headline)
    
    #The ngrams starts in position 5 untio the position of 'meta ='
    inputNgrams <- inputNgrams[5:(which(inputNgrams == 'meta =')-2)]
    inputNgrams <- str_replace_all(inputNgrams,"\\s+","_")
    #####################################
    ### Match Ngrams in economiaHeads ###
    #####################################
    ratingEco = 0
    aux = 0
    for (i in 1:length(inputNgrams))
    {
      if (is.na(as.vector(table(economiaHeads$bigrams == inputNgrams[i])[2])))
      {
        aux = 0
        ratingEco <- ratingEco + aux
      } else {
        aux = as.vector(table(economiaHeads$bigrams == inputNgrams[i])[2])
        ratingEco <- ratingEco + aux
      }
    }  
    ratingEco <- ratingEco/numberItemsEco
    
    ##################################
    ### Match Ngrams in sportHeads ###
    ##################################
    ratingSpo = 0
    aux = 0
    for (i in 1:length(inputNgrams))
    {
      if (is.na(as.vector(table(sportHeads$bigrams == inputNgrams[i])[2])))
      {
        aux = 0
        ratingSpo <- ratingSpo + aux
      } else {
        aux = as.vector(table(sportHeads$bigrams == inputNgrams[i])[2])
        ratingSpo <- ratingSpo + aux
      }
    }  
    ratingSpo <- ratingSpo/numberItemsSpo
    
    ####################################
    ### Match Ngrams in cultureHeads ###
    ####################################
    ratingCul = 0
    aux = 0
    for (i in 1:length(inputNgrams))
    {
      if (is.na(as.vector(table(cultureHeads$bigrams == inputNgrams[i])[2])))
      {
        aux = 0
        ratingCul <- ratingCul + aux
      } else {
        aux = as.vector(table(cultureHeads$bigrams == inputNgrams[i])[2])
        ratingCul <- ratingCul + aux
      }
    }  
    ratingCul <- ratingCul/numberItemsCul
    
    
    
    ##################################
    ### Setting the classification ###
    ##################################
    if ((ratingEco > ratingSpo) & (ratingEco > ratingCul))
    {
      return('about Economia')
    }else if ((ratingSpo > ratingCul) & (ratingSpo > ratingEco)){
      return('about Sports' )
    }else{
      return('about Culture'  )
    }
  }
  
  
  output$headline <- renderText({hi <- h()})
  output$categorization <- renderText({
    matchSubject(input$headline)
    })
  
  
})
