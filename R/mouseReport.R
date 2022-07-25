
mouseRep <- function(infile,
                    outfile = paste0("MouseReport_", Sys.Date(), ".html"),
                    mouse_num,
                    group_num,
                    exp_length,
                    spores = TRUE) {

    rmarkdown::render(input = paste0(system.file(package = "mouseR"), "/rmd/mouseReport.Rmd"),
                      output_file = outfile,
                      output_dir = paste0(rstudioapi::getActiveProject(),"/report"),
                      knit_root_dir = rstudioapi::getActiveProject(),
                      clean = TRUE,
                      params = list(data = infile,
                                    mouse_num = mouse_num,
                                    group_num = group_num,
                                    exp_length = exp_length,
                                    spores = spores))
}
