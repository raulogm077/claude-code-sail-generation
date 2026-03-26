/* ==========================================================================
 * ORQUESTADOR DE AGENTES - DETALLE DE EJECUCION
 * ==========================================================================
 * Purpose: Detailed view of a specific execution. Shows header with status,
 *   visual progress by stages, event timeline, agent list with states,
 *   inputs/outputs, orchestrator decisions, and final results.
 *
 * REQUIREMENT: Show clear status progression per agent.
 * REQUIREMENT: Display timeline of events with timestamps.
 * REQUIREMENT: Allow user to approve/reject at human review checkpoints.
 * ========================================================================== */

a!localVariables(
  local!selectedTab: 1,
  local!tabs: {
    a!map(title: "Pipeline de Agentes", badge: "0"),
    a!map(title: "Timeline de Eventos", badge: "12"),
    a!map(title: "Resultados", badge: "0"),
    a!map(title: "Decisiones", badge: "3")
  },
  local!backgroundColor: "#FFFFFF",

  /* Execution header data */
  local!execution: a!map(
    id: "EXE-2026-0412",
    name: "Analisis Contractual Q1",
    project: "Proyecto Alpha",
    status: "En Curso",
    priority: "Alta",
    startDate: datetime(2026, 3, 25, 9, 15),
    description: "Analisis completo de contratos del primer trimestre para identificar clausulas de riesgo y oportunidades de optimizacion.",
    orchestrationType: "Secuencial",
    progress: 60,
    currentPhase: "Agente Revisor",
    totalAgents: 4,
    completedAgents: 2,
    createdBy: "Maria Garcia"
  ),

  /* Agent pipeline data */
  local!agentPipeline: {
    a!map(
      order: 1,
      name: "Agente Extractor",
      icon: "download",
      color: "#3B82F6",
      status: "Completado",
      startTime: "09:15",
      endTime: "09:23",
      duration: "8 min",
      input: "42 documentos PDF del repositorio contractual Q1",
      output: "Datos estructurados de 42 contratos extraidos correctamente",
      humanReview: false()
    ),
    a!map(
      order: 2,
      name: "Agente Clasificador",
      icon: "tags",
      color: "#8B5CF6",
      status: "Completado",
      startTime: "09:24",
      endTime: "09:31",
      duration: "7 min",
      input: "42 contratos estructurados",
      output: "Clasificados: 18 Compraventa, 12 Servicios, 8 Licencia, 4 Colaboracion",
      humanReview: false()
    ),
    a!map(
      order: 3,
      name: "Agente Revisor",
      icon: "check-double",
      color: "#059669",
      status: "En Curso",
      startTime: "09:32",
      endTime: "",
      duration: "En progreso...",
      input: "42 contratos clasificados para revision de clausulas de riesgo",
      output: "",
      humanReview: true()
    ),
    a!map(
      order: 4,
      name: "Agente Generador",
      icon: "file-text",
      color: "#F59E0B",
      status: "Pendiente",
      startTime: "",
      endTime: "",
      duration: "",
      input: "",
      output: "",
      humanReview: false()
    )
  },

  /* Timeline events */
  local!timelineEvents: {
    a!map(time: "09:15", event: "Ejecucion iniciada", type: "info", detail: "Lanzada por Maria Garcia con prioridad Alta"),
    a!map(time: "09:15", event: "Agente Extractor iniciado", type: "start", detail: "Procesando 42 documentos del repositorio"),
    a!map(time: "09:23", event: "Agente Extractor completado", type: "success", detail: "42/42 documentos procesados sin errores"),
    a!map(time: "09:24", event: "Agente Clasificador iniciado", type: "start", detail: "Clasificando contratos por tipo"),
    a!map(time: "09:31", event: "Agente Clasificador completado", type: "success", detail: "4 categorias identificadas"),
    a!map(time: "09:31", event: "Decision del Orquestador", type: "decision", detail: "Todos los contratos clasificados correctamente. Procediendo a revision."),
    a!map(time: "09:32", event: "Agente Revisor iniciado", type: "start", detail: "Analizando clausulas de riesgo en 42 contratos"),
    a!map(time: "09:40", event: "Revision humana solicitada", type: "warning", detail: "Se detectaron 7 contratos con clausulas de alto riesgo. Requiere validacion.")
  },

  /* Orchestrator decisions */
  local!decisions: {
    a!map(
      time: "09:23",
      decision: "Continuar pipeline",
      reason: "Extraccion exitosa: 42/42 documentos procesados. Tasa de exito 100%.",
      action: "Avanzar al Agente Clasificador"
    ),
    a!map(
      time: "09:31",
      decision: "Continuar pipeline",
      reason: "Clasificacion completa. Distribucion coherente entre categorias.",
      action: "Avanzar al Agente Revisor"
    ),
    a!map(
      time: "09:40",
      decision: "Solicitar revision humana",
      reason: "7 contratos con clausulas de alto riesgo detectadas. Umbral de riesgo superado.",
      action: "Pausar pipeline y solicitar validacion humana"
    )
  },

  a!headerContentLayout(
    header: {
      a!cardLayout(
        contents: {
          /* Back navigation */
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(icon: "arrow-left", color: "#94A3B8", size: "SMALL"),
              " ",
              a!richTextItem(
                text: "Volver al Dashboard",
                color: "#94A3B8",
                size: "SMALL",
                link: a!dynamicLink(value: true, saveInto: {}),
                linkStyle: "STANDALONE"
              )
            },
            marginBelow: "STANDARD"
          ),

          /* Execution header */
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextItem(
                        text: local!execution.id,
                        color: "#94A3B8",
                        size: "STANDARD"
                      ),
                      char(10),
                      a!richTextItem(
                        text: local!execution.name,
                        color: "#FFFFFF",
                        size: "LARGE",
                        style: "STRONG"
                      ),
                      char(10),
                      a!richTextItem(
                        text: local!execution.project & "  |  " & local!execution.orchestrationType & "  |  Creado por " & local!execution.createdBy,
                        color: "#94A3B8",
                        size: "SMALL"
                      )
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!tagField(
                    labelPosition: "COLLAPSED",
                    tags: {
                      a!tagItem(
                        text: local!execution.status,
                        backgroundColor: "#3B82F6"
                      ),
                      a!tagItem(
                        text: "Prioridad: " & local!execution.priority,
                        backgroundColor: "#DC2626"
                      )
                    },
                    size: "STANDARD",
                    marginBelow: "STANDARD"
                  ),
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: "Pausar",
                        icon: "pause",
                        style: "OUTLINE",
                        color: "#FFFFFF",
                        size: "SMALL",
                        saveInto: {}
                      ),
                      a!buttonWidget(
                        label: "Cancelar Ejecucion",
                        icon: "stop",
                        style: "OUTLINE",
                        color: "#FFFFFF",
                        size: "SMALL",
                        saveInto: {}
                      )
                    },
                    align: "END",
                    marginBelow: "NONE"
                  )
                },
                width: "MEDIUM"
              )
            },
            alignVertical: "TOP"
          ),

          /* Progress bar */
          a!progressBarField(
            percentage: local!execution.progress,
            color: "#3B82F6",
            style: "THICK",
            showPercentage: false,
            labelPosition: "COLLAPSED",
            marginAbove: "STANDARD",
            marginBelow: "NONE"
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
      /* Progress summary bar */
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "cogs", color: "#3B82F6", size: "STANDARD"),
                      " ",
                      a!richTextItem(text: "Fase actual: ", color: "#6B7280"),
                      a!richTextItem(text: local!execution.currentPhase, style: "STRONG")
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "check", color: "#059669", size: "STANDARD"),
                      " ",
                      a!richTextItem(
                        text: local!execution.completedAgents & " de " & local!execution.totalAgents & " agentes completados",
                        style: "STRONG"
                      )
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "clock", color: "#F59E0B", size: "STANDARD"),
                      " ",
                      a!richTextItem(text: "Inicio: 09:15  |  Progreso: " & local!execution.progress & "%", style: "STRONG")
                    }
                  )
                },
                width: "AUTO"
              )
            },
            alignVertical: "MIDDLE"
          )
        },
        style: "NONE",
        shape: "ROUNDED",
        padding: "STANDARD",
        showBorder: true,
        marginBelow: "STANDARD"
      ),

      /* =====================================================================
       * TABBED CONTENT
       * ===================================================================== */
      a!cardLayout(
        contents: {
          /* Tab bar */
          a!cardLayout(
            contents: {
              a!columnsLayout(
                columns: {
                  a!forEach(
                    items: local!tabs,
                    expression: {
                      a!columnLayout(
                        contents: {
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      labelPosition: "COLLAPSED",
                                      value: {
                                        a!richTextItem(
                                          text: fv!item.title,
                                          color: "STANDARD",
                                          size: "STANDARD",
                                          style: if(
                                            fv!index = local!selectedTab,
                                            "STRONG",
                                            "PLAIN"
                                          )
                                        )
                                      },
                                      align: "CENTER",
                                      marginBelow: "NONE"
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  if(
                                    tointeger(fv!item.badge) > 0,
                                    a!sideBySideItem(
                                      item: a!tagField(
                                        labelPosition: "COLLAPSED",
                                        tags: a!tagItem(
                                          text: fv!item.badge,
                                          backgroundColor: "#EDEEF2",
                                          textColor: "#2E2E35"
                                        ),
                                        size: "SMALL",
                                        marginBelow: "NONE"
                                      ),
                                      width: "MINIMIZE"
                                    ),
                                    {}
                                  ),
                                  a!sideBySideItem()
                                },
                                alignVertical: "BOTTOM",
                                spacing: "NONE",
                                marginAbove: "STANDARD",
                                marginBelow: "LESS"
                              )
                            },
                            link: if(
                              fv!index = local!selectedTab,
                              {},
                              a!dynamicLink(value: fv!index, saveInto: local!selectedTab)
                            ),
                            height: "AUTO",
                            style: "NONE",
                            padding: "EVEN_LESS",
                            marginBelow: "NONE",
                            showBorder: false,
                            decorativeBarPosition: "BOTTOM",
                            decorativeBarColor: if(
                              fv!index = local!selectedTab,
                              "ACCENT",
                              local!backgroundColor
                            ),
                            accessibilityText: if(fv!index = local!selectedTab, "Tab Selected", "Tab")
                          )
                        },
                        width: "NARROW"
                      )
                    }
                  ),
                  a!columnLayout(width: "AUTO")
                },
                marginBelow: "NONE",
                spacing: "NONE",
                showDividers: false
              )
            },
            height: "AUTO",
            style: "NONE",
            padding: "NONE",
            marginBelow: "NONE",
            showBorder: false,
            showShadow: false
          ),

          /* Tab 1: Agent Pipeline */
          a!cardLayout(
            contents: {
              a!forEach(
                items: local!agentPipeline,
                expression: {
                  a!cardLayout(
                    contents: {
                      a!columnsLayout(
                        columns: {
                          /* Agent info column */
                          a!columnLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!stampField(
                                      icon: fv!item.icon,
                                      backgroundColor: fv!item.color,
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
                                        a!richTextItem(
                                          text: "Paso " & fv!item.order & ": " & fv!item.name,
                                          style: "STRONG",
                                          size: "MEDIUM"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: if(
                                            a!isNotNullOrEmpty(fv!item.duration),
                                            fv!item.startTime & " - " & a!defaultValue(fv!item.endTime, "...") & " (" & fv!item.duration & ")",
                                            "Pendiente de ejecucion"
                                          ),
                                          color: "#6B7280",
                                          size: "SMALL"
                                        )
                                      }
                                    ),
                                    width: "AUTO"
                                  ),
                                  a!sideBySideItem(
                                    item: a!tagField(
                                      labelPosition: "COLLAPSED",
                                      tags: a!tagItem(
                                        text: fv!item.status,
                                        backgroundColor: a!match(
                                          value: fv!item.status,
                                          equals: "Completado",
                                          then: "#059669",
                                          equals: "En Curso",
                                          then: "#3B82F6",
                                          equals: "Error",
                                          then: "#DC2626",
                                          default: "#6B7280"
                                        )
                                      ),
                                      size: "SMALL"
                                    ),
                                    width: "MINIMIZE"
                                  )
                                },
                                alignVertical: "MIDDLE",
                                spacing: "STANDARD"
                              )
                            },
                            width: "AUTO"
                          )
                        }
                      ),
                      /* Input/Output details */
                      if(
                        a!isNotNullOrEmpty(fv!item.input),
                        a!columnsLayout(
                          columns: {
                            a!columnLayout(
                              contents: {
                                a!richTextDisplayField(
                                  labelPosition: "COLLAPSED",
                                  value: {
                                    a!richTextIcon(icon: "sign-in", color: "#6B7280", size: "SMALL"),
                                    " ",
                                    a!richTextItem(text: "Entrada: ", style: "STRONG", size: "SMALL"),
                                    a!richTextItem(text: fv!item.input, color: "#6B7280", size: "SMALL")
                                  }
                                )
                              }
                            ),
                            a!columnLayout(
                              contents: {
                                a!richTextDisplayField(
                                  labelPosition: "COLLAPSED",
                                  value: if(
                                    a!isNotNullOrEmpty(fv!item.output),
                                    {
                                      a!richTextIcon(icon: "sign-out", color: "#059669", size: "SMALL"),
                                      " ",
                                      a!richTextItem(text: "Salida: ", style: "STRONG", size: "SMALL"),
                                      a!richTextItem(text: fv!item.output, color: "#6B7280", size: "SMALL")
                                    },
                                    {
                                      a!richTextIcon(icon: "hourglass-half", color: "#F59E0B", size: "SMALL"),
                                      " ",
                                      a!richTextItem(text: "Esperando resultado...", color: "#F59E0B", size: "SMALL")
                                    }
                                  )
                                )
                              }
                            )
                          }
                        ),
                        {}
                      ),
                      /* Human review action */
                      if(
                        and(fv!item.humanReview, fv!item.status = "En Curso"),
                        a!cardLayout(
                          contents: {
                            a!sideBySideLayout(
                              items: {
                                a!sideBySideItem(
                                  item: a!richTextDisplayField(
                                    labelPosition: "COLLAPSED",
                                    value: {
                                      a!richTextIcon(icon: "user-check", color: "#F59E0B", size: "MEDIUM"),
                                      " ",
                                      a!richTextItem(
                                        text: "Este paso requiere revision humana",
                                        style: "STRONG",
                                        color: "#F59E0B"
                                      )
                                    }
                                  ),
                                  width: "AUTO"
                                ),
                                a!sideBySideItem(
                                  item: a!buttonArrayLayout(
                                    buttons: {
                                      a!buttonWidget(
                                        label: "Aprobar",
                                        icon: "check",
                                        style: "SOLID",
                                        color: "#059669",
                                        size: "SMALL",
                                        saveInto: {}
                                      ),
                                      a!buttonWidget(
                                        label: "Rechazar",
                                        icon: "times",
                                        style: "OUTLINE",
                                        color: "NEGATIVE",
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
                              spacing: "STANDARD"
                            )
                          },
                          style: "#FEF3C7",
                          shape: "ROUNDED",
                          padding: "STANDARD",
                          showBorder: false,
                          marginAbove: "STANDARD"
                        ),
                        {}
                      )
                    },
                    style: "NONE",
                    shape: "ROUNDED",
                    padding: "STANDARD",
                    showBorder: true,
                    marginBelow: "LESS"
                  ),
                  /* Connector line between agents */
                  if(
                    not(fv!isLast),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: a!richTextIcon(icon: "angle-down", color: "#CBD5E1", size: "MEDIUM"),
                      align: "CENTER",
                      marginBelow: "LESS"
                    ),
                    {}
                  )
                }
              )
            },
            height: "AUTO",
            style: "NONE",
            padding: "STANDARD",
            marginBelow: "NONE",
            showBorder: false,
            showWhen: local!selectedTab = 1
          ),

          /* Tab 2: Timeline */
          a!cardLayout(
            contents: {
              a!forEach(
                items: local!timelineEvents,
                expression: a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(
                          text: fv!item.time,
                          color: "#6B7280",
                          size: "SMALL",
                          style: "STRONG"
                        ),
                        align: "RIGHT"
                      ),
                      width: "MINIMIZE"
                    ),
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextIcon(
                          icon: a!match(
                            value: fv!item.type,
                            equals: "success",
                            then: "check-circle",
                            equals: "start",
                            then: "play-circle",
                            equals: "warning",
                            then: "exclamation-triangle",
                            equals: "decision",
                            then: "random",
                            equals: "error",
                            then: "times-circle",
                            default: "info-circle"
                          ),
                          color: a!match(
                            value: fv!item.type,
                            equals: "success",
                            then: "#059669",
                            equals: "start",
                            then: "#3B82F6",
                            equals: "warning",
                            then: "#F59E0B",
                            equals: "decision",
                            then: "#8B5CF6",
                            equals: "error",
                            then: "#DC2626",
                            default: "#6B7280"
                          ),
                          size: "MEDIUM"
                        )
                      ),
                      width: "MINIMIZE"
                    ),
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: {
                          a!richTextItem(
                            text: fv!item.event,
                            style: "STRONG",
                            size: "STANDARD"
                          ),
                          char(10),
                          a!richTextItem(
                            text: fv!item.detail,
                            color: "#6B7280",
                            size: "SMALL"
                          )
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
            height: "AUTO",
            style: "NONE",
            padding: "STANDARD",
            marginBelow: "NONE",
            showBorder: false,
            showWhen: local!selectedTab = 2
          ),

          /* Tab 3: Results */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "hourglass-half", color: "#F59E0B", size: "LARGE"),
                  char(10),
                  char(10),
                  a!richTextItem(
                    text: "Ejecucion en curso",
                    size: "MEDIUM",
                    style: "STRONG"
                  ),
                  char(10),
                  a!richTextItem(
                    text: "Los resultados finales estaran disponibles cuando se complete la ejecucion. Actualmente en la fase: " & local!execution.currentPhase,
                    color: "#6B7280"
                  )
                },
                align: "CENTER"
              )
            },
            height: "AUTO",
            style: "NONE",
            padding: "MORE",
            marginBelow: "NONE",
            showBorder: false,
            showWhen: local!selectedTab = 3
          ),

          /* Tab 4: Decisions */
          a!cardLayout(
            contents: {
              a!forEach(
                items: local!decisions,
                expression: a!cardLayout(
                  contents: {
                    a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!stampField(
                            icon: "random",
                            backgroundColor: "#8B5CF6",
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
                              a!richTextItem(
                                text: fv!item.decision,
                                style: "STRONG",
                                size: "MEDIUM"
                              ),
                              " ",
                              a!richTextItem(
                                text: "(" & fv!item.time & ")",
                                color: "#9CA3AF",
                                size: "SMALL"
                              ),
                              char(10),
                              a!richTextItem(
                                text: "Razon: ",
                                style: "STRONG",
                                size: "SMALL"
                              ),
                              a!richTextItem(
                                text: fv!item.reason,
                                color: "#6B7280",
                                size: "SMALL"
                              ),
                              char(10),
                              a!richTextIcon(icon: "arrow-right", color: "#8B5CF6", size: "SMALL"),
                              " ",
                              a!richTextItem(
                                text: fv!item.action,
                                color: "#8B5CF6",
                                size: "SMALL",
                                style: "STRONG"
                              )
                            }
                          ),
                          width: "AUTO"
                        )
                      },
                      alignVertical: "TOP",
                      spacing: "STANDARD"
                    )
                  },
                  style: "NONE",
                  shape: "ROUNDED",
                  padding: "STANDARD",
                  showBorder: true,
                  marginBelow: "LESS"
                )
              )
            },
            height: "AUTO",
            style: "NONE",
            padding: "STANDARD",
            marginBelow: "NONE",
            showBorder: false,
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