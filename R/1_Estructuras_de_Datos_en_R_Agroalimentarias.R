# =====================================================
# ESTRUCTURAS DE DATOS EN R PARA CIENCIAS AGROALIMENTARIAS
# Script para alumnos de Doctorado
# Basado en la descripción proporcionada
# =====================================================

# Instrucciones para cargar el script desde GitHub en RStudio:
# 1. Si el script está en tu carpeta local:
#    setwd("/ruta/a/tu/carpeta")
#    source("Estructuras_de_Datos_en_R_Agroalimentarias.R")
#
# 2. Desde GitHub (raw URL):
#    source("https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/Estructuras_de_Datos_en_R_Agroalimentarias.R")
#    # Reemplaza con la URL real de tu repositorio.
#    # Alternativa: usa download.file() para guardar localmente primero.

cat("=== ESTRUCTURAS DE DATOS EN R - CIENCIAS AGROALIMENTARIAS ===\n")

# 1. VECTORES
cat("\n1. Vectores:\n")
# Vector para nombres de genes o variedades de cultivos
variedades <- c("Maiz_Hibrido1", "Trigo_Durum", "Tomate_Cherry", "Papa_Andina")
print(variedades)

# Vector numérico: rendimientos en kg/ha
rendimientos <- c(8500, 6200, 4500, 32000)
print(rendimientos)

# Vector lógico: resistencia a plagas
resistencia <- c(TRUE, FALSE, TRUE, TRUE)
print(resistencia)

# Actividad detallada para doctorado:
# Crea un vector con conteos de nutrientes en suelo (N, P, K, Ca) para diferentes parcelas
nutrientes_suelo <- c(45, 22, 180, 1200)  # Ejemplo: mg/kg
names(nutrientes_suelo) <- c("Nitrogeno", "Fosforo", "Potasio", "Calcio")
print(nutrientes_suelo)

# 2. MATRICES
# cat("\n2. Matrices:\n")
# Matriz de expresión génica o datos de calidad de frutos (filas: genes/variedades, columnas: muestras/condiciones)
# expresion_matriz <- matrix(c(12.5, 8.3, 14.2, 10.5, 7.8, 9.3, 15.1, 11.2),
#                            nrow = 4,
#                            byrow = TRUE,
#                            dimnames = list(c("Gen_Maiz1", "Gen_Trigo1", "Gen_Tomate1", "Gen_Papa1"),
#                                            c("Control", "Sequía", "Fertilizante", "Control2")))
# print(expresion_matriz)

# 2. MATRICES
cat("\n2. Matrices:\n")
# Matriz de expresión génica o datos de calidad de frutos (filas: genes/variedades, columnas: muestras/condiciones)
expresion_matriz <- matrix(c(12.5, 8.3, 14.2, 10.5, 7.8, 9.3, 15.1, 11.2),
                           nrow = 4,
                           byrow = TRUE,
                           dimnames = list(c("Gen_Maiz1", "Gen_Trigo1", "Gen_Tomate1", "Gen_Papa1"),
                                           c("Control", "Sequía")))
print(expresion_matriz)

# Operaciones: promedio por fila (por gen/variedad)
promedios_gen <- rowMeans(expresion_matriz)
print(promedios_gen)

# Operaciones: promedio por fila (por gen/variedad)
promedios_gen <- rowMeans(expresion_matriz)
print(promedios_gen)

# Actividad doctorado:
# Crea matriz 5 genes x 4 tratamientos (sequía, salinidad, control, exceso agua) con datos simulados de transcriptómica en cultivos
tratamientos <- c("Control", "Sequía", "Salinidad", "Exceso_Agua")
genes_agro <- paste("Gen_Cultivo", 1:5, sep="")
matriz_agro <- matrix(rnorm(20, mean=10, sd=3), nrow=5, ncol=4,
                      dimnames = list(genes_agro, tratamientos))
print(matriz_agro)

# 3. DATA FRAMES
cat("\n3. Data Frames:\n")
# Data frame con datos anotados de variedades agrícolas
datos_cultivos <- data.frame(
  Variedad = c("Maiz_Hibrido1", "Trigo_Durum", "Tomate_Cherry"),
  Rendimiento_kg_ha = c(8500, 6200, 4500),
  Cromosoma_Principal = c("10", "7A", "6"),
  Regulacion = c("Upregulada", "Downregulada", "Upregulada"),
  stringsAsFactors = FALSE
)
print(datos_cultivos)

# Añadir columna nueva
datos_cultivos$Resistencia_Plagas <- c("Alta", "Media", "Baja")
print(datos_cultivos)

# Subsetting: filtrar por rendimiento
altos_rendimientos <- datos_cultivos[datos_cultivos$Rendimiento_kg_ha > 5000, ]
print(altos_rendimientos)

# Actividad doctorado detallada:
# Data frame para análisis multi-ómica en cadena agroalimentaria
# Incluye datos de suelo, planta y producto final
df_agro <- data.frame(
  Parcela = c("P1", "P2", "P3", "P4"),
  Variedad = c("Arroz_Japonica", "Maiz_BT", "Soja_GM", "Cafe_Arabica"),
  pH_Suelo = c(6.2, 5.8, 7.1, 6.5),
  Contenido_Humedad = c(18, 22, 15, 25),  # %
  Expresion_Gen_Key = c(8.5, 12.3, 9.1, 7.8),
  Calidad_Producto = c("Alta", "Media", "Alta", "Baja"),
  Fecha_Cosecha = as.Date(c("2025-10-01", "2025-09-15", "2025-11-20", "2025-08-30"))
)
print(df_agro)

# Análisis: resumen estadístico
summary(df_agro)

# 4. LISTAS
cat("\n4. Listas:\n")
# Lista para almacenar múltiples datasets en un proyecto agroalimentario
datos_bio <- list(
  Datos_Geneticos = c("Secuencia_ADN_Maiz", "Secuencia_ADN_Trigo"),
  Datos_Expresion = matriz_agro,
  Datos_Fenotipicos = datos_cultivos,
  Metadata = list(
    Proyecto = "Mejora_Genética_Cultivos_2026",
    Investigador = "Dr. Agroalimentario",
    Fecha = Sys.Date()
  )
)
print(datos_bio)

# Acceder elementos
print(datos_bio$Datos_Fenotipicos)

# Actividad doctorado:
# Lista compleja para pipeline de análisis: genómica + fenómica + datos ambientales
pipeline_agro <- list(
  Secuencias = list(ADN = "ATCG...", RNA = "AUGC...", Proteinas = c("Met", "Gly")),
  Datos_Ambientales = data.frame(Temperatura = c(25, 28, 22), Precipitacion = c(120, 80, 150)),
  Modelos = "lm(Rendimiento ~ pH_Suelo + Humedad)",
  Resultados_Estadisticos = list(p_valores = c(0.01, 0.05), correlaciones = 0.85)
)
print(pipeline_agro)

# 5. FACTORES
cat("\n5. Factores:\n")
# Factor para grupos de tratamiento en experimentos de campo
tratamientos_factor <- factor(c("Control", "Fertilizante_N", "Fertilizante_NP", "Control", "Fertilizante_N"))
print(tratamientos_factor)
levels(tratamientos_factor)

# Reordenar niveles para análisis (importante en agro: orden lógico)
tratamientos_factor <- factor(tratamientos_factor, levels = c("Control", "Fertilizante_N", "Fertilizante_NP"))
print(tratamientos_factor)

# Actividad doctorado:
# Factor para clasificación de calidad de alimentos o estrés en plantas
calidad_alimento <- factor(c("Premium", "Estándar", "Baja", "Premium", "Estándar"),
                           levels = c("Baja", "Estándar", "Premium"),
                           ordered = TRUE)
print(calidad_alimento)
summary(calidad_alimento)

# EJERCICIO PRÁCTICO INTEGRADO (Doctorado)
cat("\n=== EJERCICIO PRÁCTICO PARA DOCTORADO ===\n")
# Escenario: Datos de un ensayo de campo en cultivos de maíz bajo diferentes manejos agroecológicos

# Paso 1: Vectores
genes_maiz <- c("Zm1", "Zm2", "Zm3")
expresion <- c(14.2, 9.8, 16.5)
parcelas <- c("P1_Control", "P2_Sequía", "P3_Orgánico")

# Paso 2: Data Frame
df_maiz <- data.frame(
  Gen = genes_maiz,
  Expresion = expresion,
  Parcela = parcelas,
  Tratamiento = factor(c("Control", "Estrés", "Orgánico")),
  Rendimiento_Estimado = c(9200, 6500, 8800)
)

# Paso 3: Matriz de múltiples genes x parcelas
matriz_maiz <- matrix(c(14.2, 9.8, 16.5, 12.1, 8.5, 14.9, 13.8, 10.2, 15.7),
                      nrow = 3, byrow = TRUE,
                      dimnames = list(genes_maiz, parcelas))

# Paso 4: Lista completa
proyecto_maiz <- list(
  DataFrame = df_maiz,
  Matriz_Expresion = matriz_maiz,
  Factores_Tratamiento = df_maiz$Tratamiento,
  Notas = "Análisis para tesis doctoral en mejora genética de maíz"
)

print(proyecto_maiz)

cat("\n¡Script completado! Explora paquetes como tidyverse, Bioconductor para análisis avanzados en agroalimentaria.\n")
cat("Ejemplos adaptados a contextos de cultivos, suelo, calidad alimentaria y sostenibilidad.\n")
