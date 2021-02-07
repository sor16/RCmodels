#' Compare two models using Bayes factor
#'
#' evaluate_game uses the Bayes factor of two models to determine whether one model favors the other
#'
#' @param m a list of two model objects fit on the same dataset. Model objects allowed are "bgplm", "bgplm0", "bplm" and "bplm0"
#' @details TODO
#' @return
#' A data.frame with the summary of the results of the game
#'
#' @references B. Hrafnkelsson, H. Sigurdarson, S.M. Gardarsson, 2020, Generalization of the power-law rating curve using hydrodynamic theory and Bayesian hierarchical modeling. arXiv preprint 2010.04769.
#'
#' @seealso \code{\link{tournament}}
evaluate_game <- function(m){
    BF_vec <- sapply(m,function(x) x$B)
    BF_prop <- BF_vec[1]/BF_vec[2]
    PR_m1 <- 1/(1+(1/BF_prop))
    DIC_vec <- sapply(m,function(x) x$DIC)
    winner <- ifelse(PR_m1>=0.5,1,2)
    data.frame(model=sapply(m,class),
               BF=BF_vec,
               DIC=DIC_vec,
               P=c(PR_m1,1-PR_m1),
               winner=1:2==winner)
}


#' Determine the most adequate rating curve model
#'
#' tournament compares
#'
#' @param formula an object of class "formula", with discharge column name as response and stage column name as a covariate.
#' @param data data.frame containing the variables specified in formula.
#' @param ... if data and formula are set to NULL, one can add four model objects of types bgplm, bgplm0, bplm and bplm0. This prevents the function from running all four models explicitly.
#' @details  TODO
#' @return
#' An object of type "tournament" with the following elements
#' \describe{
#'  \item{\code{summary}}{a data frame with information on reults of the different games in the tournament.}
#'  \item{\code{winner}}{model object of the winning model}
#' }
#'
#' @references B. Hrafnkelsson, H. Sigurdarson, S.M. Gardarsson, 2020, Generalization of the power-law rating curve using hydrodynamic theory and Bayesian hierarchical modeling. arXiv preprint 2010.04769.
#'
#' @seealso \code{\link{summary.tournament}}
#' @examples
#' TODO
#' @export
tournament <- function(formula,data,...) {
    args <- list(...)
    error_msg <- 'Please provide either formula and data or four model objects of types bgplm, bgplm0, bplm and bplm0.'
    if(is.null(formula) | is.null(data)){
        if(length(args)!=4){
            stop(error_msg)
        }else{
            args_class <- sapply(args,class)
            if(!all(sort(args_class)==c('bgplm','bgplm0','bplm','bplm0'))){
                stop(error_msg)
            }else{
                names(args) <- args_class
            }
        }
    }else{
        args$bgplm <- bgplm(formula, data)
        args$bgplm0 <- bgplm0(formula, data)
        args$bplm <- bplm(formula, data)
        args$bplm0 <- bplm0(formula, data)
    }
    round1<- list(list(args$bgplm,args$bgplm0),list(args$bplm,args$bplm0))
    round1_res <- lapply(1:length(round1),function(i){
                    game_df <- evaluate_game(round1[[i]])
                    round_df <- data.frame(round=1,game=i)
                    cbind(round_df,game_df)
                  })
    round1_res <- do.call(rbind,round1_res)
    round1_winners <- round1_res$model[round1_res$winner]
    cat("######## ROUND 1 ########\n")
    print(round1_res, row.names=FALSE)
    cat("\n")
    cat(paste("The winners of round 1 are",round1_winners[1],"and",round1_winners[1],sep = " "))
    cat("\n\n")

    round2 <- lapply(1:length(round1),function(i){
        round1[[i]][[which(round1_res$winner[round1_res$game==i])]]
    })
    round2_res <- cbind(data.frame(round=1,game=3),evaluate_game(round2))
    round2_winner <- round2_res$model[round2_res$winner]

    cat("######## ROUND 2 ########\n")
    print(round2_res, row.names=FALSE)
    cat("\n")
    cat(paste0("The overall winner is ",round2_winner,"!",sep = " "))
    out_obj <- list()
    attr(out_obj, "class") <- "tournament"
    out_obj$contestants <- args
    out_obj$winner <- round2[[which(round2_res$winner)]]
    out_obj$summary <- rbind(round1_res,round2_res)
    return(out_obj)
}

