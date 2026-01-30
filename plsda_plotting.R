
library(dplyr)
library(ggplot2)

PLS_scores <- as.data.frame(ga_plsda$variates$X)

explained_var <- ga_plsda$prop_expl_var$X
x_lab <- paste0("Component 1 (", round(explained_var[1] * 100, 1), "%)")
y_lab <- paste0("Component 2 (", round(explained_var[2] * 100, 1), "%)")


plsda_plot <- ggplot(PLS_scores, aes(x = comp1, y = comp2, color = plsResponse, fill = plsResponse)) +
  geom_point(size = 3, alpha = 0.8) +
  stat_ellipse(type = "norm", level = 0.85, geom = "polygon", alpha = 0.2, color = NA)+
  scale_fill_discrete(guide = "none") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Mulilevel PLSDA: Gustilo Anderson Type",
    x = x_lab,
    y = y_lab,
    color = " ",
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "right",
    axis.text = element_text(size = 14)
  )