
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mouseR

<!-- badges: start -->
<!-- badges: end -->

The goal of `mouseR` is to standardize the mouse experiment log sheets
used in the lab and to automatically generate reports. It contains two
functions `mouseEx()` that generates an Excel spreadsheet to add your
data and `mreport()` which takes the filled in sheet and produces
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
to “Mouse_Experiment_todaysdate” `exp_length` The total planned length
of experiment in days `group_name` The names of your groups `mouse_num`
The number of mice per group

So to set up a sheet for a one week experiment with three groups of mice
containing 4, 7 and 9 mice you would enter the following:

``` r
mouseEx(Spreadsheet_name = "SugarExp_070622",
        exp_length = 7,
        group_name  = c("Control", "Sucrose", "Fructose"),
        mouse_num = c(4, 7, 9))
```

The spreadsheet will then be generated and placed into your project
folder.

## Report

At the end of the experiment (or at any time before) you can generate
figures and a report by using the `mreport()` function.

``` r
mreport(infile = "SugarExp_070622.xlxs",
        mouseNum = 20,
        exp_length = 7)
```

Note that the mouse number in this case is the total number of mice.
