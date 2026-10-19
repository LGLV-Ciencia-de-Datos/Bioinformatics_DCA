# =====================================================
# VISUALIZACIÓN DE DATOS EN R PARA CIENCIAS AGROALIMENTARIAS
# Script para alumnos de Doctorado
# =====================================================

# Instrucciones para cargar el script desde GitHub en RStudio:
# 1. Desde carpeta local:
#    setwd("/ruta/a/tu/carpeta")
#    source("Visualizacion_Datos_R_Agroalimentarias.R")
#
# 2. Desde GitHub (raw):
#    source("https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/Visualizacion_Datos_R_Agroalimentarias.R")

cat("=== VISUALIZACIÓN DE DATOS EN R - CIENCIAS AGROALIMENTARIAS ===\n")

# Cargar paquetes necesarios
cat("\nCargando paquetes...\n")
paquetes <- c("ggplot2", "pheatmap", "dplyr")
install.packages(paquetes[!(paquetes %in% installed.packages()[,"Package"])], quiet = TRUE)
lapply(paquetes, library, character.only = TRUE)

# Datos simulados para doctorado en agro
cat("\nCreando datos de ejemplo para tesis agroalimentaria...\n")

datos_cultivos <- data.frame(
  Variedad = rep(c("Maiz_Hibrido", "Trigo_Durum", "Arroz_Japonica", "Soja_GM"), each = 25),
  Rendimiento_kg_ha = c(rnorm(25, 8500, 800), rnorm(25, 6200, 600), 
                        rnorm(25, 7200, 700), rnorm(25, 4500, 500)),
  Expresion_Gen = c(rnorm(25, 12, 2), rnorm(25, 9, 1.5), 
                    rnorm(25, 11, 2.5), rnorm(25, 8, 1.8)),
  Tratamiento = rep(c("Control", "Sequía", "Fertilizante"), length.out = 100),
  pH_Suelo = rnorm(100, 6.2, 0.5)
)

# 1. Scatter Plot
cat("\n2. Scatter Plot: Rendimiento vs Expresión Génica...\n")
ggplot(datos_cultivos, aes(x = Rendimiento_kg_ha, y = Expresion_Gen, color = Variedad)) +
  geom_point(size = 4, alpha = 0.8) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Relación entre Rendimiento y Expresión Génica en Cultivos",
       x = "Rendimiento (kg/ha)", y = "Nivel de Expresión Génica") +
  theme_minimal()

# 2. Boxplot
cat("\n3. Boxplot: Distribución de Rendimientos...\n")
boxplot(Rendimiento_kg_ha ~ Variedad * Tratamiento, data = datos_cultivos,
        col = rainbow(4), main = "Boxplot de Rendimientos por Variedad y Tratamiento",
        xlab = "Variedad x Tratamiento", ylab = "Rendimiento (kg/ha)")

# 3. Histograma
cat("\n4. Histograma: Distribución de pH en Suelo...\n")
hist(datos_cultivos$pH_Suelo, breaks = 15, col = "lightblue",
     main = "Distribución de pH en Suelos Agrícolas", xlab = "pH del Suelo")

# 4. Heatmap
cat("\n5. Heatmap de Expresión Génica...\n")
matriz_exp <- matrix(rnorm(50, mean = 10, sd = 3), nrow = 10)
rownames(matriz_exp) <- paste("Gen_Cultivo", 1:10)
colnames(matriz_exp) <- paste("Muestra", 1:5)
pheatmap(matriz_exp, main = "Heatmap de Expresión Génica en Cultivos",
         color = colorRampPalette(c("blue", "white", "red"))(50))

# 5. Volcano Plot (Estilo avanzado con 3 categorías, umbrales y etiquetas)
cat("\n6. Volcano Plot: Genes Diferencialmente Expresados...\n")

set.seed(123)
n_genes <- 1500
volcano_data <- data.frame(
  Gen = paste0("Gen_", 1:n_genes),
  logFC = rnorm(n_genes, 0, 1.5),
  p_val = runif(n_genes, 0.00001, 1)
)
volcano_data$negLogP <- -log10(volcano_data$p_val)

# Definir umbrales de corte
fc_umbral <- 1.0
p_umbral <- 1.30103 # Equivalente a -log10(0.05)

# Clasificar en 3 grupos
volcano_data$Categoria <- "Not sig"
volcano_data$Categoria[volcano_data$logFC > fc_umbral & volcano_data$negLogP > p_umbral] <- "Up regulated"
volcano_data$Categoria[volcano_data$logFC < -fc_umbral & volcano_data$negLogP > p_umbral] <- "Down regulated"
volcano_data$Categoria <- factor(volcano_data$Categoria, levels = c("Down regulated", "Not sig", "Up regulated"))

# Conteo por categoría para la leyenda
n_down <- sum(volcano_data$Categoria == "Down regulated")
n_notsig <- sum(volcano_data$Categoria == "Not sig")
n_up <- sum(volcano_data$Categoria == "Up regulated")

# Seleccionar los genes más destacados para etiquetar
genes_top <- volcano_data %>%
  filter(Categoria != "Not sig") %>%
  arrange(desc(negLogP)) %>%
  head(8)

# Generar gráfico con ggplot2
ggplot(volcano_data, aes(x = logFC, y = negLogP, color = Categoria)) +
  geom_point(alpha = 0.6, size = 2) +
  scale_color_manual(
    values = c("Down regulated" = "#56B4E9", "Not sig" = "grey80", "Up regulated" = "#E69F00"),
    labels = c(
      paste0("Down regulated(", n_down, ")"),
      paste0("Not sig(", n_notsig, ")"),
      paste0("Up regulated(", n_up, ")")
    )
  ) +
  geom_vline(xintercept = c(-fc_umbral, fc_umbral), linetype = "dashed", color = "black", linewidth = 0.4) +
  geom_hline(yintercept = p_umbral, linetype = "dashed", color = "black", linewidth = 0.4) +
  geom_text(data = genes_top, aes(label = Gen), color = "red", size = 3.5, vjust = -0.8, check_overlap = TRUE) +
  labs(
    title = "Volcano Plot - Expresión Diferencial en Maíz bajo Estrés",
    subtitle = "Control_vs_Sequia",
    x = expression(log[2] * "(Fold Change)"),
    y = expression(-log[10] * "(P-value)")
  ) +
  theme_minimal() +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, face = "italic")
  )

cat("\n¡Visualizaciones generadas! Estas gráficas son ideales para tesis doctorales en mejora genética, manejo de suelos y calidad alimentaria.\n")
cat("Explora más con paquetes como ggpubr, cowplot o ComplexHeatmap.\n")