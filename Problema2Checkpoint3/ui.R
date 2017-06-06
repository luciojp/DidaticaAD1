library(shiny)
library(googleVis)

deputados <- read.csv("ano-atual.csv")
partidos <- unique(deputados$sgPartido)
deputadosUnicos <- unique(deputados$txNomeParlamentar)


shinyUI(fluidPage(
  
  titlePanel("Divergência política entre partidos a partir das revistas assinadas"),
  "O intuito desta análise é observarmos a diferença do posicionamento político entre os partidos, a partir das revistas que os nossos deputados federais assinam.
  Para facilitar a comparação, utilizamos como referência o PT. Para saber o quão o partido em questão está alinhado politicamente com o PT basta
  observar a disposição do gráfico de barras. Quanto mais as barras maiores estiverem na parte de baixo do gráfico, mais alinhado aquele partido
  está ao PT. E também podemos comparar as assinaturas de um deputado em específico com algum partido.
                                                                            
  
                                                                                                                                               ",
  sidebarLayout(
    sidebarPanel(
      
      selectInput("Partido",
                  "Selecione o partido",
                  choices = sort(as.character(partidos)), 
                  selected = "PT"),
      
      selectInput("Nome",
                  "Selecione o deputado",
                  choices = sort(as.character(deputadosUnicos)), 
                  selected = "LUIZ COUTO")
      
    ),
    mainPanel(
      plotOutput("plotPartido"),
      plotOutput("plotPolitico")
    )
  ))
)


