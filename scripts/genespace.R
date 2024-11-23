library(GENESPACE)

args <- commandArgs(trailingOnly = TRUE)
wd <- args[1]

# Set the path to the MCScanX executable
gpar <- init_genespace(wd = wd, path2mcscanx = "/data/courses/assembly-annotation-course/CDS_annotation/softwares/MCScanX")

# Run GENESPACE
out <- run_genespace(gpar, overwrite = TRUE)