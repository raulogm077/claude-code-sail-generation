/* ==========================================================================
 * ORQUESTADOR DE AGENTES - CATALOGO DE AGENTES
 * ==========================================================================
 * Purpose: Professional catalog view of all available agents. Shows name,
 *   specialty, type, status, use cases, and last usage. Each agent card
 *   links to its detail page.
 *
 * REQUIREMENT: Show agent name, specialty, description, type, status,
 *   use cases, order of use, human validation requirement, last use.
 * ========================================================================== */

a!localVariables(
  local!searchText,
  local!typeFilter,
  local!statusFilter,
  local!selectedAgent,

  local!agents: {
    a!map(
      id: 1,
      name: "Agente Extractor",
      specialty: "Extraccion de datos",
      description: "Extrae datos estructurados de documentos PDF, Word, imagenes y correos electronicos. Soporta OCR y procesamiento de tablas.",
      type: "Procesamiento",
      status: "Activo",
      icon: "download",
      color: "#3B82F6",
      useCases: "Contratos, Facturas, Informes",
      order: 1,
      humanReview: false,
      lastUsed: "Hace 2 horas",
      totalExecutions: 234,
      successRate: 96
    ),
    a!map(
      id: 2,
      name: "Agente Clasificador",
      specialty: "Clasificacion documental",
      description: "Clasifica documentos por tipo, categoria y relevancia utilizando modelos de lenguaje especializados.",
      type: "Analisis",
      status: "Activo",
      icon: "tags",
      color: "#8B5CF6",
      useCases: "Documentos legales, Correspondencia, Informes",
      order: 2,
      humanReview: false,
      lastUsed: "Hace 3 horas",
      totalExecutions: 198,
      successRate: 94
    ),
    a!map(
      id: 3,
      name: "Agente Revisor",
      specialty: "Revision de calidad",
      description: "Revisa resultados de otros agentes, detecta errores, inconsistencias y clausulas de riesgo.",
      type: "Validacion",
      status: "Activo",
      icon: "check-double",
      color: "#059669",
      useCases: "Contratos, Compliance, Calidad",
      order: 3,
      humanReview: true,
      lastUsed: "Hace 1 hora",
      totalExecutions: 176,
      successRate: 98
    ),
    a!map(
      id: 4,
      name: "Agente Generador",
      specialty: "Generacion de documentos",
      description: "Genera informes, resumenes ejecutivos, propuestas y documentos a partir de datos estructurados.",
      type: "Generacion",
      status: "Activo",
      icon: "file-text",
      color: "#F59E0B",
      useCases: "Informes, Resumenes, Propuestas",
      order: 4,
      humanReview: false,
      lastUsed: "Hace 5 horas",
      totalExecutions: 145,
      successRate: 92
    ),
    a!map(
      id: 5,
      name: "Agente Validador",
      specialty: "Validacion normativa",
      description: "Valida datos y documentos contra marcos normativos (RGPD, ISO, regulaciones sectoriales).",
      type: "Validacion",
      status: "Activo",
      icon: "shield",
      color: "#DC2626",
      useCases: "RGPD, Normativas, Compliance",
      order: 5,
      humanReview: true,
      lastUsed: "Ayer",
      totalExecutions: 87,
      successRate: 99
    ),
    a!map(
      id: 6,
      name: "Agente Resumidor",
      specialty: "Resumen y sintesis",
      description: "Sintetiza grandes volumenes de informacion en resumenes concisos y accionables.",
      type: "Generacion",
      status: "Inactivo",
      icon: "compress",
      color: "#EC4899",
      useCases: "Actas, Reuniones, Investigacion",
      order: 6,
      humanReview: false,
      lastUsed: "Hace 3 dias",
      totalExecutions: 56,
      successRate: 91
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
                      a!richTextIcon(icon: "robot", color: "#94A3B8", size: "MEDIUM"),
                      " ",
                      a!richTextItem(
                        text: "Catalogo de Agentes",
                        size: "LARGE",
                        style: "STRONG",
                        color: "#FFFFFF"
                      ),
                      char(10),
                      a!richTextItem(
                        text: text(length(local!agents), "0") & " agentes disponibles en el sistema",
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
                  a!buttonArrayLayout(
                    buttons: a!buttonWidget(
                      label: "Registrar Nuevo Agente",
                      icon: "plus",
                      style: "SOLID",
                      color: "ACCENT",
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
                label: "Buscar agente",
                labelPosition: "COLLAPSED",
                placeholder: "Buscar por nombre o especialidad...",
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
                choiceLabels: {"Procesamiento", "Analisis", "Validacion", "Generacion"},
                choiceValues: {"Procesamiento", "Analisis", "Validacion", "Generacion"},
                value: local!typeFilter,
                saveInto: local!typeFilter
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
                choiceLabels: {"Activo", "Inactivo"},
                choiceValues: {"Activo", "Inactivo"},
                value: local!statusFilter,
                saveInto: local!statusFilter
              )
            },
            width: "NARROW_PLUS"
          )
        },
        spacing: "STANDARD",
        marginBelow: "STANDARD"
      ),

      /* Agent cards */
      a!cardGroupLayout(
        cards: a!forEach(
          items: local!agents,
          expression: a!cardLayout(
            contents: {
              /* Agent header with stamp */
              a!sideBySideLayout(
                items: {
                  a!sideBySideItem(
                    item: a!stampField(
                      icon: fv!item.icon,
                      backgroundColor: fv!item.color,
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
                          text: fv!item.name,
                          style: "STRONG",
                          size: "MEDIUM"
                        ),
                        char(10),
                        a!richTextItem(
                          text: fv!item.specialty,
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
                        backgroundColor: if(fv!item.status = "Activo", "#059669", "#6B7280")
                      ),
                      size: "SMALL"
                    ),
                    width: "MINIMIZE"
                  )
                },
                alignVertical: "MIDDLE",
                spacing: "STANDARD",
                marginBelow: "STANDARD"
              ),

              /* Description */
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: a!richTextItem(
                  text: fv!item.description,
                  color: "#374151",
                  size: "SMALL"
                ),
                marginBelow: "STANDARD"
              ),

              /* Metadata */
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "folder", color: "#9CA3AF", size: "SMALL"),
                  " ",
                  a!richTextItem(text: fv!item.useCases, color: "#6B7280", size: "SMALL"),
                  char(10),
                  a!richTextIcon(icon: "bar-chart", color: "#9CA3AF", size: "SMALL"),
                  " ",
                  a!richTextItem(
                    text: text(fv!item.totalExecutions, "##,###") & " ejecuciones | " & fv!item.successRate & "% exito",
                    color: "#6B7280",
                    size: "SMALL"
                  ),
                  char(10),
                  a!richTextIcon(icon: "clock", color: "#9CA3AF", size: "SMALL"),
                  " ",
                  a!richTextItem(text: "Ultimo uso: " & fv!item.lastUsed, color: "#6B7280", size: "SMALL")
                },
                marginBelow: "STANDARD"
              ),

              /* Tags */
              a!tagField(
                labelPosition: "COLLAPSED",
                tags: {
                  a!tagItem(text: fv!item.type, backgroundColor: "#EDEEF2", textColor: "#2E2E35"),
                  a!tagItem(text: "Orden: " & fv!item.order, backgroundColor: "#EDEEF2", textColor: "#2E2E35"),
                  if(
                    fv!item.humanReview,
                    a!tagItem(text: "Requiere revision humana", backgroundColor: "#FEF3C7", textColor: "#92400E"),
                    {}
                  )
                },
                size: "SMALL"
              )
            },
            style: "#FFFFFF",
            shape: "ROUNDED",
            padding: "STANDARD",
            showBorder: true,
            showShadow: false,
            link: a!dynamicLink(value: fv!item.id, saveInto: local!selectedAgent)
          )
        ),
        cardWidth: "MEDIUM",
        spacing: "STANDARD",
        cardHeight: "AUTO"
      )
    },
    backgroundColor: "#F5F6F8",
    contentsPadding: "MORE"
  )
)