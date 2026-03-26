/* ==========================================================================
 * ORQUESTADOR DE AGENTES - DETALLE DE AGENTE
 * ==========================================================================
 * Purpose: Detail view of a specific agent. Shows objective, usage context,
 *   expected inputs/outputs, dependencies, usage history, basic metrics,
 *   and recent incidents.
 *
 * REQUIREMENT: Clear functional view - not technical configuration.
 * REQUIREMENT: Show agent role within the orchestration system.
 * ========================================================================== */

a!localVariables(
  local!selectedTab: 1,
  local!tabs: {"Informacion General", "Historial de Uso", "Metricas", "Incidencias"},
  local!backgroundColor: "#FFFFFF",

  local!agent: a!map(
    id: 3,
    name: "Agente Revisor",
    specialty: "Revision de calidad",
    description: "Revisa resultados de otros agentes, detecta errores, inconsistencias y clausulas de riesgo. Especializado en analisis de documentos legales y contractuales.",
    type: "Validacion",
    status: "Activo",
    icon: "check-double",
    color: "#059669",
    version: "2.1.4",
    lastUpdated: "15 Mar 2026",
    successRate: 98,
    avgDuration: "7.2 min",
    totalExecutions: 176,
    executionsThisMonth: 34,
    humanReviewRequired: true
  ),

  local!inputs: {
    a!map(name: "Documentos estructurados", format: "JSON / a!map", description: "Datos extraidos y clasificados por agentes anteriores"),
    a!map(name: "Reglas de revision", format: "Configuracion", description: "Conjunto de reglas contra las que se valida el contenido"),
    a!map(name: "Umbral de riesgo", format: "Porcentaje", description: "Limite a partir del cual se solicita revision humana")
  },

  local!outputs: {
    a!map(name: "Informe de revision", format: "JSON / a!map", description: "Resultado detallado de la revision con hallazgos"),
    a!map(name: "Alertas de riesgo", format: "Lista", description: "Elementos que superan el umbral de riesgo configurado"),
    a!map(name: "Solicitud de revision humana", format: "Evento", description: "Generado cuando se detectan riesgos que requieren validacion")
  },

  local!dependencies: {
    a!map(name: "Agente Extractor", relation: "Proveedor de datos", description: "Proporciona los documentos estructurados para revision"),
    a!map(name: "Agente Clasificador", relation: "Proveedor de contexto", description: "Proporciona la clasificacion para contextualizar la revision")
  },

  local!recentHistory: {
    a!map(executionId: "EXE-2026-0412", date: "25 Mar 2026", duration: "En curso", result: "En progreso", items: 42),
    a!map(executionId: "EXE-2026-0406", date: "23 Mar 2026", duration: "8 min", result: "Exitoso", items: 28),
    a!map(executionId: "EXE-2026-0399", date: "20 Mar 2026", duration: "12 min", result: "Exitoso con alertas", items: 55),
    a!map(executionId: "EXE-2026-0391", date: "18 Mar 2026", duration: "6 min", result: "Exitoso", items: 15),
    a!map(executionId: "EXE-2026-0385", date: "15 Mar 2026", duration: "9 min", result: "Exitoso", items: 33)
  },

  local!incidents: {
    a!map(date: "20 Mar 2026", type: "Alerta", description: "Tiempo de respuesta superior al esperado (12 min vs 8 min avg) por volumen elevado.", resolution: "Procesado correctamente."),
    a!map(date: "10 Mar 2026", type: "Error", description: "Error de conexion con servicio externo de validacion normativa. Reintento exitoso.", resolution: "Reintento automatico resolvio el problema.")
  },

  a!headerContentLayout(
    header: {
      a!cardLayout(
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextItem(
                text: "Volver al Catalogo",
                color: "#94A3B8",
                size: "SMALL",
                link: a!dynamicLink(value: true, saveInto: {}),
                linkStyle: "STANDALONE"
              )
            },
            marginBelow: "STANDARD"
          ),
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!stampField(
                  icon: local!agent.icon,
                  backgroundColor: local!agent.color,
                  contentColor: "#FFFFFF",
                  size: "SMALL",
                  shape: "SEMI_ROUNDED",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextItem(
                      text: local!agent.name,
                      size: "LARGE",
                      style: "STRONG",
                      color: "#FFFFFF"
                    ),
                    char(10),
                    a!richTextItem(
                      text: local!agent.specialty & "  |  v" & local!agent.version,
                      color: "#94A3B8",
                      size: "STANDARD"
                    )
                  }
                ),
                width: "AUTO"
              ),
              a!sideBySideItem(
                item: a!tagField(
                  labelPosition: "COLLAPSED",
                  tags: {
                    a!tagItem(text: local!agent.status, backgroundColor: "#059669"),
                    a!tagItem(text: local!agent.type, backgroundColor: "#EDEEF2", textColor: "#2E2E35")
                  },
                  size: "STANDARD"
                ),
                width: "MINIMIZE"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
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
      /* KPI Summary */
      a!cardGroupLayout(
        cards: {
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Ejecuciones Totales", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: text(local!agent.totalExecutions, "##,###"), style: "STRONG", size: "LARGE")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
          ),
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Este Mes", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: text(local!agent.executionsThisMonth, "##,###"), style: "STRONG", size: "LARGE")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
          ),
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Tasa de Exito", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: local!agent.successRate & "%", style: "STRONG", size: "LARGE", color: "#059669")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
          ),
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Duracion Media", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: local!agent.avgDuration, style: "STRONG", size: "LARGE")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
          )
        },
        cardWidth: "NARROW_PLUS",
        spacing: "STANDARD"
      ),

      /* Tabs */
      a!cardLayout(
        contents: {
          a!cardLayout(
            contents: {
              a!columnsLayout(
                columns: {
                  a!forEach(
                    items: local!tabs,
                    expression: a!columnLayout(
                      contents: {
                        a!cardLayout(
                          contents: {
                            a!richTextDisplayField(
                              labelPosition: "COLLAPSED",
                              value: a!richTextItem(
                                text: fv!item,
                                color: "STANDARD",
                                size: "STANDARD",
                                style: if(fv!index = local!selectedTab, "STRONG", "PLAIN")
                              ),
                              align: "CENTER",
                              marginAbove: "STANDARD",
                              marginBelow: "LESS"
                            )
                          },
                          link: if(fv!index = local!selectedTab, {}, a!dynamicLink(value: fv!index, saveInto: local!selectedTab)),
                          height: "AUTO",
                          style: "NONE",
                          padding: "EVEN_LESS",
                          marginBelow: "NONE",
                          showBorder: false,
                          decorativeBarPosition: "BOTTOM",
                          decorativeBarColor: if(fv!index = local!selectedTab, "ACCENT", local!backgroundColor),
                          accessibilityText: if(fv!index = local!selectedTab, "Tab Selected", "Tab")
                        )
                      },
                      width: "NARROW"
                    )
                  ),
                  a!columnLayout(width: "AUTO")
                },
                marginBelow: "NONE",
                spacing: "NONE",
                showDividers: false
              )
            },
            height: "AUTO", style: "NONE", padding: "NONE", marginBelow: "NONE", showBorder: false, showShadow: false
          ),

          /* Tab 1: General Info */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: a!richTextItem(text: local!agent.description, color: "#374151"),
                marginBelow: "MORE"
              ),

              /* Inputs */
              a!headingField(text: "Entradas Esperadas", size: "MEDIUM", headingTag: "H3", fontWeight: "SEMI_BOLD", marginBelow: "STANDARD"),
              a!forEach(
                items: local!inputs,
                expression: a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextIcon(icon: "sign-in", color: "#3B82F6", size: "STANDARD")
                      ),
                      width: "MINIMIZE"
                    ),
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(text: fv!item.name, style: "STRONG"),
                          " ",
                          a!richTextItem(text: "(" & fv!item.format & ")", color: "#9CA3AF", size: "SMALL"),
                          char(10),
                          a!richTextItem(text: fv!item.description, color: "#6B7280", size: "SMALL")
                        }
                      ),
                      width: "AUTO"
                    )
                  },
                  alignVertical: "TOP",
                  spacing: "STANDARD",
                  marginBelow: if(fv!isLast, "MORE", "STANDARD")
                )
              ),

              /* Outputs */
              a!headingField(text: "Salidas Esperadas", size: "MEDIUM", headingTag: "H3", fontWeight: "SEMI_BOLD", marginBelow: "STANDARD"),
              a!forEach(
                items: local!outputs,
                expression: a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextIcon(icon: "sign-out", color: "#059669", size: "STANDARD")
                      ),
                      width: "MINIMIZE"
                    ),
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(text: fv!item.name, style: "STRONG"),
                          " ",
                          a!richTextItem(text: "(" & fv!item.format & ")", color: "#9CA3AF", size: "SMALL"),
                          char(10),
                          a!richTextItem(text: fv!item.description, color: "#6B7280", size: "SMALL")
                        }
                      ),
                      width: "AUTO"
                    )
                  },
                  alignVertical: "TOP",
                  spacing: "STANDARD",
                  marginBelow: if(fv!isLast, "MORE", "STANDARD")
                )
              ),

              /* Dependencies */
              a!headingField(text: "Dependencias Funcionales", size: "MEDIUM", headingTag: "H3", fontWeight: "SEMI_BOLD", marginBelow: "STANDARD"),
              a!forEach(
                items: local!dependencies,
                expression: a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextIcon(icon: "link", color: "#8B5CF6", size: "STANDARD")
                      ),
                      width: "MINIMIZE"
                    ),
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(text: fv!item.name, style: "STRONG"),
                          " - ",
                          a!richTextItem(text: fv!item.relation, color: "#8B5CF6", size: "SMALL"),
                          char(10),
                          a!richTextItem(text: fv!item.description, color: "#6B7280", size: "SMALL")
                        }
                      ),
                      width: "AUTO"
                    )
                  },
                  alignVertical: "TOP",
                  spacing: "STANDARD",
                  marginBelow: if(fv!isLast, "NONE", "STANDARD")
                )
              )
            },
            height: "AUTO", style: "NONE", padding: "STANDARD", marginBelow: "NONE", showBorder: false,
            showWhen: local!selectedTab = 1
          ),

          /* Tab 2: Usage History */
          a!cardLayout(
            contents: {
              a!gridField(
                data: local!recentHistory,
                columns: {
                  a!gridColumn(label: "Ejecucion", value: a!richTextDisplayField(labelPosition: "COLLAPSED", value: a!richTextItem(text: fv!row.executionId, style: "STRONG", link: a!dynamicLink(value: fv!row.executionId, saveInto: {}), linkStyle: "STANDALONE")), width: "NARROW_PLUS", sortField: "executionId"),
                  a!gridColumn(label: "Fecha", value: fv!row.date, width: "NARROW_PLUS", sortField: "date"),
                  a!gridColumn(label: "Duracion", value: fv!row.duration, width: "NARROW"),
                  a!gridColumn(label: "Items", value: fv!row.items, width: "NARROW", sortField: "items"),
                  a!gridColumn(label: "Resultado", value: a!tagField(labelPosition: "COLLAPSED", tags: a!tagItem(text: fv!row.result, backgroundColor: if(fv!row.result = "Exitoso", "#059669", if(fv!row.result = "En progreso", "#3B82F6", "#F59E0B"))), size: "SMALL"), width: "NARROW_PLUS", sortField: "result")
                },
                pageSize: 10,
                spacing: "DENSE",
                borderStyle: "LIGHT",
                emptyGridMessage: "No hay historial de uso disponible."
              )
            },
            height: "AUTO", style: "NONE", padding: "STANDARD", marginBelow: "NONE", showBorder: false,
            showWhen: local!selectedTab = 2
          ),

          /* Tab 3: Metrics */
          a!cardLayout(
            contents: {
              a!gaugeField(
                percentage: local!agent.successRate,
                primaryText: local!agent.successRate & "%",
                secondaryText: "Tasa de Exito",
                color: "#059669",
                size: "MEDIUM",
                labelPosition: "COLLAPSED",
                marginBelow: "MORE"
              ),
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Duracion promedio: ", style: "STRONG"),
                  a!richTextItem(text: local!agent.avgDuration),
                  char(10),
                  a!richTextItem(text: "Ejecuciones este mes: ", style: "STRONG"),
                  a!richTextItem(text: text(local!agent.executionsThisMonth, "##,###")),
                  char(10),
                  a!richTextItem(text: "Ultima actualizacion: ", style: "STRONG"),
                  a!richTextItem(text: local!agent.lastUpdated),
                  char(10),
                  a!richTextItem(text: "Revision humana: ", style: "STRONG"),
                  a!richTextItem(
                    text: if(local!agent.humanReviewRequired, "Requerida", "No requerida"),
                    color: if(local!agent.humanReviewRequired, "#F59E0B", "#059669")
                  )
                }
              )
            },
            height: "AUTO", style: "NONE", padding: "STANDARD", marginBelow: "NONE", showBorder: false,
            showWhen: local!selectedTab = 3
          ),

          /* Tab 4: Incidents */
          a!cardLayout(
            contents: {
              a!forEach(
                items: local!incidents,
                expression: a!cardLayout(
                  contents: {
                    a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!stampField(
                            icon: if(fv!item.type = "Error", "times-circle", "exclamation-triangle"),
                            backgroundColor: if(fv!item.type = "Error", "#DC2626", "#F59E0B"),
                            contentColor: "#FFFFFF",
                            size: "TINY",
                            shape: "ROUNDED",
                            labelPosition: "COLLAPSED"
                          ),
                          width: "MINIMIZE"
                        ),
                        a!sideBySideItem(
                          item: a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: {
                              a!richTextItem(text: fv!item.type & " - " & fv!item.date, style: "STRONG"),
                              char(10),
                              a!richTextItem(text: fv!item.description, color: "#374151", size: "SMALL"),
                              char(10),
                              a!richTextIcon(icon: "check", color: "#059669", size: "SMALL"),
                              " ",
                              a!richTextItem(text: fv!item.resolution, color: "#059669", size: "SMALL")
                            }
                          ),
                          width: "AUTO"
                        )
                      },
                      alignVertical: "TOP",
                      spacing: "STANDARD"
                    )
                  },
                  style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true, marginBelow: "LESS"
                )
              )
            },
            height: "AUTO", style: "NONE", padding: "STANDARD", marginBelow: "NONE", showBorder: false,
            showWhen: local!selectedTab = 4
          )
        },
        height: "AUTO",
        style: "TRANSPARENT",
        padding: "NONE",
        marginBelow: "STANDARD",
        showBorder: false
      )
    },
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE"
  )
)