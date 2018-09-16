
readBAFExtractOutput <- function(path, sequencing.type = "bulk") {
    
    files <- list.files(path)
    files <- files[grep(".snp$", files)]
    
    
    loh <- list()
    for (i in 1:length(files)) {
        maf <- read.table(file.path(path, files[i]), header = F, stringsAsFactor = F)
        maf <- data.frame(chr = maf[, 1], position = maf[, 2], alt = maf[, 5], ref = maf[, 6] - maf[, 5], coverage = maf[, 6], baf = maf[, 5]/maf[, 
            6], dev = abs(as.numeric(maf[, 5]/maf[, 6]) - 0.5))
        maf <- maf[order(maf$position), ]
        idx = unlist(as.vector((sapply(1:22, function(x) as.vector(unlist(which(as.character(maf$chr) == x)))))))
        maf <- maf[idx, ]
        j <- 0.2
        if (sequencing.type == "bulk") 
            maf <- maf[maf$baf > j & maf$baf < (1 - j), ]
        if (sequencing.type == "single-cell") 
            maf <- maf[maf$baf > j, ]
        loh[[i]] <- maf
    }
    
    names(loh) <- files
    return(loh)
}

lohCallMedianFilter <- function(object, loh.scale, n = 50, scale.iteration = 50) {
    
    object@loh.median.filtered.data <- list()
    for (j in 1:length(object@loh)) {
        maf <- object@loh[[j]]
        data_smoothed <- maf$dev
        for (i in 1:loh.scale) {
            print(n)
            data_smoothed <- round(signal::filter(MedianFilter(n + 1), data_smoothed), digits = 2)
            maf$dev <- data_smoothed
            n <- n + scale.iteration
        }
        object@loh.median.filtered.data[[j]] <- maf
    }
    names(object@loh.median.filtered.data) <- names(object@loh)
    return(object)
    
}




lohCallMedianFilterByChr <- function(object, loh.scale, n = 50, scale.iteration = 50) {
    
    ################ Center data (automatically ignores zeros) ################
    
    object@loh.median.filtered.data <- list()
    
    for (j in 1:length(object@loh)) {
        maf <- object@loh[[j]]
        data_smoothed <- maf$dev
        # plot_LOH_WG_Unpaired (maf=maf,sample_name=sample_name, outDir=paste0('./', fileName))
        maf_temp <- maf
        for (i in 1:loh.scale) {
            
            maf_2 <- NULL
            for (m in 1:22) {
                chrBAF <- maf_temp[which(as.character(maf_temp$chr) == as.character(m)), ]
                chrBAF <- chrBAF[order(as.numeric(as.character(chrBAF$pos))), ]
                data_smoothed <- chrBAF$dev
                data_smoothed <- round(signal::filter(MedianFilter(n + 1), data_smoothed), digits = 2)
                chrBAF$dev <- data_smoothed
                maf_2 <- rbind(maf_2, chrBAF)
                
            }
            
            maf_temp <- maf_2
            # plot_LOH_WG_Unpaired (maf=maf_2,sample_name=paste0(sample_name, 'before_smooth_center', '_', i), outDir=paste0('./', fileName))
            n <- n + scale.iteration
        }
        object@loh.median.filtered.data[[j]] <- maf_2
    }
    names(object@loh.median.filtered.data) <- names(object@loh)
    
    return(object)
}