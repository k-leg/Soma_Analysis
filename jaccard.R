library(dplyr)
library(stringr)
library(purrr)

# ---- helper: parse leading edge genes (Entrez IDs) ----
parse_le <- function(x) {
  if (is.na(x) || x == "") return(character(0))
  unlist(str_split(x, "/", simplify = FALSE))
}

# ---- Jaccard similarity between two character vectors ----
jaccard <- function(a, b) {
  a <- unique(a); b <- unique(b)
  if (length(a) == 0 && length(b) == 0) return(1)
  if (length(a) == 0 || length(b) == 0) return(0)
  inter <- length(intersect(a, b))
  uni   <- length(union(a, b))
  inter / uni
}

# ---- build pathway table from gseaResult ----
res <- gsea_reactome@result %>%
  mutate(
    le_genes = purrr::map(core_enrichment, parse_le),
    le_size  = purrr::map_int(le_genes, length),
    nes_abs  = abs(NES)
  ) %>%
  # drop pathways with tiny leading edges if you want (optional)
  filter(le_size >= 5)

# ---- compute pairwise Jaccard and build edges above threshold ----
# Choose a threshold: 0.5-0.7 is typical. Start with 0.6.
thr <- 0.5

n <- nrow(res)
edges <- vector("list", 0)

if (n >= 2) {
  idx <- 1
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      sim <- jaccard(res$le_genes[[i]], res$le_genes[[j]])
      if (sim >= thr) {
        edges[[idx]] <- c(i, j)
        idx <- idx + 1
      }
    }
  }
}

# ---- assign clusters as connected components in the similarity graph ----
# Minimal graph logic without extra packages:
cluster_id <- seq_len(n)

if (length(edges) > 0) {
  parent <- seq_len(n)
  findp <- function(x) { while (parent[x] != x) x <- parent[x]; x }
  unionp <- function(a, b) {
    ra <- findp(a); rb <- findp(b)
    if (ra != rb) parent[rb] <<- ra
  }
  for (e in edges) unionp(e[1], e[2])
  cluster_id <- vapply(seq_len(n), findp, integer(1))
}

res2 <- res %>%
  mutate(cluster = cluster_id) %>%
  group_by(cluster) %>%
  arrange(p.adjust, desc(nes_abs)) %>%
  slice(1) %>%
  ungroup()

# ---- rebuild a condensed gseaResult object for plotting ----
gsea_reactome_jaccard <- gsea_reactome
gsea_reactome_jaccard@result <- res2

# ---- plot ----
dotplot(gsea_reactome_jaccard, showCategory = 5, split = ".sign") +
  facet_grid(. ~ .sign)



plot_df <- wg_wsc %>%
  mutate(
    sign = ifelse(.data[[nes_col]] >= 0, "Enriched Draw 1", "Enriched Draw 2"),
    fdr_plot = -log10(.data[[fdr_col]])
  ) %>%
  group_by(sign) %>%
  arrange(.data[[nes_col]], .by_group = TRUE) %>%
  mutate(desc_facet = factor(.data[[desc_col]], levels = unique(.data[[desc_col]]))) %>%
  ungroup()

enrichplot1 <- ggplot(plot_df, aes(x = .data[[nes_col]], y = desc_facet)) +
  geom_point(aes(size = .data[[size_col]], color = fdr_plot)) +
  facet_wrap(~ sign, scales = "free") +
  labs(
    x = "Normalized Enrichment Score",
    y = NULL,
    color = expression(-log[10](FDR)),
  ) +
  theme_bw(base_size = 12) +
  theme(axis.text.y = element_text(color = "black", size = 12), 
        axis.text.x = element_text(color = "black", size = 12),
        strip.text = element_text(size = 12, face = "bold")) +
  scale_color_viridis_c(option = "viridis")