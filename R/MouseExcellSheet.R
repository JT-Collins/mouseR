


mouseEx <- function(Spreadsheet_name = paste0("Mouse_Experiment_", Sys.Date()),
                    exp_length = 14,
                    group_name = c("Control", "Group A", "Group B"),
                    mouse_num = c(5, 5, 5)) {

if(!require(pacman))install.packages("pacman")

pacman::p_load('openxlsx')


# Variables ---------------------------------------------------------------

group_num <- length(group_name)
total_mice <- sum(mouse_num)

mnum <- c() # Mouse numbers for different sized groups
for (i in mouse_num){
  mnum <- c(mnum, 1:i)
}


# Image -------------------------------------------------------------------

# read in image from package
img <- system.file("figures/clinScore.png", package="mouseR")



# Excel Column names ------------------------------------------------------
# Generates a list of excel column names A -> ZZ

all <- expand.grid(LETTERS, LETTERS)
all <- all[order(all$Var1,all$Var2),]
excel_col <- c(LETTERS, do.call('paste0',all))


# Generate Workbook -------------------------------------------------------


wb <- createWorkbook()
options("openxlsx.borderColour" = "#c0c0c0")
options("openxlsx.borderStyle" = "thin")
options("openxlsx.numFmt" = "0.00")

addWorksheet(wb, "Mouse Weights")
addWorksheet(wb, "Clinical Score")
addWorksheet(wb, "Stool Weights")
addWorksheet(wb, "Survival")
insertImage(wb, "Clinical Score", img, startRow = 2, startCol = 8, width = 8.19, height = 2.13, units = "in") # add our Clinical scores table


weight_names <- c("Group", "Mouse", "Min Weight","Sex", 0:exp_length) #col names for weights page
weight_names2 <- c("Group", "Mouse", "Weight (mg)", 0:exp_length) #col names for stool weights page
surv_names <- c("Group", "Time", "Dead", "Alive", "1-(dead/alive)", "S(t)")
surv_names2 <- c("Group", "Time", "S(t)", "Order")

weight_dat <- data.frame(
  x = rep(group_name,times = mouse_num),
  y = c(paste0(rep(group_name,times = mouse_num), "_", mnum)),
  z = paste0("E", 1:total_mice + 2L, "*0.8")
) # The mouse groups and IDs

class(weight_dat$z) <- c(class(weight_dat$z), "formula")

stool_dat <- data.frame(
  x = rep(group_name,times = mouse_num*3),
  y = rep(c(paste0(rep(group_name,times = mouse_num), "_", mnum)), each = 3),
  z = rep(c("Tube", "Total", "Stool"), times = total_mice)
)

clin_dat <- data.frame(

  Day = rep(1:exp_length, each =  total_mice*5),
  Group = rep(rep(group_name,times = mouse_num*5), times = exp_length),
  Mouse = rep(rep(c(paste0(rep(group_name,times = mouse_num), "_", mnum)), each = 5), times = exp_length),
  Catagory = rep(c("Activity", "Posture", "Coat", "Diarrhea", "Eyes_Nose"), times = total_mice*exp_length),
  Score = NA

)

weight_percent <- data.frame(
  A = NA,
  B = NA,
  C = rep(group_name,times = mouse_num),
  D = c(paste0(rep(group_name,times = mouse_num), "_", mnum)),
  E = paste(paste(paste0("E", 1:total_mice + 2L),
                  paste0("$E", 1:total_mice + 2L), sep = " / "), " * 100")

) # The mouse groups, IDs, and formula for percent mouse weight

# summary stats
weight_sum <- data.frame(
  a = NA,
  b = NA,
  c = c("Group",rep(group_name, each = 2)),
  d = c("Summary", rep(c("Mean", "SD"),group_num))

)

class(weight_percent$E) <- c(class(weight_percent$E), "formula")

surv_dat <- data.frame(
  x = rep(group_name,each = (exp_length+1)),
  y = rep(0:exp_length, group_num)

)




# Style -------------------------------------------------------------------

bg_colours <- c("#FFD9FA", "#FFEB97","#E5F0DA",  "#E5D8D3", "#E4DDED", "#FBDEE1", "#DCF0F8", "#FCDACA"  )



BoldCtrUnder <- createStyle(
  fontSize = 11, textDecoration = "bold", halign = "center",
  valign = "center",  border = "bottom", borderStyle = "double"
)

BoldCtr <- createStyle(
  fontSize = 11, textDecoration = "bold", halign = "center",
  valign = "center"
)


Ctr <- createStyle(
  fontSize = 11, halign = "center",  valign = "center" , numFmt = "0"
)

num_style <- createStyle(numFmt = "0.00")

low_weight <- createStyle(fontColour = "#9C0006", bgFill = "#FFC7CE")

addStyle(wb, sheet = "Mouse Weights", style = BoldCtrUnder,
         rows = 2, cols = 1:(exp_length + 5), gridExpand = FALSE, stack = FALSE) #Bold Underline headers
addStyle(wb, sheet = "Mouse Weights", style = BoldCtrUnder,
         rows = 6 + total_mice, cols = 3:(exp_length + 5), gridExpand = FALSE, stack = FALSE) #Bold Underline headers

addStyle(wb, sheet = "Mouse Weights", style = BoldCtr,
         rows = 1, cols = 5, gridExpand = FALSE, stack = FALSE) #Bold Ctr "Days"
addStyle(wb, sheet = "Mouse Weights", style = BoldCtr,
         rows = 5 + total_mice, cols = 5, gridExpand = FALSE, stack = FALSE) #Bold Ctr "Days"

addStyle(wb, sheet = "Mouse Weights", style = Ctr,
         rows = 3:((total_mice)+2), cols = 1:4, gridExpand = T, stack = TRUE)
addStyle(wb, sheet = "Mouse Weights", style = Ctr,
         rows = (7 + total_mice):(((total_mice)*2)+6), cols = 1:4, gridExpand = T, stack = TRUE)

addStyle(wb, sheet = "Stool Weights", style = BoldCtrUnder,
         rows = 2, cols = 1:(exp_length + 3), gridExpand = FALSE, stack = FALSE) #Bold Underline headers

addStyle(wb, sheet = "Mouse Weights", style = BoldCtr,
         rows = (((total_mice)*2)+9), cols = 3:4, gridExpand = T, stack = TRUE)

# Clin Score style

addStyle(wb, sheet = "Clinical Score", style = BoldCtrUnder,
         rows = 1, cols = 1:5, gridExpand = FALSE, stack = FALSE) #Bold Underline headers

addStyle(wb, sheet = "Clinical Score", style = Ctr,
         rows = 2:((total_mice) * 5 * exp_length), cols = 1:3, gridExpand = T, stack = TRUE)

# Stool weight style

addStyle(wb, sheet = "Stool Weights", style = BoldCtr,
         rows = 1, cols = 4, gridExpand = FALSE, stack = FALSE) #Bold Ctr "Mouse Stool Weight"
addStyle(wb, sheet = "Stool Weights", style = Ctr,
         rows = 3:((total_mice)+2), cols = 1:2, gridExpand = T, stack = TRUE)

# Survival style
addStyle(wb, sheet = "Survival", style = Ctr,
         rows = 2:((exp_length*(group_num+2))), cols = 1:100, gridExpand = T, stack = TRUE)



# Write data to workbook --------------------------------------------------

# Raw weights -------------------------------------------------------------


#writeData(wb, "Mouse Weights", x = "Add daily mouse weights below", startRow = 1, startCol = 1, colNames = FALSE)
writeData(wb, "Mouse Weights", x = "Mouse Weight", startRow = 1, startCol = 5, colNames = FALSE) #write "Days" and merge cells
mergeCells(wb, "Mouse Weights", cols = 5:(exp_length+5), rows = 1) #
writeData(wb, "Mouse Weights", x = t(weight_names), startRow = 2,colNames = FALSE) # Generate column names
writeData(wb, "Mouse Weights", x = weight_dat, startRow = 3,colNames = FALSE) # Fill in group and mouse names

current = 3
for (g in 1:group_num){

  mergeCells(wb, "Mouse Weights", cols = 1,
             rows = current :((current + mouse_num[g])-1)) # Merge group name cells with loop
  current = current + mouse_num[g]
}

# add some colour to distinguish the groups
current = 3
for (c in 1:group_num)
{
  new_bg <- createStyle(fgFill = bg_colours[c], border = "TopBottomLeftRight")
  addStyle(wb, "Mouse Weights", new_bg  ,cols = 1:(5+exp_length),
           rows = current :((current + mouse_num[c])-1) ,gridExpand = T, stack = T)
  current = current + mouse_num[c]
}


# Percent weights ---------------------------------------------------------

writeData(wb, "Mouse Weights", x = "Percent weight gain/loss", startRow = (total_mice)+5,
          startCol = 5, colNames = FALSE) # write "Percent weight gain/loss" and merge cells
mergeCells(wb, "Mouse Weights", cols = 5:(exp_length+5), rows = (total_mice)+5) # merge

writeData(wb, "Mouse Weights", x = t(weight_names[! weight_names %in% c("Min Weight", "Sex")]),
          startRow = (total_mice)+6, startCol = 3, colNames = FALSE) # Generate column names
writeData(wb, "Mouse Weights", x = weight_percent, startRow = (total_mice)+7,colNames = FALSE) # Fill in group and mouse names

# wow, this code is horrible! But, it works...

current = 7 + total_mice
for (g in 1:group_num)
{
  mergeCells(wb, "Mouse Weights", cols = 3,
             rows = current :((current + mouse_num[g])-1)) # Merge group name cells with loop
  current = current + mouse_num[g]
}

# add some colour to distinguish the groups
current = 7 + total_mice
for (c in 1:group_num)
{
  new_bg <- createStyle(fgFill = bg_colours[c], border = "TopBottomLeftRight")
  addStyle(wb, "Mouse Weights", new_bg  ,cols = 3:(5+exp_length),
           rows = current :((current + mouse_num[c])-1), gridExpand = T, stack = T)
  current = current + mouse_num[c]
}



# Add the percent weight formula for all relevant cells
for (d in 6:(exp_length+5)){
  current_col = excel_col[d]
  for (m in (7+total_mice):(6+(total_mice*2))){
    current_mouse = m - (total_mice+4)
    writeFormula(wb, 1, x = paste0(current_col,current_mouse,"/E",current_mouse,"*100" ), startCol = d, startRow = m)

  }
}

# Clinical Score ----------------------------------------------------------

writeData(wb, "Clinical Score", x = clin_dat, startRow = 1,colNames = TRUE) # Fill in group and mouse names


# # Merge "Group"
# for (g in seq(2, ((total_mice*5)*exp_length), by= (total_mice*5)))
# {
#   mergeCells(wb, "Clinical Score", cols = 2,
#              rows = g:(g+4)
#   ) # Merge mouse name cells with loop
# }

# Merge "Mouse"
for (g in seq(2, ((total_mice*5)*exp_length), by= 5))
{
  mergeCells(wb, "Clinical Score", cols = 3,
             rows = g:(g+4)
  ) # Merge mouse name cells with loop
}

# add some colour to distinguish the groups
current = 2
for (x in 1:exp_length) {
  for (c in 1:group_num)
  {
    new_bg <-
      createStyle(fgFill = bg_colours[c],
                  border = "TopBottomLeftRight",
                  numFmt = "0")

    addStyle(
      wb,
      "Clinical Score",
      new_bg  ,
      cols = 1:5,
      rows = current:(current + (mouse_num[c] * 5) - 1) ,
      gridExpand = T,
      stack = T
    )

    current = current + mouse_num[c] * 5
  }
}

# Stool weights -----------------------------------------------------------

# writeData(wb, "Stool Weights", x = "Add mouse stool weight below", startRow = 1, startCol = 1, colNames = FALSE)
writeData(wb, "Stool Weights", x = "Mouse Stool Weight", startRow = 1, startCol = 4, colNames = FALSE) #write "Mouse Stool Weight"
mergeCells(wb, "Stool Weights", cols = 4:(exp_length+4), rows = 1) # merge cells
writeData(wb, "Stool Weights", x = t(weight_names2), startRow = 2,colNames = FALSE) # Generate column names
writeData(wb, "Stool Weights", x = stool_dat, startRow = 3,colNames = FALSE) # Fill in group and mouse names

# add simple formula for stool weight minus tube weight
for (c in seq(4, exp_length+4)){
  for (r in seq(5, ((total_mice*3)+3), by= 3)){
    writeFormula(wb, "Stool Weights", x = paste0("=", excel_col[c], r-1, "-",excel_col[c], r-2 ), xy= c(c,r))
  }
}


# Merge "Group"
current = 3
for (g in 1:group_num)
{
  mergeCells(wb, "Stool Weights", cols = 1,
             rows = current :((current + (mouse_num[g])*3)-1)) # Merge group name cells with loop
  current = current + (mouse_num[g] * 3)
}

# Merge "Mouse"
for (g in seq(3, (total_mice*3), by= 3))
{
  mergeCells(wb, "Stool Weights", cols = 2,
             rows = g:(g+2)
  ) # Merge group name cells with loop
}


# add some colour to distinguish the groups
current = 3
for (c in 1:group_num)
{
  new_bg <- createStyle(fgFill = bg_colours[c], border = "TopBottomLeftRight", halign = "center", valign = "center" )
  addStyle(wb, "Stool Weights", new_bg  ,cols = 1:(4+exp_length),
           rows = current :((current + (mouse_num[c])*3)-1), gridExpand = T, stack = T)
  current = current + (mouse_num[c] * 3)
}


# Survival ----------------------------------------------------------------

writeData(wb, "Survival", x = t(surv_names), startRow = 1,colNames = FALSE) # Generate column names

# Loop to add separate surv data for each group
for(x in seq(8,((5*group_num)+7),5)) {
  writeData(wb, "Survival", x = t(surv_names2), startRow = 1,startCol = x, colNames = FALSE)
}

#First data table
writeData(wb, "Survival", x = surv_dat[ , c("x", "y")] , startRow = 2,colNames = FALSE) # Fill in group and mouse names

y <- 1
for (x in seq(2, ((exp_length+1)*group_num),exp_length+1)){

  writeData(wb, "Survival", x = 0 , startCol = 3, startRow = x,colNames = FALSE) # Fill in first dead cell
  writeData(wb, "Survival", x = mouse_num[y] , startCol = 4, startRow = x,colNames = FALSE) # Fill in first alive cell
  writeData(wb, "Survival", x = 1 , startCol = 6, startRow = x,colNames = FALSE) # Fill in first S(t) cell
y = y + 1
  }


# Add formula for 1-(dead/alive) and S(t)
x <- 2:((exp_length+1)*(group_num)+1)  # all rows in experiment
y <- x[seq(1, length(x), exp_length+1)] # Rows that should not have equation e.g. first row of each group
setdiff(x, y)

for (m in setdiff(x, y)){
  writeFormula(wb, "Survival", x = paste0("=1-C", m, "/D",m), xy= c(5,m))
  writeFormula(wb, "Survival", x = paste0("=D", m-1, "-C",m-1), xy= c(4,m))
  writeFormula(wb, "Survival", x = paste0("=F", m-1, "*E",m), xy= c(6,m))
}

# add some colour to distinguish the groups
for (c in 1:group_num)
{
  new_bg <-
    createStyle(fgFill = bg_colours[c],
                border = "TopBottomLeftRight",
                numFmt = "0")
  addStyle(
    wb,
    "Survival",
    new_bg  ,
    cols = 1:6,
    rows = (((c * (
      exp_length + 1
    )) + 1) - exp_length):((c * exp_length + 1) + c) ,
    gridExpand = T,
    stack = T
  )
}

for (g in 1:group_num)
{
  mergeCells(wb,
             "Survival",
             cols = 1,
             rows = (((g * (
               exp_length + 1
             )) + 1) - exp_length):((g * exp_length + 1) + g)) # Merge group name cells with loop
}

saveWorkbook(wb, paste0(Spreadsheet_name, ".xlsx"), overwrite = FALSE)

print(paste0("saved to ", getwd(), "/", Spreadsheet_name, ".xlsx"))

}
