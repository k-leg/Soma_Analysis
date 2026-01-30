# join sex_tib with protein dataframe and do some analyses

library(mixOmics)

df_demos <- df %>%
  left_join(sex_tib, by = "SubjectID")

# --------------Try multilevel plsda-------------------

library(mixOmics)

set.seed(5249)

# I had one subject that only had one timepoint which cannot be accounted
# for in multilevel plsda. this removes from the X, Y and design matrixes.

valid_subjects <- df_demos %>%
  count(SubjectID) %>%
  filter(n > 1) %>%
  pull(SubjectID)

# subset BOTH dataframes
df_demos_rm <- df_demos %>%
  filter(SubjectID %in% valid_subjects)

df_log2_rm <- df_log2 %>%
  filter(SubjectID %in% valid_subjects)


# tune keepX
test_keepX <- c(5, 10, 25, 50, 75, 100, 150)
test_ncomp <- 2


plsMatrix <- df_log2_rm %>% dplyr::select((where(is.numeric)))
plsResponse <- factor(df_demos_rm$sex)
design <- df_demos_rm$SubjectID

splsl.sex.multilevel <- tune.splsda(plsMatrix, plsResponse,
                            multilevel = design,
                            ncomp = test_ncomp,
                            test.keepX = test_keepX,
                            validation = "Mfold",
                            folds = 5,
                            nrepeat = 10,
                            dist = "max.dist")

keepX_opt <- splsl.sex.multilevel$choice.keepX

# run plsda and plot
sex_plsda <- splsda(plsMatrix, plsResponse,
                    ncomp = length(keepX_opt),
                    keepX = keepX_opt,
                    multilevel = design)

plotIndiv(
  sex_plsda,
  comp = c(1, 2),
  group = plsResponse,
  ind.names = FALSE,
  ellipse = TRUE,
  legend = TRUE,
  title = "Multilevel sPLS-DA (Comp 1 vs 2)"
)

# --------------------repeat for GA class-----------------------------
plsMatrix <- df_log2_rm %>% dplyr::select((where(is.numeric)))
plsResponse <- factor(df_demos_rm$ga)
design <- df_demos_rm$SubjectID

ga.multilevel <- tune.splsda(plsMatrix, plsResponse,
                                    multilevel = design,
                                    ncomp = test_ncomp,
                                    test.keepX = test_keepX,
                                    validation = "Mfold",
                                    folds = 3,
                                    nrepeat = 10,
                                    dist = "max.dist")

keepX_opt <- ga.multilevel$choice.keepX

# run plsda and plot
ga_plsda <- splsda(plsMatrix, plsResponse,
                    ncomp = length(keepX_opt),
                    keepX = keepX_opt,
                    multilevel = design)

plotIndiv(
  ga_plsda,
  comp = c(1, 2),
  group = plsResponse,
  ind.names = FALSE,
  ellipse = TRUE,
  legend = TRUE,
  title = "Multilevel sPLS-DA (Comp 1 vs 2)"
)
