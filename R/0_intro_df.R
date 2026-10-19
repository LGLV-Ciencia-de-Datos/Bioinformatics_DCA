# 1. Como crear una tabla de datos o un dataframe




# # 2. Configurar la ventana gráfica para ver dos gráficos juntos (días y semanas)
# 
# par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
# 
# # Gráfico de días por mes
# barplot(d_s_m_2027$dias, 
#         names.arg = d_s_m_2027$mes, 
#         col = "skyblue", 
#         main = "Días por Mes (2027)",
#         ylab = "Días",
#         ylim = c(0, 35))
# 
# # Gráfico de semanas por mes
# barplot(d_s_m_2027$semanas, 
#         names.arg = d_s_m_2027$mes, 
#         col = "orange", 
#         main = "Semanas por Mes (2027)",
#         ylab = "Semanas",
#         ylim = c(0, 6))
# 
# # Restaurar la configuración predeterminada de la ventana
# par(mfrow = c(1, 1))
# 
# # 3. Asegúrate de cargar la librería primero
# library(ggplot2)
# 
# # Crear el gráfico de barras para los días
# ggplot(d_s_m_2027, aes(x = factor(mes, levels = mes), y = dias)) +
#   geom_col(fill = "steelblue", color = "black", alpha = 0.8) +
#   labs(
#     title = "Total de Días por Mes en 2027",
#     x = "Mes",
#     y = "Días"
#   ) +
#   theme_minimal()
# 
# # 4. Crear el gráfico asignando el color según el número de semanas
# ggplot(d_s_m_2027, aes(x = factor(mes, levels = mes), y = dias, fill = factor(semanas))) +
#   geom_col(color = "black", alpha = 0.8) +
#   scale_fill_brewer(palette = "Set2") + # Puedes cambiar la paleta de colores aquí
#   labs(
#     title = "Días por Mes y su relación con las Semanas (2027)",
#     x = "Mes",
#     y = "Días",
#     fill = "Semanas"
#   ) +
#   theme_minimal() +
#   theme(
#     plot.title = element_text(face = "bold", hjust = 0.5),
#     legend.position = "right"
#   )

