/* ==========================================================================
 * ORQUESTADOR DE AGENTES - DASHBOARD PRINCIPAL
 * ==========================================================================
 * Purpose: Main operational dashboard providing a global view of the
 *   agent orchestration system. Shows KPIs, recent executions, alerts,
 *   and quick-access navigation.
 *
 * REQUIREMENT: Display active executions, pending human reviews, errors,
 *   completions, most-used agents, and recent executions at a glance.
 * REQUIREMENT: Include quick actions: New Execution, Human Review,
 *   History, Agent Configuration.
 * ========================================================================== */

a!localVariables(
  /* KPI Data */
  local!activeExecutions: 12,
  local!pendingReview: 5,
  local!errorExecutions: 3,
  local!completedExecutions: 847,

  /* Quick filters */
  local!statusFilter,
  local!priorityFilter,
  local!dateFilter,

  /* Navigation */
  local!selectedTab: 1,
  local!selectedExecution,

  /* Recent executions data */
  local!recentExecutions: {
    a!map(
      id: "EXE-2026-0412",
      name: "Analisis Contractual Q1",
      project: "Proyecto Alpha",
      status: "En Curso",
      priority: "Alta",
      phase: "Agente Revisor",
      startDate: date(2026, 3, 25),
      agents: 4,
      humanReview: true
    ),
    a!map(
      id: "EXE-2026-0411",
      name: "Generacion de Informe Financiero",
      project: "Proyecto Beta",
      status: "Pendiente Validacion",
      priority: "Alta",
      phase: "Revision Humana",
      startDate: date(2026, 3, 25),
      agents: 3,
      humanReview: true
    ),
    a!map(
      id: "EXE-2026-0410",
      name: "Clasificacion Documentos Lote 47",
      project: "Proyecto Gamma",
      status: "Completado",
      priority: "Media",
      phase: "Finalizado",
      startDate: date(2026, 3, 24),
      agents: 2,
      humanReview: false
    ),
    a!map(
      id: "EXE-2026-0409",
      name: "Extraccion Datos Proveedores",
      project: "Proyecto Alpha",
      status: "Error",
      priority: "Alta",
      phase: "Agente Extractor",
      startDate: date(2026, 3, 24),
      agents: 3,
      humanReview: false
    ),
    a!map(
      id: "EXE-2026-0408",
      name: "Validacion Normativa RGPD",
      project: "Proyecto Delta",
      status: "En Curso",
      priority: "Media",
      phase: "Agente Validador",
      startDate: date(2026, 3, 24),
      agents: 5,
      humanReview: true
    ),
    a!map(
      id: "EXE-2026-0407",
      name: "Resumen Ejecutivo Trimestral",
      project: "Proyecto Beta",
      status: "Completado",
      priority: "Baja",
      phase: "Finalizado",
      startDate: date(2026, 3, 23),
      agents: 2,
      humanReview: false
    )
  },

  /* Alerts data */
  local!alerts: {
    a!map(
      type: "error",
      message: "Ejecucion EXE-0409 bloqueada: timeout del Agente Extractor",
      time: "Hace 2 horas"
    ),
    a!map(
      type: "warning",
      message: "5 tareas pendientes de revision humana con mas de 4 horas de espera",
      time: "Hace 3 horas"
    ),
    a!map(
      type: "info",
      message: "Agente Clasificador actualizado a version 2.3",
      time: "Hace 5 horas"
    )
  },

  /* Top agents data */
  local!topAgents: {
    a!map(name: "Agente Extractor", executions: 234, icon: "download", color: "#3B82F6"),
    a!map(name: "Agente Clasificador", executions: 198, icon: "tags", color: "#8B5CF6"),
    a!map(name: "Agente Revisor", executions: 176, icon: "check-double", color: "#059669"),
    a!map(name: "Agente Generador", executions: 145, icon: "file-text", color: "#F59E0B")
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
                      a!richTextItem(
                        text: "Orquestador de Agentes",
                        size: "LARGE",
                        style: "STRONG",
                        color: "#FFFFFF"
                      ),
                      char(10),
                      a!richTextItem(
                        text: "Panel de Control Operativo",
                        size: "MEDIUM",
                        color: "#94A3B8"
                      )
                    }
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!buttonArrayLayout(
                    buttons: {
                      a!buttonWidget(
                        label: "Nueva Ejecucion",
                        icon: "play",
                        style: "SOLID",
                        color: "ACCENT",
                        saveInto: {}
                      ),
                      a!buttonWidget(
                        label: "Revision Humana",
                        icon: "user-check",
                        style: "OUTLINE",
                        color: "#FFFFFF",
                        saveInto: {}
                      ),
                      a!buttonWidget(
                        label: "Historico",
                        icon: "history",
                        style: "OUTLINE",
                        color: "#FFFFFF",
                        saveInto: {}
                      ),
                      a!buttonWidget(
                        label: "Agentes",
                        icon: "robot",
                        style: "OUTLINE",
                        color: "#FFFFFF",
                        saveInto: {}
                      )
                    },
                    align: "END",
                    marginBelow: "NONE"
                  )
                },
                width: "AUTO"
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

      /* =====================================================================
       * KPI CARDS SECTION
       * ===================================================================== */
      a!cardGroupLayout(
        cards: {
          /* Active Executions */
          a!cardLayout(
            contents: {
              a!sideBySideLayout(
                items: {
                  a!sideBySideItem(
                    item: a!stampField(
                      icon: "play-circle",
                      backgroundColor: "#3B82F6",
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
                          text: "Ejecuciones Activas",
                          color: "#6B7280",
                          size: "STANDARD"
                        ),
                        char(10),
                        a!richTextItem(
                          text: text(local!activeExecutions, "##,###"),
                          style: "STRONG",
                          size: "LARGE",
                          color: "#262626"
                        )
                      }
                    ),
                    width: "AUTO"
                  )
                },
                alignVertical: "MIDDLE",
                spacing: "STANDARD"
              )
            },
            style: "#FFFFFF",
            showBorder: true,
            padding: "MORE",
            shape: "ROUNDED",
            link: a!dynamicLink(value: "active", saveInto: local!statusFilter)
          ),

          /* Pending Human Review */
          a!cardLayout(
            contents: {
              a!sideBySideLayout(
                items: {
                  a!sideBySideItem(
                    item: a!stampField(
                      icon: "user-clock",
                      backgroundColor: "#F59E0B",
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
                          text: "Pendientes Revision",
                          color: "#6B7280",
                          size: "STANDARD"
                        ),
                        char(10),
                        a!richTextItem(
                          text: text(local!pendingReview, "##,###"),
                          style: "STRONG",
                          size: "LARGE",
                          color: "#262626"
                        ),
                        char(10),
                        a!richTextIcon(
                          icon: "exclamation-triangle",
                          color: "#F59E0B",
                          size: "SMALL"
                        ),
                        " ",
                        a!richTextItem(
                          text: "Requieren atencion",
                          color: "#F59E0B",
                          size: "SMALL",
                          style: "STRONG"
                        )
                      }
                    ),
                    width: "AUTO"
                  )
                },
                alignVertical: "MIDDLE",
                spacing: "STANDARD"
              )
            },
            style: "#FFFFFF",
            showBorder: true,
            padding: "MORE",
            shape: "ROUNDED",
            link: a!dynamicLink(value: "pending", saveInto: local!statusFilter)
          ),

          /* Errors */
          a!cardLayout(
            contents: {
              a!sideBySideLayout(
                items: {
                  a!sideBySideItem(
                    item: a!stampField(
                      icon: "exclamation-circle",
                      backgroundColor: "#DC2626",
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
                          text: "Con Errores",
                          color: "#6B7280",
                          size: "STANDARD"
                        ),
                        char(10),
                        a!richTextItem(
                          text: text(local!errorExecutions, "##,###"),
                          style: "STRONG",
                          size: "LARGE",
                          color: "#DC2626"
                        )
                      }
                    ),
                    width: "AUTO"
                  )
                },
                alignVertical: "MIDDLE",
                spacing: "STANDARD"
              )
            },
            style: "#FFFFFF",
            showBorder: true,
            padding: "MORE",
            shape: "ROUNDED",
            link: a!dynamicLink(value: "error", saveInto: local!statusFilter)
          ),

          /* Completed */
          a!cardLayout(
            contents: {
              a!sideBySideLayout(
                items: {
                  a!sideBySideItem(
                    item: a!stampField(
                      icon: "check-circle",
                      backgroundColor: "#059669",
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
                          text: "Completadas (Total)",
                          color: "#6B7280",
                          size: "STANDARD"
                        ),
                        char(10),
                        a!richTextItem(
                          text: text(local!completedExecutions, "##,###"),
                          style: "STRONG",
                          size: "LARGE",
                          color: "#262626"
                        )
                      }
                    ),
                    width: "AUTO"
                  )
                },
                alignVertical: "MIDDLE",
                spacing: "STANDARD"
              )
            },
            style: "#FFFFFF",
            showBorder: true,
            padding: "MORE",
            shape: "ROUNDED",
            link: a!dynamicLink(value: "completed", saveInto: local!statusFilter)
          )
        },
        cardWidth: "NARROW_PLUS",
        spacing: "STANDARD"
      ),

      /* =====================================================================
       * MAIN CONTENT: TWO-COLUMN LAYOUT
       * ===================================================================== */
      a!columnsLayout(
        columns: {
          /* LEFT COLUMN - Recent Executions + Alerts */
          a!columnLayout(
            contents: {

              /* --- ALERTS SECTION --- */
              a!cardLayout(
                contents: {
                  a!sideBySideLayout(
                    items: {
                      a!sideBySideItem(
                        item: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextIcon(icon: "bell", color: "#F59E0B", size: "MEDIUM"),
                            " ",
                            a!richTextItem(
                              text: "Alertas y Bloqueos",
                              size: "MEDIUM",
                              style: "STRONG"
                            )
                          }
                        ),
                        width: "AUTO"
                      ),
                      a!sideBySideItem(
                        item: a!tagField(
                          labelPosition: "COLLAPSED",
                          tags: a!tagItem(
                            text: text(length(local!alerts), "0") & " activas",
                            backgroundColor: "#F59E0B"
                          ),
                          size: "SMALL"
                        ),
                        width: "MINIMIZE"
                      )
                    },
                    alignVertical: "MIDDLE",
                    marginBelow: "STANDARD"
                  ),
                  a!forEach(
                    items: local!alerts,
                    expression: a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: a!richTextIcon(
                              icon: a!match(
                                value: fv!item.type,
                                equals: "error",
                                then: "times-circle",
                                equals: "warning",
                                then: "exclamation-triangle",
                                default: "info-circle"
                              ),
                              color: a!match(
                                value: fv!item.type,
                                equals: "error",
                                then: "#DC2626",
                                equals: "warning",
                                then: "#F59E0B",
                                default: "#3B82F6"
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
                                text: fv!item.message,
                                size: "STANDARD"
                              ),
                              char(10),
                              a!richTextItem(
                                text: fv!item.time,
                                color: "#9CA3AF",
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
                style: "NONE",
                shape: "ROUNDED",
                padding: "STANDARD",
                showBorder: true,
                marginBelow: "STANDARD"
              ),

              /* --- RECENT EXECUTIONS TABLE --- */
              a!cardLayout(
                contents: {
                  a!sideBySideLayout(
                    items: {
                      a!sideBySideItem(
                        item: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: a!richTextItem(
                            text: "Ultimas Ejecuciones",
                            size: "MEDIUM",
                            style: "STRONG"
                          )
                        ),
                        width: "AUTO"
                      ),
                      a!sideBySideItem(
                        item: a!buttonArrayLayout(
                          buttons: a!buttonWidget(
                            label: "Ver todo",
                            icon: "arrow-right",
                            style: "LINK",
                            saveInto: {}
                          ),
                          marginBelow: "NONE"
                        ),
                        width: "MINIMIZE"
                      )
                    },
                    alignVertical: "MIDDLE",
                    marginBelow: "STANDARD"
                  ),

                  /* TODO-CONVERTER: Convert to showSearchBox: true */
                  a!gridField(
                    data: local!recentExecutions,
                    columns: {
                      a!gridColumn(
                        label: "Ejecucion",
                        value: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: {
                            a!richTextItem(
                              text: fv!row.id,
                              style: "STRONG",
                              link: a!dynamicLink(
                                value: fv!row.id,
                                saveInto: local!selectedExecution
                              ),
                              linkStyle: "STANDALONE"
                            ),
                            char(10),
                            a!richTextItem(
                              text: fv!row.name,
                              color: "#6B7280",
                              size: "SMALL"
                            )
                          }
                        ),
                        width: "MEDIUM",
                        sortField: "id"
                      ),
                      a!gridColumn(
                        label: "Proyecto",
                        value: fv!row.project,
                        width: "NARROW_PLUS",
                        sortField: "project"
                      ),
                      a!gridColumn(
                        label: "Estado",
                        value: a!tagField(
                          labelPosition: "COLLAPSED",
                          tags: a!tagItem(
                            text: fv!row.status,
                            /* TODO: Extract to expression rule - repeated logic for status color
                             * Used in: Dashboard grid, Historico grid, Detalle Ejecucion
                             * Logic: match on status text to color */
                            backgroundColor: a!match(
                              value: fv!row.status,
                              equals: "En Curso",
                              then: "#3B82F6",
                              equals: "Pendiente Validacion",
                              then: "#F59E0B",
                              equals: "Completado",
                              then: "#059669",
                              equals: "Error",
                              then: "#DC2626",
                              default: "#6B7280"
                            )
                          ),
                          size: "SMALL"
                        ),
                        width: "NARROW_PLUS",
                        sortField: "status"
                      ),
                      a!gridColumn(
                        label: "Fase",
                        value: fv!row.phase,
                        width: "NARROW_PLUS",
                        sortField: "phase"
                      ),
                      a!gridColumn(
                        label: "Prioridad",
                        value: a!tagField(
                          labelPosition: "COLLAPSED",
                          tags: a!tagItem(
                            text: fv!row.priority,
                            backgroundColor: a!match(
                              value: fv!row.priority,
                              equals: "Alta",
                              then: "#DC2626",
                              equals: "Media",
                              then: "#F59E0B",
                              default: "#6B7280"
                            )
                          ),
                          size: "SMALL"
                        ),
                        width: "NARROW",
                        sortField: "priority"
                      ),
                      a!gridColumn(
                        label: "",
                        value: a!richTextDisplayField(
                          labelPosition: "COLLAPSED",
                          value: if(
                            fv!row.humanReview,
                            a!richTextIcon(
                              icon: "user-check",
                              color: "#F59E0B",
                              altText: "Requiere revision humana"
                            ),
                            {}
                          )
                        ),
                        width: "ICON"
                      )
                    },
                    pageSize: 6,
                    initialSorts: a!sortInfo(field: "id", ascending: false),
                    spacing: "DENSE",
                    borderStyle: "LIGHT",
                    shadeAlternateRows: true,
                    emptyGridMessage: "No hay ejecuciones recientes."
                  )
                },
                style: "NONE",
                shape: "ROUNDED",
                padding: "STANDARD",
                showBorder: true
              )
            },
            width: "AUTO"
          ),

          /* RIGHT COLUMN - Top Agents */
          a!columnLayout(
            contents: {
              a!cardLayout(
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: a!richTextItem(
                      text: "Agentes Mas Usados",
                      size: "MEDIUM",
                      style: "STRONG"
                    ),
                    marginBelow: "STANDARD"
                  ),
                  a!forEach(
                    items: local!topAgents,
                    expression: a!cardLayout(
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
                                    text: fv!item.name,
                                    style: "STRONG",
                                    size: "STANDARD"
                                  ),
                                  char(10),
                                  a!richTextItem(
                                    text: text(fv!item.executions, "##,###") & " ejecuciones",
                                    color: "#6B7280",
                                    size: "SMALL"
                                  )
                                }
                              ),
                              width: "AUTO"
                            ),
                            a!sideBySideItem(
                              item: a!richTextDisplayField(
                                labelPosition: "COLLAPSED",
                                value: a!richTextIcon(
                                  icon: "angle-right",
                                  color: "#9CA3AF"
                                )
                              ),
                              width: "MINIMIZE"
                            )
                          },
                          alignVertical: "MIDDLE",
                          spacing: "STANDARD"
                        )
                      },
                      style: "NONE",
                      shape: "ROUNDED",
                      padding: "STANDARD",
                      showBorder: true,
                      showShadow: false,
                      marginBelow: "LESS",
                      link: a!dynamicLink(
                        value: fv!item.name,
                        saveInto: {}
                      )
                    )
                  )
                },
                style: "NONE",
                shape: "ROUNDED",
                padding: "STANDARD",
                showBorder: true
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