
#
# data <- c("C:/Users/jtcoll06/Box/Lab Docs/R projects/mouseRddd/Mouse_Experiment_2022-07-05.xlsx")
# mouseNum <- 15
# exp_length <- 14
#
#
# rmarkdown::render(input = "C:/Users/jtcoll06/Box/Lab Docs/R projects/aesthetics/labPlots/R/mouseReport.Rmd",
#                       output_file = "test_out.html",
#                       params = list(data = data,
#                                     mouseNum = mouseNum,
#                                     exp_length = exp_length))
mreport <- function(infile,
                    outfile = paste0("MouseReport_",  Sys.Date(), ".html"),
                    mouseNum,
                    exp_length){

rmarkdown::render(
  input = paste0(system.file(package = "mouseR"), "/rmd/mouseReport.Rmd"),
  output_file = outfile,
  output_dir = paste0(rstudioapi::getActiveProject(), "/report"),
  knit_root_dir = rstudioapi::getActiveProject(),
  params = list(data = infile,
                mouseNum = mouseNum,
                exp_length = exp_length),
  encoding     = 'UTF-8'
)
}
