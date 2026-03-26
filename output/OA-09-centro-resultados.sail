/* ==========================================================================
 * ORQUESTADOR DE AGENTES - CENTRO DE RESULTADOS
 * ==========================================================================
 * Purpose: View generated outputs from executions. Allows consulting
 *   deliverables, summaries, orchestrator decisions, agent results,
 *   and comparing versions/iterations.
 *
 * REQUIREMENT: View deliverables, summaries, decisions per agent.
 * REQUIREMENT: Compare versions, quick access to source execution.
 * ========================================================================== */

a!localVariables(
  local!searchText,
  local!typeFilter,
  local!projectFilter,
  local!selectedResult,

  local!results: {
    a!map(
      id: "RES-001",
      executionId: "EXE-2026-0410",
      executionName: "Clasificacion Documentos Lote 47",
      type: "Informe de Clasificacion",
      typeIcon: "tags",
      typeColor: "#8B5CF6",
      project: "Proyecto Gamma",
      generatedBy: "Agente Clasificador",
      date: "24 Mar 2026",
      summary: "42 documentos clasificados en 4 categorias: 18 Compraventa, 12 Servicios, 8 Licencia, 4 Colaboracion. Precision media: 94%.",
      status: "Final",
      version: "v1.0",
      format: "JSON + PDF"
    ),
    a!map(
      id: "RES-002",
      executionId: "EXE-2026-0407",
      executionName: "Resumen Ejecutivo Trimestral",
      type: "Resumen Ejecutivo",
      typeIcon: "file-text",
      typeColor: "#F59E0B",
      project: "Proyecto Beta",
      generatedBy: "Agente Generador",
      date: "23 Mar 2026",
      summary: "Resumen ejecutivo de 12 paginas con metricas clave del trimestre, tendencias identificadas y 5 recomendaciones estrategicas.",
      status: "Final",
      version: "v2.0",
      format: "PDF"
    ),
    a!map(
      id: "RES-003",
      executionId: "EXE-2026-0406",
      executionName: "Analisis Sentimiento Encuestas",
      type: "Analisis de Sentimiento",
      typeIcon: "bar-chart",
      typeColor: "#3B82F6",
      project: "Proyecto Gamma",
      generatedBy: "Agente Revisor",
      date: "23 Mar 2026",
      summary: "Analisis de 1,500 respuestas: 68% positivo, 22% neutral, 10% negativo. Temas clave: calidad servicio (85%), tiempo respuesta (72%).",
      status: "Final",
      version: "v1.0",
      format: "Dashboard + CSV"
    ),
    a!map(
      id: "RES-004",
      executionId: "EXE-2026-0404",
      executionName: "Generacion Propuesta Comercial",
      type: "Propuesta Comercial",
      typeIcon: "handshake-o",
      typeColor: "#059669",
      project: "Proyecto Alpha",
      generatedBy: "Agente Generador",
      date: "22 Mar 2026",
      summary: "Propuesta comercial personalizada para Cliente XYZ. Incluye analisis de necesidades, solucion propuesta, cronograma y presupuesto.",
      status: "Final",
      version: "v3.0",
      format: "PDF + DOCX"
    ),
    a!map(
      id: "RES-005",
      executionId: "EXE-2026-0412",
      executionName: "Analisis Contractual Q1",
      type: "Analisis de Riesgo",
      typeIcon: "shield",
      typeColor: "#DC2626",
      project: "Proyecto Alpha",
      generatedBy: "Agente Revisor",
      date: "25 Mar 2026",
      summary: "Analisis parcial: 7 contratos con clausulas de alto riesgo identificadas. Pendiente validacion humana para resultado definitivo.",
      status: "Parcial",
      version: "v0.1",
      format: "JSON"
    )
  },

  a!headerContentLayout(
    header: {
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "clipboard-list", color: "#94A3B8", size: "MEDIUM"),
                      " ",
                      a!richTextItem(text: "Centro de Resultados", size: "LARGE", style: "STRONG", color: "#FFFFFF"),
                      char(10),
                      a!richTextItem(text: "Entregables y salidas generadas por las ejecuciones", color: "#94A3B8", size: "STANDARD")
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!buttonArrayLayout(
                    buttons: a!buttonWidget(
                      label: "Exportar Todo",
                      icon: "download",
                      style: "OUTLINE",
                      color: "#FFFFFF",
                      size: "SMALL",
                      saveInto: {}
                    ),
                    align: "END",
                    marginBelow: "NONE"
                  )
                },
                width: "MEDIUM"
              )
            },
            alignVertical: "MIDDLE"
          )
        },
        style: "#1C2C44",
        padding: "MORE",
        marginBelow: "NONE",
        showBorder: false,
        height: "AUTO"
      )
    },
    contents: {
      /* Filters */
      a!columnsLayout(
        columns: {
          a!columnLayout(
            contents: {
              a!textField(
                label: "Buscar",
                labelPosition: "COLLAPSED",
                placeholder: "Buscar por ejecucion, tipo de resultado...",
                value: local!searchText,
                saveInto: local!searchText
              )
            },
            width: "AUTO"
          ),
          a!columnLayout(
            contents: {
              a!dropdownField(
                label: "Tipo",
                labelPosition: "COLLAPSED",
                placeholder: "Todos los tipos",
                choiceLabels: {"Informe de Clasificacion", "Resumen Ejecutivo", "Analisis de Sentimiento", "Propuesta Comercial", "Analisis de Riesgo"},
                choiceValues: {"clasificacion", "resumen", "sentimiento", "propuesta", "riesgo"},
                value: local!typeFilter,
                saveInto: local!typeFilter
              )
            },
            width: "NARROW_PLUS"
          ),
          a!columnLayout(
            contents: {
              a!dropdownField(
                label: "Proyecto",
                labelPosition: "COLLAPSED",
                placeholder: "Todos los proyectos",
                choiceLabels: {"Proyecto Alpha", "Proyecto Beta", "Proyecto Gamma", "Proyecto Delta"},
                choiceValues: {"alpha", "beta", "gamma", "delta"},
                value: local!projectFilter,
                saveInto: local!projectFilter
              )
            },
            width: "NARROW_PLUS"
          )
        },
        spacing: "STANDARD",
        marginBelow: "STANDARD"
      ),

      /* Results list */
      a!forEach(
        items: local!results,
        expression: a!cardLayout(
          contents: {
            a!columnsLayout(
              columns: {
                /* Main content */
                a!columnLayout(
                  contents: {
                    a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!stampField(
                            icon: fv!item.typeIcon,
                            backgroundColor: fv!item.typeColor,
                            contentColor: "#FFFFFF",
                            size: "TINY",
                            shape: "SEMI_ROUNDED",
                            labelPosition: "COLLAPSED"
                          ),
                          width: "MINIMIZE"
                        ),
                        a!sideBySideItem(
                          item: a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(text: fv!item.type, style: "STRONG", size: "MEDIUM"),
                              " ",
                              a!richTextItem(text: fv!item.version, color: "#9CA3AF", size: "SMALL"),
                              char(10),
                              a!richTextItem(
                                text: fv!item.executionId & " - " & fv!item.executionName,
                                color: "#6B7280",
                                size: "SMALL",
                                link: a!dynamicLink(value: fv!item.executionId, saveInto: local!selectedResult),
                                linkStyle: "STANDALONE"
                              )
                            }
                          ),
                          width: "AUTO"
                        ),
                        a!sideBySideItem(
                          item: a!tagField(
                            labelPosition: "COLLAPSED",
                            tags: {
                              a!tagItem(
                                text: fv!item.status,
                                backgroundColor: if(fv!item.status = "Final", "#059669", "#F59E0B")
                              ),
                              a!tagItem(text: fv!item.format, backgroundColor: "#EDEEF2", textColor: "#2E2E35")
                            },
                            size: "SMALL"
                          ),
                          width: "MINIMIZE"
                        )
                      },
                      alignVertical: "MIDDLE",
                      spacing: "STANDARD"
                    ),
                    /* Summary */
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: a!richTextItem(text: fv!item.summary, color: "#374151", size: "SMALL"),
                      marginAbove: "STANDARD"
                    ),
                    /* Metadata row */
                    a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextIcon(icon: "robot", color: "#9CA3AF", size: "SMALL"),
                              " ",
                              a!richTextItem(text: fv!item.generatedBy, color: "#6B7280", size: "SMALL"),
                              "  |  ",
                              a!richTextIcon(icon: "folder", color: "#9CA3AF", size: "SMALL"),
                              " ",
                              a!richTextItem(text: fv!item.project, color: "#6B7280", size: "SMALL"),
                              "  |  ",
                              a!richTextIcon(icon: "calendar", color: "#9CA3AF", size: "SMALL"),
                              " ",
                              a!richTextItem(text: fv!item.date, color: "#6B7280", size: "SMALL")
                            }
                          ),
                          width: "AUTO"
                        ),
                        a!sideBySideItem(
                          item: a!buttonArrayLayout(
                            buttons: {
                              a!buttonWidget(
                                label: "Ver Detalle",
                                icon: "eye",
                                style: "OUTLINE",
                                size: "SMALL",
                                saveInto: {}
                              ),
                              a!buttonWidget(
                                label: "Descargar",
                                icon: "download",
                                style: "GHOST",
                                size: "SMALL",
                                saveInto: {}
                              )
                            },
                            marginBelow: "NONE"
                          ),
                          width: "MINIMIZE"
                        )
                      },
                      alignVertical: "MIDDLE",
                      spacing: "STANDARD",
                      marginAbove: "STANDARD"
                    )
                  },
                  width: "AUTO"
                )
              }
            )
          },
          style: "NONE",
          shape: "ROUNDED",
          padding: "STANDARD",
          showBorder: true,
          marginBelow: "STANDARD"
        )
      )
    },
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE"
  )
)