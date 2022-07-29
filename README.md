
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mouseR

<!-- badges: start -->
<!-- badges: end -->

The goal of `mouseR` is to standardize the mouse experiment log sheets
used in the lab and to automatically generate reports. It contains two
functions `mouseEx()` that generates an Excel spreadsheet to input your
data into and `mouseRep()` which takes the filled in sheet and produces
figures and a report.

## Installation

You can install the development version of `mouseR` like so:

``` r
# install.packages("devtools")
devtools::install_github("JT-Collins/mouseR")

library('mouseR')
```

## Excel template

The `mouseEx()` function generates the Excel template and requires
several parameters:

`Spreadsheet_name` this can be anything but if left blank will default
to “Mouse_Experiment_todaysdate”  
`exp_length` The total planned length of experiment in days  
`group_name` The names of your experimental groups  
`mouse_num` The number of mice per group  
`spores` Whether or not your experimental bacteria produces spores,
takes either TRUE or FALSE

For example, to set up a sheet for a one week experiment looking at the
effect of dietary sugars and *C. difficile* with three groups of mice
containing 4, 7 and 9 mice you would enter the following:

``` r
mouseEx(
  Spreadsheet_name = "SugarExp",
  exp_length = 7,
  group_name  = c("Control", "Sugar_1", "Sugar_2"),
  mouse_num = c(4, 7, 9),
  spores = TRUE
)
```

The spreadsheet will then be generated and placed into your project
folder.

## Report

At the end of the experiment (or at any time before) you can generate
figures and a report by using the `mouseRep()` function. This function
takes the following variables:

`infile` The name of your excel spreadsheet, if its not in the same
folder as your project you’ll need to specify the full path.  
`mouse_num` The **total** number of mice at the start of the
experiment.  
`group_num` The number of experimental groups.  
`exp_length` The length in days.  
`spores` either `TRUE` or `FALSE` depending on whether your bug produces
spores (e.g., for *E. faecium*, set to ‘spores = FALSE’).

e.g.

``` r
mouseRep(
  infile = system.file("Example", "Mouse_Experiment_Example.xlsx", package = "mouseR"),
  mouse_num = 15,
  group_num = 3,
  exp_length = 16,
  spores = TRUE
)
```

or

``` r
mouseRep(
  infile = system.file("Example", "Mouse_Experiment_Example_Veg.xlsx", package = "mouseR"),
  mouse_num = 15,
  group_num = 3,
  exp_length = 16,
  spores = FALSE
)
```

Output files are essentially the same except for the CFUs section.

The report will be generated and saved in you project directory in a
folder called ‘report’. Several figures will also be output to a
‘figures’ folder.
