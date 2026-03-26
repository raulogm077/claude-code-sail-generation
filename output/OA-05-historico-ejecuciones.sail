/* ==========================================================================
 * ORQUESTADOR DE AGENTES - HISTORICO DE EJECUCIONES
 * ==========================================================================
 * Purpose: Advanced searchable/filterable table of past executions.
 *   Allows users to find, review, and navigate to any past execution.
 *
 * REQUIREMENT: Filterable by date, status, project, type, agent, priority.
 * REQUIREMENT: Columns: ID, name, project, status, phase, dates, duration,
 *   agents involved, final result, human intervention yes/no.
 * ========================================================================== */

a!localVariables(
  local!searchText,
  local!statusFilter,
  local!projectFilter,
  local!priorityFilter,
  local!selectedExecution,

  local!executions: {
    a!map(id: "EXE-2026-0412", name: "Analisis Contractual Q1", project: "Proyecto Alpha", status: "En Curso", phase: "Agente Revisor", startDate: datetime(2026, 3, 25, 9, 15), endDate: "", duration: "En progreso", agents: "4 agentes", result: "Pendiente", humanReview: true),
    a!map(id: "EXE-2026-0411", name: "Generacion Informe Financiero", project: "Proyecto Beta", status: "Pendiente Validacion", phase: "Revision Humana", startDate: datetime(2026, 3, 25, 8, 30), endDate: "", duration: "En progreso", agents: "3 agentes", result: "Pendiente", humanReview: true),
    a!map(id: "EXE-2026-0410", name: "Clasificacion Documentos Lote 47", project: "Proyecto Gamma", status: "Completado", phase: "Finalizado", startDate: datetime(2026, 3, 24, 14, 0), endDate: datetime(2026, 3, 24, 14, 32), duration: "32 min", agents: "2 agentes", result: "Exitoso", humanReview: false),
    a!map(id: "EXE-2026-0409", name: "Extraccion Datos Proveedores", project: "Proyecto Alpha", status: "Error", phase: "Agente Extractor", startDate: datetime(2026, 3, 24, 11, 0), endDate: datetime(2026, 3, 24, 11, 18), duration: "18 min", agents: "3 agentes", result: "Fallido", humanReview: false),
    a!map(id: "EXE-2026-0408", name: "Validacion Normativa RGPD", project: "Proyecto Delta", status: "En Curso", phase: "Agente Validador", startDate: datetime(2026, 3, 24, 10, 0), endDate: "", duration: "En progreso", agents: "5 agentes", result: "Pendiente", humanReview: true),
    a!map(id: "EXE-2026-0407", name: "Resumen Ejecutivo Trimestral", project: "Proyecto Beta", status: "Completado", phase: "Finalizado", startDate: datetime(2026, 3, 23, 16, 0), endDate: datetime(2026, 3, 23, 16, 45), duration: "45 min", agents: "2 agentes", result: "Exitoso", humanReview: false),
    a!map(id: "EXE-2026-0406", name: "Analisis Sentimiento Encuestas", project: "Proyecto Gamma", status: "Completado", phase: "Finalizado", startDate: datetime(2026, 3, 23, 9, 0), endDate: datetime(2026, 3, 23, 9, 55), duration: "55 min", agents: "3 agentes", result: "Exitoso", humanReview: true),
    a!map(id: "EXE-2026-0405", name: "Clasificacion Lote 48", project: "Proyecto Gamma", status: "Pendiente Validacion", phase: "Revision Humana", startDate: datetime(2026, 3, 22, 15, 0), endDate: "", duration: "En progreso", agents: "2 agentes", result: "Pendiente", humanReview: true),
    a!map(id: "EXE-2026-0404", name: "Generacion Propuesta Comercial", project: "Proyecto Alpha", status: "Completado", phase: "Finalizado", startDate: datetime(2026, 3, 22, 10, 0), endDate: datetime(2026, 3, 22, 11, 12), duration: "1h 12min", agents: "4 agentes", result: "Exitoso", humanReview: false),
    a!map(id: "EXE-2026-0403", name: "Auditoria Datos Clientes", project: "Proyecto Delta", status: "Cancelado", phase: "Cancelado", startDate: datetime(2026, 3, 21, 14, 0), endDate: datetime(2026, 3, 21, 14, 5), duration: "5 min", agents: "1 agente", result: "Cancelado", humanReview: false)
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
                      a!richTextIcon(icon: "history", color: "#94A3B8", size: "MEDIUM"),
                      " ",
                      a!richTextItem(
                        text: "Historico de Ejecuciones",
                        size: "LARGE",
                        style: "STRONG",
                        color: "#FFFFFF"
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
                        label: "Exportar",
                        icon: "download",
                        style: "OUTLINE",
                        color: "#FFFFFF",
                        size: "SMALL",
                        saveInto: {}
                      ),
                      a!buttonWidget(
                        label: "Nueva Ejecucion",
                        icon: "play",
                        style: "SOLID",
                        color: "ACCENT",
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
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!columnLayout(
                contents: {
                  a!textField(
                    label: "Buscar",
                    labelPosition: "ABOVE",
                    placeholder: "Buscar por ID, nombre o proyecto...",
                    value: local!searchText,
                    saveInto: local!searchText
                  )
                },
                width: "AUTO"
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Estado",
                    labelPosition: "ABOVE",
                    placeholder: "Todos",
                    choiceLabels: {"En Curso", "Pendiente Validacion", "Completado", "Error", "Cancelado"},
                    choiceValues: {"En Curso", "Pendiente Validacion", "Completado", "Error", "Cancelado"},
                    value: local!statusFilter,
                    saveInto: local!statusFilter
                  )
                },
                width: "NARROW_PLUS"
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Proyecto",
                    labelPosition: "ABOVE",
                    placeholder: "Todos",
                    choiceLabels: {"Proyecto Alpha", "Proyecto Beta", "Proyecto Gamma", "Proyecto Delta"},
                    choiceValues: {"alpha", "beta", "gamma", "delta"},
                    value: local!projectFilter,
                    saveInto: local!projectFilter
                  )
                },
                width: "NARROW_PLUS"
              ),
              a!columnLayout(
                contents: {
                  a!dropdownField(
                    label: "Prioridad",
                    labelPosition: "ABOVE",
                    placeholder: "Todas",
                    choiceLabels: {"Alta", "Media", "Baja"},
                    choiceValues: {"Alta", "Media", "Baja"},
                    value: local!priorityFilter,
                    saveInto: local!priorityFilter
                  )
                },
                width: "NARROW"
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

      /* Executions grid */
      a!cardLayout(
        contents: {
          a!gridField(
            data: local!executions,
            columns: {
              a!gridColumn(
                label: "ID / Nombre",
                value: a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: {
                    a!richTextItem(
                      text: fv!row.id,
                      style: "STRONG",
                      link: a!dynamicLink(value: fv!row.id, saveInto: local!selectedExecution),
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
                      equals: "Cancelado",
                      then: "#6B7280",
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
                label: "Inicio",
                value: text(fv!row.startDate, "dd/MM/yyyy HH:mm"),
                width: "NARROW_PLUS",
                sortField: "startDate"
              ),
              a!gridColumn(
                label: "Duracion",
                value: fv!row.duration,
                width: "NARROW"
              ),
              a!gridColumn(
                label: "Agentes",
                value: fv!row.agents,
                width: "NARROW"
              ),
              a!gridColumn(
                label: "Resultado",
                value: a!tagField(
                  labelPosition: "COLLAPSED",
                  tags: a!tagItem(
                    text: fv!row.result,
                    backgroundColor: a!match(
                      value: fv!row.result,
                      equals: "Exitoso",
                      then: "#059669",
                      equals: "Fallido",
                      then: "#DC2626",
                      equals: "Cancelado",
                      then: "#6B7280",
                      default: "#F59E0B"
                    )
                  ),
                  size: "SMALL"
                ),
                width: "NARROW",
                sortField: "result"
              ),
              a!gridColumn(
                label: "",
                value: a!richTextDisplayField(
                  labelPosition: "COLLAPSED",
                  value: if(
                    fv!row.humanReview,
                    a!richTextIcon(icon: "user-check", color: "#F59E0B", altText: "Con revision humana"),
                    {}
                  )
                ),
                width: "ICON"
              )
            },
            pageSize: 10,
            initialSorts: a!sortInfo(field: "startDate", ascending: false),
            spacing: "DENSE",
            borderStyle: "LIGHT",
            shadeAlternateRows: true,
            emptyGridMessage: "No se encontraron ejecuciones con los filtros aplicados."
          )
        },
        style: "NONE",
        shape: "ROUNDED",
        padding: "STANDARD",
        showBorder: true
      )
    },
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE"
  )
)