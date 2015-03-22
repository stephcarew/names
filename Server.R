library(shiny)

full_data <- read.csv("full_data.csv")
survival_prob <- read.csv("all_LT.csv")
#sort the survival probablitity descending by year
survival_prob <- apply(survival_prob, 2, rev)
years = 1916:2013

#return the data needed to make the plot
plotData <- function (first_name){ 
  input_name <- tolower(first_name)
    input_name <- paste(toupper(substring(input_name,1,1)),(substring(input_name,2)),sep="")
   
    #extract the row (not including the name) that matches the inputted name
    data_for_name <- full_data[full_data$name == input_name, 2:99]
    data_for_name <- as.data.frame(t(data_for_name))
    names(data_for_name) <- "total_born"
    data_for_name$exp_number_living <- data_for_name$total_born *survival_prob[,2]
    return(data_for_name)
}

#check to see if we have a match
match_name <- function(input) {
  input_name <- tolower(input)
  input_name <- paste(toupper(substring(input_name,1,1)),(substring(input_name,2)),sep="")
  
  if (is.na(match(input_name, full_data$name))) {
    "Sorry, we don't have enough data on that name. Try again with something more common!"
  } else if (input_name == "") { 
    ""
  } else {
    "
This plot shows the total number of people born with a particular first name in the USA, 
               as well as the expected number that were born in each year that are living today. 
               Birth data was obtained from the US Social Security website (http://www.ssa.gov/OACT/babynames/limits.html)
               and the number alive today was estimated from life tables from the Centers for Disease Control and Prevention (http://www.cdc.gov/nchs/data/nvsr/nvsr63/nvsr63_07.pdf)."
  }
}

shinyServer(
  function(input, output) {
    output$error <- renderText({ 
      input$submit
      if (input$submit == 0)
        return()
      match_name(isolate(input$name))
    })
   
    output$dist <- renderPlot({ 
      input$submit
      if (input$submit == 0)
        return()
      data_to_plot<-plotData(isolate(input$name))
    plot(years, data_to_plot$exp_number_living, type = "l", col = "blue", xlab = "Year of birth", ylab= "",ylim = range(0:max(data_to_plot$total_born)*1.5))
    par(new=T)
    plot(years, data_to_plot$total_born, type = "l", col = "red", axes = F, ylim = range(0:max(data_to_plot$total_born)*1.5), xlab = "", ylab = "")
    par(new=T)
  legend("topright", c("Number born","Expected number living today"),lty=c(1,1),lwd=c(1,1),col=c("red","blue"))

    })

  

  }
)