#--------------------------------------------------------------------------------------------------#
# Authors: Biswajit Ghoshal - 11910084, Dipanjan Biswas - 11910002, Shovan Bhattacharya - 11910061 #
#--------------------------------------------------------------------------------------------------#

shinyServer(function(input, output) {
  require(stringr)  
  Dataset <- reactive({
    if (is.null(input$file1)) {   # locate 'file1' from ui.R

                  return(NULL) } else {

      Data1 <- readLines(input$file1$datapath)
      Data1 =  str_replace_all(Data1, "<.*?>", "") # get rid of junk characters
      english_model = udpipe_load_model("./english-ud-2.0-170801.udpipe")  # english_model only needed
      x <- udpipe_annotate(english_model, x = Data1) %>% as.data.frame()
      x$sentence <- NULL
      print("Annotation done")
      return(x)
    }
  })

  output$clust_data = renderDataTable({Dataset()[1:100,]
#      out = data.frame(row_name = row.names(Dataset()),Dataset(),Cluster = clusters()$cluster)
#      out
  })
  output$download_data = downloadHandler(
      filename = function(){"abcd.csv"}, 
      content = function(fname){
          write.csv(Dataset(), fname)
      })

# Calc and render plot    
output$plot1 = renderPlot({ 
    library(wordcloud)

    all_nouns = Dataset() %>% subset(., upos %in% "NOUN")
    top_nouns = txt_freq(all_nouns$lemma)

    return(wordcloud(words = top_nouns$key, freq = top_nouns$freq, min.freq = 2, 
              max.words = 100, random.order = FALSE, colors = brewer.pal(6, "Dark2")))
        })

output$plot2 = renderPlot({ 
    library(wordcloud)

    all_verbs = Dataset() %>% subset(., upos %in% "VERB") 
    top_verbs = txt_freq(all_verbs$lemma)

    return(wordcloud(words = top_verbs$key, freq = top_verbs$freq, min.freq = 2, 
                     max.words = 100, random.order = FALSE, colors = brewer.pal(6, "Dark2")))
       })

output$wordnetwork = renderPlot({
    library(igraph)
    library(ggraph)
    library(ggplot2)
    if (is.null(input$somevalue)) {
        return(NULL) }
    else {
        data_cooc <- cooccurrence(x = subset(Dataset(), upos %in% input$somevalue),
        term = "lemma", group = c("doc_id", "paragraph_id", "sentence_id"))
    }
    wordnetwork <- head(data_cooc, 30)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    return(ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
#        theme_graph() + 
        theme(legend.position = "none") +
        labs(title = "Cooccurrences within 3 words distance", subtitle = paste(input$somevalue, collapse = ', ')))
    })
})