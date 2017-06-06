library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
theme_set(theme_bw())

lerDados <- function(arquivo){
  dados = read.csv(arquivo, stringsAsFactors = FALSE, encoding='UTF-8')
  require("dplyr", warn.conflicts = FALSE)
  return(dados)
}


lerDados2 <- function(arquivo = "ano-atual.csv"){
  require("dplyr", warn.conflicts = FALSE)
  dados = read.csv(arquivo, stringsAsFactors = FALSE, encoding="UTF-8")
  dados = dados %>% 
    mutate_each(funs(as.factor), sgPartido, txtDescricao, txNomeParlamentar)
  return(dados)
} 

dados = lerDados2()
dados = dados %>% filter(txtDescricao %in% c("ASSINATURA DE PUBLICAÇÕES"))%>% select(sgPartido, txtFornecedor, txNomeParlamentar)



shinyServer(function(input, output) {
  
    output$plotPartido <- renderPlot({
      
    partidoFiltrado = dados %>% filter(sgPartido %in% input$Partido) %>%
      group_by(sgPartido) %>% count(txtFornecedor) %>% ungroup()
    
    ordenado = dados %>% filter(sgPartido == "PT") %>% count(txtFornecedor) %>% arrange(-n)
    
    partidoFiltrado$txtFornecedor = factor(partidoFiltrado$txtFornecedor, 
                                  levels = ordenado$txtFornecedor)
    
    ggplot(partidoFiltrado, aes(x = txtFornecedor, y = n)) +
      geom_bar(stat = "identity") + 
      coord_flip() + 
      xlab("Fornecedor") +
      ylab("Número de assinaturas")
   
  })
    
    
    output$plotPolitico <- renderPlot({
      
      politicoEscolhido = dados %>% filter(txNomeParlamentar %in% input$Nome) %>% count(txtFornecedor)
        
      
      ggplot(politicoEscolhido, aes(x = txtFornecedor, y = n)) +
        geom_bar(stat = "identity") +
        coord_flip() +
        xlab("Fornecedor")+
        ylab("Número de assinaturas")
      
    })
  
    
  
})
