#--------------------------------------------------------------------------------------------------#
# Authors: Biswajit Ghoshal - 11910084, Dipanjan Biswas - 11910002, Shovan Bhattacharya - 11910061 #
#--------------------------------------------------------------------------------------------------#

library("shiny")
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)

shinyUI(
  fluidPage(
  
    titlePanel("UDPipe NLP Workflow"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("file1", "Upload plain-text (.txt) data file"),
              
              checkboxGroupInput("somevalue", 
                                 h3("Checkbox group"), 
                                 choices = list("Adjective (ADJ)" = "ADJ", 
                                                "Noun (NOUN)" = "NOUN", 
                                                "Proper Noun (PROPN)" = "PROPN",
                                                "Adverb (ADV)" = "ADV",
                                                "Verb (VERB)" = "VERB"),
                                 selected = c("ADJ", "NOUN", "PROPN")) ),   # end of sidebar panel

      mainPanel(
      
        tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input")),
                               p("This app supports only text (.txt) data file. The .txt data file should have no other language than plain English language characters. Also, if you are running it from RStudio, it would require the English udpipe file, english-ud-2.0-170801.udpipe to be in the default folder. However, if you are running it from Github, using runGitHub(), the udpipe-file would be taken from the repository.",align="justify"),
                               p("Please refer to the link below for a sample text file."),
                               a(href="https://raw.githubusercontent.com/sudhir-voleti/sample-data-sets/master/text%20analysis%20data/amazon%20nokia%20lumia%20reviews.txt"
                                 ,"Sample text data input file"),   
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on the "Browse..." button under', 
                                 span(strong("Upload plain-text (.txt) data")),
                                 'and select and uppload the data file. After file-uploading is done, click on any of the 3 other tabs to see the result. Based on the file-size, it may take 1 or 2 minutes to generate the output in the tab.'),
                               p('The ', span(strong("Annotated Doc")), ' tab will display the first 100 rows of the annotated document produced by UDPipe from the uploaded text-file.  From the bottom of that tab, you can also', span(strong("download")), ' the entire annotated doc as a CSV file (with a file-name given by you) onto your local machine.'),
                               p('The ', span(strong("Wordclouds")), ' tab gives the wordclouds of the Nouns and verbs of the uploaded text document.'),
                               p('While checking the ',span(strong("N/w plot")), ' You can also change the default option settings in the', span(strong("Checkbox group")), ' for UPOS (Universal parts-of-speech) tags, based on which the co-occurrences plot would change and get updated.')),

                       tabPanel("Annotated Doc", dataTableOutput(head('clust_data',100)),
                               downloadButton("download_data", "Download")),

                       tabPanel("Wordclouds",plotOutput('plot1', width  = "500px", height = "350px"),
                                plotOutput('plot2', width  = "500px", height = "350px")),   # Nouns & Verbs wordclouds, respectively
                    
                      tabPanel("N/w plot", plotOutput('wordnetwork'))    # of top 30 co-occurrences

              ) # end of tabset panel
           )# end of main panel
#        ) # end of sidebar panel
     ) # end of sidebar layout
  )  # end if fluid page
) # end of UI
  
