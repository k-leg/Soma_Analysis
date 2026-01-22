

df_ECM <- df %>%
  select(Timepoint, Q9UKZ9,
         Q03692,
         P02461,
         P02452,
         Q15113)

write.csv(df_ECM, "df_ECM.csv", row.names = FALSE)

df_innate <- df %>%
  select(Timepoint,
         P06702,
         P0DJI8,
         P02741,
         P18428,
         P11142)

write.csv(df_innate, "df_innate.csv", row.names = FALSE)

df_inflam <- df %>%
  select(Timepoint,
         P01584,
         P05231,
         P01375,
         P01579,
         P22301)

write.csv(df_inflam, "df_inflam.csv", row.names = FALSE)

df_repair <- df %>%
  select(Timepoint,
         P01137,
         P09038,
         P15692,
         P12643,
         P18075)

write.csv(df_repair, "df_repair.csv", row.names = FALSE)

df_TGF <- df %>%
  select(Timepoint,
         P12643,
         P12644,
         P18075,
         P01137,
         P61812,
         P22004,
         P43026,
         Q92859,
         Q13253,
         O00238)

write.csv(df_TGF, "df_tgf.csv", row.names = FALSE)
