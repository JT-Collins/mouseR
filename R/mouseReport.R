
mreport <- function(infile,
                    outfile = paste0("MouseReport_", Sys.Date(), ".html"),
                    mouseNum,
                    groupNum,
                    exp_length) {

    rmarkdown::render(input = paste0(system.file(package = "mouseR"), "/rmd/mouseReport.Rmd"),
                      output_file = outfile,
                      output_dir = paste0(rstudioapi::getActiveProject(),"/report"),
                      knit_root_dir = rstudioapi::getActiveProject(),
                      clean = TRUE,
                      params = list(data = infile,
                                    mouseNum = mouseNum,
                                    groupNum = groupNum,
                                    exp_length = exp_length))
}
