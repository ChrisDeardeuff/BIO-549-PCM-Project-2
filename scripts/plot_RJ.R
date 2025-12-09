#################################################################
# author: Chris Deardeuff
# R Script: Plot the RJ is_OU and is_BM values with Bayes Factor lines   #
# WIP, does not work.
#################################################################

library(RevGadgets)
library(ggplot2)

# specify the input file
file <- "output/simple_OU_RJ.log"

    # read the trace and discard burnin
    trace_qual <- readTrace(path = file, burnin = 0.25)

    # Flatten to a single dataframe
    if (is.list(trace_qual) && !is.data.frame(trace_qual)) {
      trace_qual <- do.call(rbind, trace_qual)
    }

    # Remove Replicate_ID to avoid internal grouping issues in plotTrace
    if ("Replicate_ID" %in% names(trace_qual)) {
      trace_qual$Replicate_ID <- NULL
    }

    # Wrap back into a list for plotTrace
    trace_qual <- list(combined = trace_qual)

    BF <- c(3.2, 10, 100)
    p <- BF/(1+BF)
# produce the plot object, showing the posterior distributions of the rates.
p <- plotTrace(trace = trace_qual,
          vars = c("is_OU"))[[1]] +
          ylim(0,1) +
          geom_hline(yintercept=0.5, linetype="solid", color = "black") +
          geom_hline(yintercept=p, linetype=c("longdash","dashed","dotted"), color = "red") +
          geom_hline(yintercept=1-p, linetype=c("longdash","dashed","dotted"), color = "red") +
     # modify legend location using ggplot2
     theme(legend.position = c(0.40,0.825))

ggsave("ou_RJ.pdf", p, width = 5, height = 5)
