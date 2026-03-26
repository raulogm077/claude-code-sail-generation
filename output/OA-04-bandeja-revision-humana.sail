/* ==========================================================================
 * ORQUESTADOR DE AGENTES - BANDEJA DE REVISION HUMANA
 * ==========================================================================
 * Purpose: Task inbox for "human in the loop" reviews. Shows pending tasks
 *   that require human intervention with context, actions, and priority.
 *
 * REQUIREMENT: Each task shows execution, agent, reason, context, priority.
 * REQUIREMENT: Actions: approve, reject, request changes, resend, escalate.
 * REQUIREMENT: Designed for fast review with sufficient context.
 * ========================================================================== */

a!localVariables(
  local!statusFilter,
  local!priorityFilter,
  local!searchText,
  local!selectedTask,

  local!reviewTasks: {
    a!map(
      id: "REV-001",
      executionId: "EXE-2026-0412",
      executionName: "Analisis Contractual Q1",
      agent: "Agente Revisor",
      agentIcon: "check-double",
      reason: "Clausulas de alto riesgo detectadas",
      summary: "Se detectaron 7 contratos con clausulas de alto riesgo en penalizaciones y limitacion de responsabilidad. Requiere validacion antes de generar informe.",
      expectedDecision: "Aprobar continuacion o solicitar revision manual de contratos",
      priority: "Alta",
      requestedAt: "Hace 25 min",
      project: "Proyecto Alpha",
      status: "Pendiente"
    ),
    a!map(
      id: "REV-002",
      executionId: "EXE-2026-0405",
      executionName: "Clasificacion Lote 48",
      agent: "Agente Clasificador",
      agentIcon: "tags",
      reason: "Confianza de clasificacion baja",
      summary: "12 documentos clasificados con confianza menor al 70%. El agente solicita revision humana para confirmar categorias antes de continuar.",
      expectedDecision: "Confirmar o reclasificar documentos de baja confianza",
      priority: "Media",
      requestedAt: "Hace 1 hora",
      project: "Proyecto Gamma",
      status: "Pendiente"
    ),
    a!map(
      id: "REV-003",
      executionId: "EXE-2026-0401",
      executionName: "Informe Regulatorio",
      agent: "Agente Validador",
      agentIcon: "shield",
      reason: "Discrepancia en requisitos normativos",
      summary: "Se encontraron 3 discrepancias entre los datos del informe y los requisitos RGPD actualizados. Se requiere criterio humano para la resolucion.",
      expectedDecision: "Resolver discrepancias y aprobar o solicitar correccion",
      priority: "Alta",
      requestedAt: "Hace 2 horas",
      project: "Proyecto Delta",
      status: "Pendiente"
    ),
    a!map(
      id: "REV-004",
      executionId: "EXE-2026-0398",
      executionName: "Extraccion Datos Financieros",
      agent: "Agente Extractor",
      agentIcon: "download",
      reason: "Formato no reconocido en 3 documentos",
      summary: "3 documentos PDF tienen formato protegido y no pudieron ser procesados automaticamente. Requiere decision sobre como proceder.",
      expectedDecision: "Saltar documentos, procesar manualmente, o reintentar con OCR",
      priority: "Baja",
      requestedAt: "Hace 4 horas",
      project: "Proyecto Beta",
      status: "Pendiente"
    ),
    a!map(
      id: "REV-005",
      executionId: "EXE-2026-0395",
      executionName: "Resumen Ejecutivo Mensual",
      agent: "Agente Generador",
      agentIcon: "file-text",
      reason: "Revision de contenido generado",
      summary: "El resumen ejecutivo generado esta listo para revision final antes de distribucion. Contiene 12 paginas con metricas clave y recomendaciones.",
      expectedDecision: "Aprobar publicacion o solicitar ajustes al contenido",
      priority: "Media",
      requestedAt: "Hace 5 horas",
      project: "Proyecto Beta",
      status: "Aprobado"
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
                      a!richTextIcon(icon: "user-check", color: "#F59E0B", size: "MEDIUM"),
                      " ",
                      a!richTextItem(
                        text: "Bandeja de Revision Humana",
                        size: "LARGE",
                        style: "STRONG",
                        color: "#FFFFFF"
                      ),
                      char(10),
                      a!richTextItem(
                        text: "Tareas que requieren intervencion y decision humana",
                        color: "#94A3B8",
                        size: "STANDARD"
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
                      a!richTextItem(
                        text: "4",
                        size: "LARGE",
                        style: "STRONG",
                        color: "#F59E0B"
                      ),
                      a!richTextItem(
                        text: " tareas pendientes",
                        color: "#94A3B8",
                        size: "MEDIUM"
                      )
                    },
                    align: "RIGHT"
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
      /* Filters row */
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  /* TODO-CONVERTER: Convert to showSearchBox: true */
                  a!textField(
                    label: "Buscar",
                    labelPosition: "COLLAPSED",
                    placeholder: "Buscar por ejecucion, agente o motivo...",
                    value: local!searchText,
                    saveInto: local!searchText
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Prioridad",
                    labelPosition: "COLLAPSED",
                    placeholder: "Todas las prioridades",
                    choiceLabels: {"Alta", "Media", "Baja"},
                    choiceValues: {"Alta", "Media", "Baja"},
                    value: local!priorityFilter,
                    saveInto: local!priorityFilter
                  )
                },
                width: "NARROW_PLUS"
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Estado",
                    labelPosition: "COLLAPSED",
                    placeholder: "Todos los estados",
                    choiceLabels: {"Pendiente", "Aprobado", "Rechazado"},
                    choiceValues: {"Pendiente", "Aprobado", "Rechazado"},
                    value: local!statusFilter,
                    saveInto: local!statusFilter
                  )
                },
                width: "NARROW_PLUS"
              )
            },
            spacing: "STANDARD"
          )
        },
        style: "NONE",
        shape: "ROUNDED",
        padding: "STANDARD",
        showBorder: true,
        marginBelow: "STANDARD"
      ),

      /* Task cards */
      a!forEach(
        items: local!reviewTasks,
        expression: a!cardLayout(
          contents: {
            /* Task header */
            a!columnsLayout(
              columns: {
                a!columnLayout(
                  contents: {
                    a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!stampField(
                            icon: fv!item.agentIcon,
                            backgroundColor: a!match(
                              value: fv!item.priority,
                              equals: "Alta",
                              then: "#DC2626",
                              equals: "Media",
                              then: "#F59E0B",
                              default: "#6B7280"
                            ),
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
                                text: fv!item.reason,
                                style: "STRONG",
                                size: "MEDIUM"
                              ),
                              char(10),
                              a!richTextItem(
                                text: fv!item.executionId & " - " & fv!item.executionName,
                                color: "#6B7280",
                                size: "SMALL",
                                link: a!dynamicLink(value: fv!item.executionId, saveInto: local!selectedTask),
                                linkStyle: "STANDALONE"
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
                  width: "AUTO"
                ),
                a!columnLayout(
                  contents: {
                    a!sideBySideLayout(
                      items: {
                        a!sideBySideItem(
                          item: a!tagField(
                            labelPosition: "COLLAPSED",
                            tags: {
                              a!tagItem(
                                text: fv!item.priority,
                                backgroundColor: a!match(
                                  value: fv!item.priority,
                                  equals: "Alta",
                                  then: "#DC2626",
                                  equals: "Media",
                                  then: "#F59E0B",
                                  default: "#6B7280"
                                )
                              ),
                              a!tagItem(
                                text: fv!item.status,
                                backgroundColor: a!match(
                                  value: fv!item.status,
                                  equals: "Pendiente",
                                  then: "#F59E0B",
                                  equals: "Aprobado",
                                  then: "#059669",
                                  equals: "Rechazado",
                                  then: "#DC2626",
                                  default: "#6B7280"
                                )
                              )
                            },
                            size: "SMALL"
                          ),
                          width: "MINIMIZE"
                        ),
                        a!sideBySideItem(
                          item: a!richTextDisplayField(
                            labelPosition: "COLLAPSED",
                            value: a!richTextItem(
                              text: fv!item.requestedAt,
                              color: "#9CA3AF",
                              size: "SMALL"
                            ),
                            align: "RIGHT"
                          ),
                          width: "MINIMIZE"
                        )
                      },
                      alignVertical: "MIDDLE",
                      spacing: "STANDARD"
                    )
                  },
                  width: "MEDIUM"
                )
              },
              alignVertical: "MIDDLE"
            ),

            /* Context section */
            a!cardLayout(
              contents: {
                a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextItem(text: "Contexto: ", style: "STRONG", size: "SMALL"),
                    a!richTextItem(text: fv!item.summary, color: "#374151", size: "SMALL")
                  },
                  marginBelow: "LESS"
                ),
                a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextIcon(icon: "lightbulb", color: "#8B5CF6", size: "SMALL"),
                    " ",
                    a!richTextItem(text: "Decision esperada: ", style: "STRONG", size: "SMALL", color: "#8B5CF6"),
                    a!richTextItem(text: fv!item.expectedDecision, color: "#6B7280", size: "SMALL")
                  }
                ),
                a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextIcon(icon: "robot", color: "#6B7280", size: "SMALL"),
                    " ",
                    a!richTextItem(text: "Agente: " & fv!item.agent, color: "#6B7280", size: "SMALL"),
                    "  |  ",
                    a!richTextIcon(icon: "folder", color: "#6B7280", size: "SMALL"),
                    " ",
                    a!richTextItem(text: fv!item.project, color: "#6B7280", size: "SMALL")
                  }
                )
              },
              style: "#F9FAFB",
              shape: "ROUNDED",
              padding: "STANDARD",
              showBorder: false,
              marginAbove: "STANDARD"
            ),

            /* Actions */
            if(
              fv!item.status = "Pendiente",
              a!buttonArrayLayout(
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
                  ),
                  a!buttonWidget(
                    label: "Pedir Cambios",
                    icon: "repeat",
                    style: "OUTLINE",
                    size: "SMALL",
                    saveInto: {}
                  ),
                  a!buttonWidget(
                    label: "Reenviar",
                    icon: "paper-plane",
                    style: "GHOST",
                    size: "SMALL",
                    saveInto: {}
                  ),
                  a!buttonWidget(
                    label: "Escalar",
                    icon: "arrow-up",
                    style: "GHOST",
                    size: "SMALL",
                    color: "NEGATIVE",
                    saveInto: {}
                  )
                },
                align: "END",
                marginBelow: "NONE"
              ),
              {}
            )
          },
          style: "NONE",
          shape: "ROUNDED",
          padding: "STANDARD",
          showBorder: true,
          marginBelow: "STANDARD",
          decorativeBarPosition: "START",
          decorativeBarColor: a!match(
            value: fv!item.priority,
            equals: "Alta",
            then: "#DC2626",
            equals: "Media",
            then: "#F59E0B",
            default: "#6B7280"
          )
        )
      )
    },
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE"
  )
)