# =====================================================
# INSTALACIÓN DE PAQUETES EN R
# Para Ciencias Agroalimentarias - Nivel Doctorado
# =====================================================

# Instrucciones para cargar el script desde GitHub en RStudio:
# 1. Desde carpeta local:
#    setwd("/ruta/a/tu/carpeta")
#    source("Instalacion_Paquetes_R_Agroalimentarias.R")
#
# 2. Desde GitHub (raw):
#    source("https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/Instalacion_Paquetes_R_Agroalimentarias.R")

cat("=== INSTALACIÓN DE PAQUETES EN R PARA AGROALIMENTARIAS ===\n")

# # 1. Instalar desde CRAN
# cat("\n1. Instalando paquetes desde CRAN...\n")
# paquetes_cran <- c("ggplot2", "dplyr", "tidyr", "readxl", "writexl", "agricolae")
# install.packages(paquetes_cran, repos = "https://cloud.r-project.org", quiet = TRUE)
# cat("Paquetes CRAN instalados.\n")

# 1. Instalar desde CRAN
cat("\n1. Instalando paquetes desde CRAN...\n")
paquetes_cran <- c("ggplot2", "dplyr", "tidyr", "readxl", "writexl", "agricolae")
install.packages(paquetes_cran, repos = "https://cloud.r-project.org", quiet = TRUE)
cat("Paquetes CRAN instalados.\n")


# 2. Instalar Bioconductor (esencial para bioinformática agro)
cat("\n2. Instalando Bioconductor...\n")
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install(c("Biostrings", "edgeR", "DESeq2", "limma"), update = FALSE, ask = FALSE)
cat("Paquetes Bioconductor instalados (útiles para análisis de expresión génica en cultivos).\n")

# 3. Instalar desde GitHub (versiones de desarrollo)
cat("\n3. Instalando desde GitHub...\n")
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# 4. Instalar múltiples paquetes recomendados para tesis doctoral
cat("\n4. Instalando suite completa para doctorado en agroalimentarias...\n")
paquetes_agro <- c(
  "ggplot2", "dplyr", "tidyr", "readr", "stringr",        # tidyverse
  "agricolae", "lme4", "emmeans",                        # Estadística agronómica
  "Biostrings", "GenomicRanges",                         # Bioinformática
  "pheatmap", "factoextra", "corrplot",                  # Visualización
  "rstatix", "car"                                       # Pruebas estadísticas
)

install.packages(paquetes_agro[!(paquetes_agro %in% installed.packages()[,"Package"])], 
                 repos = "https://cloud.r-project.org", quiet = TRUE)

cat("Paquetes recomendados para análisis de ensayos de campo, genómica y calidad alimentaria instalados.\n")

# 5. Actualizar paquetes
cat("\n5. Actualizando paquetes existentes...\n")
update.packages(ask = FALSE, quiet = TRUE)
cat("Actualización completada.\n")

# Ejercicio práctico
cat("\n=== EJERCICIO PRÁCTICO PARA DOCTORADO ===\n")
cat("Instala los paquetes necesarios para tu tesis:\n")
cat("- ggplot2 + agricolae → Análisis y gráficos de rendimientos de cultivos\n")
cat("- Biostrings + edgeR → Análisis de secuencias y expresión diferencial en mejoramiento genético\n")
cat("- devtools → Acceder a paquetes en desarrollo para fenotipado de alto rendimiento\n\n")

cat("¡Script completado! Ahora estás listo para workflows avanzados en ciencias agroalimentarias.\n")
cat("Recuerda verificar con library() que los paquetes carguen correctamente.\n")