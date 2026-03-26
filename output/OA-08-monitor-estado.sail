/* ==========================================================================
 * ORQUESTADOR DE AGENTES - MONITOR DE ESTADO / OPERACIONES
 * ==========================================================================
 * Purpose: Operations monitoring screen to detect stuck executions,
 *   excessive times, frequent errors, human wait points, bottlenecks.
 *
 * REQUIREMENT: Operational visualizations and useful filters.
 * REQUIREMENT: Detect stuck executions, excessive times, frequent errors.
 * ========================================================================== */

a!localVariables(
  local!timeRange: "24h",
  local!selectedExecution,

  /* Operational KPIs */
  local!stuckExecutions: 2,
  local!avgResponseTime: "8.4 min",
  local!humanWaitAvg: "2.3 hrs",
  local!errorRateToday: "4.2%",
  local!activeNow: 5,
  local!queuedTasks: 8,

  /* Stuck/slow executions */
  local!problematicExecutions: {
    a!map(id: "EXE-2026-0408", name: "Validacion Normativa RGPD", status: "Atascada", agent: "Agente Validador", waitTime: "6h 15min", issue: "Sin respuesta del servicio externo de validacion", severity: "Alta"),
    a!map(id: "EXE-2026-0405", name: "Clasificacion Lote 48", status: "Espera Humana", agent: "Agente Clasificador", waitTime: "4h 30min", issue: "Pendiente revision humana - baja confianza", severity: "Media"),
    a!map(id: "EXE-2026-0411", name: "Informe Financiero", status: "Espera Humana", agent: "Agente Generador", waitTime: "3h 10min", issue: "Pendiente aprobacion de contenido generado", severity: "Media"),
    a!map(id: "EXE-2026-0412", name: "Analisis Contractual Q1", status: "Lenta", agent: "Agente Revisor", waitTime: "1h 45min", issue: "Procesando volumen elevado (42 documentos)", severity: "Baja")
  },

  /* Error summary */
  local!recentErrors: {
    a!map(time: "Hace 2h", execution: "EXE-2026-0409", agent: "Agente Extractor", error: "Timeout al procesar documento protegido", count: 3),
    a!map(time: "Hace 6h", execution: "EXE-2026-0408", agent: "Agente Validador", error: "Servicio externo no disponible (HTTP 503)", count: 5),
    a!map(time: "Hace 1d", execution: "EXE-2026-0396", agent: "Agente Clasificador", error: "Modelo de clasificacion retorno confianza < 30%", count: 2)
  },

  /* Agent health */
  local!agentHealth: {
    a!map(name: "Agente Extractor", status: "Operativo", load: 65, activeJobs: 2, avgTime: "7.1 min", errors24h: 3, icon: "download", color: "#3B82F6"),
    a!map(name: "Agente Clasificador", status: "Operativo", load: 40, activeJobs: 1, avgTime: "5.8 min", errors24h: 0, icon: "tags", color: "#8B5CF6"),
    a!map(name: "Agente Revisor", status: "Alta Carga", load: 85, activeJobs: 3, avgTime: "9.2 min", errors24h: 0, icon: "check-double", color: "#059669"),
    a!map(name: "Agente Generador", status: "Operativo", load: 30, activeJobs: 1, avgTime: "6.5 min", errors24h: 0, icon: "file-text", color: "#F59E0B"),
    a!map(name: "Agente Validador", status: "Degradado", load: 95, activeJobs: 1, avgTime: "15.3 min", errors24h: 5, icon: "shield", color: "#DC2626"),
    a!map(name: "Agente Resumidor", status: "Inactivo", load: 0, activeJobs: 0, avgTime: "0 min", errors24h: 0, icon: "compress", color: "#EC4899")
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
                      a!richTextIcon(icon: "tachometer", color: "#94A3B8", size: "MEDIUM"),
                      " ",
                      a!richTextItem(text: "Monitor de Operaciones", size: "LARGE", style: "STRONG", color: "#FFFFFF")
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Periodo",
                    labelPosition: "COLLAPSED",
                    choiceLabels: {"Ultima hora", "Ultimas 24h", "Ultima semana", "Ultimo mes"},
                    choiceValues: {"1h", "24h", "7d", "30d"},
                    value: local!timeRange,
                    saveInto: local!timeRange
                  )
                },
                width: "NARROW_PLUS"
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
      /* Operational KPIs */
      a!cardGroupLayout(
        cards: {
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Ejecuciones Atascadas", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: text(local!stuckExecutions, "0"), style: "STRONG", size: "LARGE", color: "#DC2626")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true,
            decorativeBarPosition: "TOP", decorativeBarColor: "#DC2626"
          ),
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Tiempo Resp. Medio", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: local!avgResponseTime, style: "STRONG", size: "LARGE")
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
                  a!richTextItem(text: "Espera Humana Media", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: local!humanWaitAvg, style: "STRONG", size: "LARGE", color: "#F59E0B")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true,
            decorativeBarPosition: "TOP", decorativeBarColor: "#F59E0B"
          ),
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Tasa de Error (24h)", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: local!errorRateToday, style: "STRONG", size: "LARGE")
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
                  a!richTextItem(text: "Activas Ahora", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: text(local!activeNow, "0"), style: "STRONG", size: "LARGE", color: "#3B82F6")
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
                  a!richTextItem(text: "En Cola", color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextItem(text: text(local!queuedTasks, "0"), style: "STRONG", size: "LARGE")
                }
              )
            },
            style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
          )
        },
        cardWidth: "NARROW_PLUS",
        spacing: "STANDARD"
      ),

      a!columnsLayout(
        columns: {
          /* LEFT - Problematic executions */
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!sideBySideLayout(
                    items: {
                      a!sideBySideItem(
                        item: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextIcon(icon: "exclamation-triangle", color: "#DC2626", size: "MEDIUM"),
                            " ",
                            a!richTextItem(text: "Ejecuciones Problematicas", size: "MEDIUM", style: "STRONG")
                          }
                        ),
                        width: "AUTO"
                      ),
                      a!sideBySideItem(
                        item: a!tagField(
                          labelPosition: "COLLAPSED",
                          tags: a!tagItem(text: text(length(local!problematicExecutions), "0"), backgroundColor: "#DC2626"),
                          size: "SMALL"
                        ),
                        width: "MINIMIZE"
                      )
                    },
                    alignVertical: "MIDDLE",
                    marginBelow: "STANDARD"
                  ),
                  a!forEach(
                    items: local!problematicExecutions,
                    expression: a!cardLayout(
                      contents: {
                        a!sideBySideLayout(
                          items: {
                            a!sideBySideItem(
                              item: a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                value: a!richTextIcon(
                                  icon: a!match(
                                    value: fv!item.status,
                                    equals: "Atascada",
                                    then: "ban",
                                    equals: "Espera Humana",
                                    then: "user-clock",
                                    default: "hourglass-half"
                                  ),
                                  color: a!match(
                                    value: fv!item.severity,
                                    equals: "Alta",
                                    then: "#DC2626",
                                    equals: "Media",
                                    then: "#F59E0B",
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
                                  a!richTextItem(text: fv!item.id & " - " & fv!item.name, style: "STRONG", size: "SMALL"),
                                  char(10),
                                  a!richTextItem(text: fv!item.issue, color: "#6B7280", size: "SMALL"),
                                  char(10),
                                  a!richTextIcon(icon: "clock", color: "#9CA3AF", size: "SMALL"),
                                  " ",
                                  a!richTextItem(text: "Esperando: " & fv!item.waitTime, color: "#9CA3AF", size: "SMALL")
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
                                    equals: "Atascada",
                                    then: "#DC2626",
                                    equals: "Espera Humana",
                                    then: "#F59E0B",
                                    default: "#6B7280"
                                  )
                                ),
                                size: "SMALL"
                              ),
                              width: "MINIMIZE"
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
                      marginBelow: "LESS",
                      link: a!dynamicLink(value: fv!item.id, saveInto: local!selectedExecution)
                    )
                  )
                },
                style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true, marginBelow: "STANDARD"
              ),

              /* Recent errors */
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "times-circle", color: "#DC2626", size: "MEDIUM"),
                      " ",
                      a!richTextItem(text: "Errores Recientes", size: "MEDIUM", style: "STRONG")
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!gridField(
                    data: local!recentErrors,
                    columns: {
                      a!gridColumn(label: "Cuando", value: fv!row.time, width: "NARROW"),
                      a!gridColumn(label: "Ejecucion", value: fv!row.execution, width: "NARROW_PLUS", sortField: "execution"),
                      a!gridColumn(label: "Agente", value: fv!row.agent, width: "NARROW_PLUS", sortField: "agent"),
                      a!gridColumn(label: "Error", value: fv!row.error, width: "MEDIUM"),
                      a!gridColumn(label: "#", value: fv!row.count, width: "ICON", align: "CENTER", sortField: "count")
                    },
                    pageSize: 5,
                    spacing: "DENSE",
                    borderStyle: "LIGHT",
                    emptyGridMessage: "No hay errores recientes."
                  )
                },
                style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
              )
            },
            width: "AUTO"
          ),

          /* RIGHT - Agent health */
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      a!richTextIcon(icon: "heartbeat", color: "#059669", size: "MEDIUM"),
                      " ",
                      a!richTextItem(text: "Estado de Agentes", size: "MEDIUM", style: "STRONG")
                    },
                    marginBelow: "STANDARD"
                  ),
                  a!forEach(
                    items: local!agentHealth,
                    expression: {
                      a!cardLayout(
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
                                    a!richTextItem(text: fv!item.name, style: "STRONG", size: "SMALL"),
                                    char(10),
                                    a!richTextItem(
                                      text: fv!item.status,
                                      color: a!match(
                                        value: fv!item.status,
                                        equals: "Operativo",
                                        then: "#059669",
                                        equals: "Alta Carga",
                                        then: "#F59E0B",
                                        equals: "Degradado",
                                        then: "#DC2626",
                                        default: "#6B7280"
                                      ),
                                      size: "SMALL",
                                      style: "STRONG"
                                    )
                                  }
                                ),
                                width: "AUTO"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  labelPosition: "COLLAPSED",
                                  value: a!richTextItem(
                                    text: text(fv!item.load, "0") & "%",
                                    style: "STRONG",
                                    color: if(
                                      fv!item.load > 80,
                                      "#DC2626",
                                      if(fv!item.load > 60, "#F59E0B", "#059669")
                                    ),
                                    size: "SMALL"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "MINIMIZE"
                              )
                            },
                            alignVertical: "MIDDLE",
                            spacing: "STANDARD"
                          ),
                          a!progressBarField(
                            percentage: fv!item.load,
                            color: if(
                              fv!item.load > 80,
                              "#DC2626",
                              if(fv!item.load > 60, "#F59E0B", "#059669")
                            ),
                            style: "THIN",
                            showPercentage: false,
                            labelPosition: "COLLAPSED",
                            marginBelow: "NONE",
                            marginAbove: "LESS"
                          )
                        },
                        style: "NONE",
                        shape: "ROUNDED",
                        padding: "STANDARD",
                        showBorder: true,
                        marginBelow: "LESS"
                      )
                    }
                  )
                },
                style: "NONE", shape: "ROUNDED", padding: "STANDARD", showBorder: true
              )
            },
            width: "MEDIUM_PLUS"
          )
        },
        spacing: "STANDARD"
      )
    },
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE"
  )
)