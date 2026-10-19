# =====================================================
# IMPORTACIÓN Y EXPORTACIÓN DE DATOS EN R
# Para Ciencias Agroalimentarias - Nivel Doctorado
# =====================================================

# Instrucciones para cargar el script desde GitHub en RStudio:
# 1. Desde carpeta local:
#    setwd("/ruta/a/tu/carpeta")
#    source("Importacion_Exportacion_Datos_R_Agroalimentarias.R")
#
# 2. Desde GitHub (raw):
#    source("https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/Importacion_Exportacion_Datos_R_Agroalimentarias.R")
#    # O descarga primero:
#    download.file("https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/Importacion_Exportacion_Datos_R_Agroalimentarias.R", 
#                  "Importacion_Exportacion_Datos_R_Agroalimentarias.R")

cat("=== IMPORTACIÓN Y EXPORTACIÓN DE DATOS EN R - AGROALIMENTARIAS ===\n")

# Configuración inicial
cat("\nConfigurando directorio de trabajo...\n")
# setwd("ruta/a/tus/archivos")  # Descomenta y ajusta según tu carpeta

# 1. IMPORTACIÓN DE DATOS TABULARES (CSV/TSV)
cat("\n1. Importación de datos tabulares (CSV/TSV)...\n")

# Ejemplo simulado para doctorado (creamos datos si no existen)
datos_simulados <- data.frame(
  Parcela = paste("P", 1:10, sep=""),
  Variedad = c("Maiz_Hibrido", "Trigo_Durum", "Arroz_Japonica", "Soja_GM", "Cafe_Arabica", 
               "Papa_Andina", "Tomate_Cherry", "Fresa_Org", "Cebada", "Avena"),
  Rendimiento_kg_ha = c(8500, 6200, 7200, 4500, 3200, 28000, 5200, 18000, 6800, 5500),
  pH_Suelo = c(6.2, 5.8, 6.5, 7.1, 6.0, 5.5, 6.8, 5.9, 6.3, 6.1),
  Humedad = c(18, 22, 15, 25, 20, 30, 12, 28, 19, 21),
  Tratamiento = c("Control", "Sequía", "Control", "Fertilizante", "Salinidad", 
                  "Orgánico", "Control", "Control", "Fertilizante", "Sequía")
)

write.csv(datos_simulados, "rendimientos_cultivos.csv", row.names = FALSE)
cat("Archivo de ejemplo 'rendimientos_cultivos.csv' creado.\n")

# Importar el CSV
rendimientos <- read.csv("rendimientos_cultivos.csv", header = TRUE)
head(rendimientos)
summary(rendimientos)

# Importar TSV (ejemplo)
write.table(rendimientos, "rendimientos_cultivos.tsv", sep = "\t", row.names = FALSE)
rendimientos_tsv <- read.table("rendimientos_cultivos.tsv", header = TRUE, sep = "\t")
head(rendimientos_tsv)

# 2. IMPORTACIÓN DE ARCHIVOS EXCEL
cat("\n2. Importación de archivos Excel...\n")
install.packages("readxl")  # Si no está instalado
library(readxl)

# 3. IMPORTACIÓN DE SECUENCIAS BIOLÓGICAS (FASTA)
cat("\n3. Importación de secuencias FASTA (Biostrings)...\n")
# BiocManager::install("Biostrings")
library(Biostrings)

# Crear FASTA de ejemplo para cultivos (secuencias simuladas)
# secuencias <- DNAStringSet(c(
#   "ATGCATGCATGCATGCATGCGATCGATCG",  # Secuencia gen Maiz
#   "GCTAGCTAGCTAGCTAGCTAGCTAGCTA",  # Secuencia gen Trigo
#   "CGATCGATCGATCGATCGATCGATCGA"    # Secuencia gen Arroz
# ))
# names(secuencias) <- c("Zm_Gen1_Maiz", "Ta_Gen1_Trigo", "Os_Gen1_Arroz")
# writeXStringSet(secuencias, "secuencias_cultivos.fasta")

secuencias <- DNAStringSet(c(
  "ATGCATGCATGCATGCATGCGATCGATCG",  # Secuencia gen Maiz
  "GCTAGCTAGCTAGCTAGCTAGCTAGCTA",  # Secuencia gen Trigo
  "CGATCGATCGATCGATCGATCGATCGA"    # Secuencia gen Arroz
))
names(secuencias) <- c("Zm_Gen1_Maiz", "Ta_Gen1_Trigo", "Os_Gen1_Arroz")
writeXStringSet(secuencias, "secuencias_cultivos.fasta")

# Importar FASTA
fasta_agro <- readDNAStringSet("secuencias_cultivos.fasta")
fasta_agro
length(fasta_agro)  # Número de secuencias

# 4. EXPORTACIÓN DE DATOS
cat("\n4. Exportación de datos...\n")

# Exportar CSV/TSV
write.csv(rendimientos[rendimientos$Rendimiento_kg_ha > 6000, ], 
          "cultivos_alto_rendimiento.csv", row.names = FALSE)

write.table(rendimientos, "rendimientos_completos.tsv", sep="\t", row.names = FALSE)

# Exportar Excel

install.packages("writexl")

if (requireNamespace("writexl", quietly = TRUE)) {
  library(writexl)
  write_xlsx(rendimientos, "rendimientos_agro.xlsx")
  cat("Archivo Excel exportado.\n")
}

# # Exportar FASTA modificada
# secuencias_mod <- fasta_agro
# secuencias_mod[1] <- DNAString("ATGCATGCATGCATGCATGCGATCGATCGATCG")  # Modificar una secuencia
# writeXStringSet(secuencias_mod, "secuencias_modificadas.fasta")
# cat("Secuencias modificadas exportadas.\n")

# Exportar FASTA modificada
secuencias_mod <- fasta_agro

# Modificar manteniendo la misma longitud (ejemplo: reemplazar parte de la secuencia)
nueva_sec <- DNAString("ATGCATGCATGCATGCATGCGATCGATCGATCG")  # Misma longitud que la original
secuencias_mod[[1]] <- nueva_sec

writeXStringSet(secuencias_mod, "secuencias_modificadas.fasta")
cat("Secuencias modificadas exportadas correctamente.\n")

# 5. EJERCICIO PRÁCTICO DOCTORADO
cat("\n=== EJERCICIO PRÁCTICO PARA DOCTORADO ===\n")
cat("Escenario: Análisis de datos multi-ómicos en un ensayo de campo de maíz y trigo.\n")

# 1. Importar datos de campo
datos_campo <- read.csv("rendimientos_cultivos.csv")

# 2. Filtrar y analizar
datos_filtrados <- datos_campo[datos_campo$Rendimiento_kg_ha > 5000 & datos_campo$pH_Suelo > 6, ]
cat("Parcelas seleccionadas:\n")
print(datos_filtrados)

# 3. Exportar subset
write.csv(datos_filtrados, "parcelas_optimas.csv", row.names = FALSE)

# 4. Trabajar con secuencias
fasta <- readDNAStringSet("secuencias_cultivos.fasta")
cat("Número de secuencias cargadas:", length(fasta), "\n")

# 5. Exportar resultados
writeXStringSet(fasta, "secuencias_finales.fasta")  # Si Biostrings disponible

cat("\n¡Script completado!\n")
cat("Paquetes recomendados: readxl, writexl, Biostrings, VariantAnnotation, data.table para archivos grandes.\n")
cat("Adapta las rutas de archivos a tu proyecto de tesis en ciencias agroalimentarias.\n")