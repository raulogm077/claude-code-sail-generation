/* ==========================================================================
 * ORQUESTADOR DE AGENTES - CREACION / EDICION GUIADA (WIZARD)
 * ==========================================================================
 * Purpose: Step-by-step guided experience for launching a complex execution.
 *   Steps: Define objective, Select context, Select agents, Define order,
 *   Confirm human reviews, Review and launch.
 *
 * REQUIREMENT: Progressive disclosure with clear steps.
 * REQUIREMENT: Summary/review step before launching.
 * ========================================================================== */

a!localVariables(
  local!isUpdate: false(),
  local!cancel: false(),

  /* Step 1: Objective */
  local!jobName,
  local!description,
  local!priority: "Media",

  /* Step 2: Context */
  local!project,
  local!orchestrationType,
  local!contextNotes,

  /* Step 3: Agent selection */
  local!selectedAgents: tointeger({}),
  local!availableAgents: {
    a!map(id: 1, name: "Agente Extractor", specialty: "Extraccion de datos", icon: "download", color: "#3B82F6"),
    a!map(id: 2, name: "Agente Clasificador", specialty: "Clasificacion documental", icon: "tags", color: "#8B5CF6"),
    a!map(id: 3, name: "Agente Revisor", specialty: "Revision de calidad", icon: "check-double", color: "#059669"),
    a!map(id: 4, name: "Agente Generador", specialty: "Generacion de documentos", icon: "file-text", color: "#F59E0B"),
    a!map(id: 5, name: "Agente Validador", specialty: "Validacion normativa", icon: "shield", color: "#DC2626"),
    a!map(id: 6, name: "Agente Resumidor", specialty: "Resumen y sintesis", icon: "compress", color: "#EC4899")
  },

  /* Step 4: Order */
  local!orderedAgents: {
    a!map(order: 1, agentId: 1, name: "Agente Extractor"),
    a!map(order: 2, agentId: 3, name: "Agente Revisor"),
    a!map(order: 3, agentId: 4, name: "Agente Generador")
  },

  /* Step 5: Human reviews */
  local!humanReviewSteps: tointeger({}),

  a!wizardLayout(
    titleBar: a!headerTemplateFull(
      title: "Asistente de Creacion de Ejecucion",
      secondaryText: "Siga los pasos para configurar y lanzar una nueva orquestacion",
      backgroundColor: "#1C2C44"
    ),
    isTitleBarFixed: false(),
    showTitleBarDivider: false(),
    style: "DOT_VERTICAL",
    steps: {
      /* ===== STEP 1: DEFINE OBJECTIVE ===== */
      a!wizardStep(
        label: "Definir Objetivo",
        instructions: "Describa el proposito y alcance de la ejecucion",
        contents: {
          a!textField(
            label: "Nombre del Trabajo",
            labelPosition: "ABOVE",
            placeholder: "Ej: Analisis Contractual Q1 2026",
            value: local!jobName,
            saveInto: local!jobName,
            required: true(),
            validations: if(
              a!isNotNullOrEmpty(local!jobName),
              if(len(local!jobName) < 5, "El nombre debe tener al menos 5 caracteres", null),
              null
            ),
            marginBelow: "MORE"
          ),
          a!paragraphField(
            label: "Descripcion del Objetivo",
            labelPosition: "ABOVE",
            placeholder: "Describa que quiere lograr con esta ejecucion, que resultado espera obtener...",
            value: local!description,
            saveInto: local!description,
            required: true(),
            height: "MEDIUM",
            marginBelow: "MORE"
          ),
          a!radioButtonField(
            label: "Prioridad",
            labelPosition: "ABOVE",
            choiceLabels: {"Alta - Urgente", "Media - Normal", "Baja - Sin prisa"},
            choiceValues: {"Alta", "Media", "Baja"},
            value: local!priority,
            saveInto: local!priority,
            choiceLayout: "COMPACT"
          )
        },
        disableNextButton: or(
          a!isNullOrEmpty(local!jobName),
          a!isNullOrEmpty(local!description)
        )
      ),

      /* ===== STEP 2: SELECT CONTEXT ===== */
      a!wizardStep(
        label: "Seleccionar Contexto",
        instructions: "Seleccione el proyecto y tipo de flujo",
        contents: {
          a!dropdownField(
            label: "Proyecto Asociado",
            labelPosition: "ABOVE",
            placeholder: "Seleccione un proyecto",
            choiceLabels: {"Proyecto Alpha", "Proyecto Beta", "Proyecto Gamma", "Proyecto Delta"},
            choiceValues: {"alpha", "beta", "gamma", "delta"},
            value: local!project,
            saveInto: local!project,
            required: true(),
            marginBelow: "MORE"
          ),
          a!radioButtonField(
            label: "Tipo de Orquestacion",
            labelPosition: "ABOVE",
            choiceLabels: {
              "Secuencial - Agentes ejecutan uno tras otro",
              "Paralelo - Agentes ejecutan simultaneamente",
              "Condicional - Siguiente agente depende del resultado previo",
              "Mixto - Combinacion de flujos"
            },
            choiceValues: {"sequential", "parallel", "conditional", "mixed"},
            value: local!orchestrationType,
            saveInto: local!orchestrationType,
            required: true(),
            marginBelow: "MORE"
          ),
          a!paragraphField(
            label: "Notas de Contexto (Opcional)",
            labelPosition: "ABOVE",
            placeholder: "Informacion adicional para los agentes: fuentes de datos, restricciones, criterios especiales...",
            value: local!contextNotes,
            saveInto: local!contextNotes,
            height: "SHORT"
          )
        },
        disableNextButton: or(
          a!isNullOrEmpty(local!project),
          a!isNullOrEmpty(local!orchestrationType)
        )
      ),

      /* ===== STEP 3: SELECT AGENTS ===== */
      a!wizardStep(
        label: "Seleccionar Agentes",
        instructions: "Elija los agentes que participaran en la ejecucion",
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(icon: "info-circle", color: "#3B82F6", size: "SMALL"),
              " ",
              a!richTextItem(
                text: "Seleccione al menos un agente. En el siguiente paso podra definir el orden de ejecucion.",
                color: "#6B7280",
                size: "SMALL"
              )
            },
            marginBelow: "STANDARD"
          ),
          a!cardGroupLayout(
            cards: a!forEach(
              items: local!availableAgents,
              expression: a!cardLayout(
                contents: {
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
                            a!richTextItem(text: fv!item.name, style: "STRONG", size: "MEDIUM"),
                            char(10),
                            a!richTextItem(text: fv!item.specialty, color: "#6B7280", size: "SMALL")
                          }
                        ),
                        width: "AUTO"
                      )
                    },
                    alignVertical: "MIDDLE",
                    spacing: "STANDARD"
                  ),
                  if(
                    contains(local!selectedAgents, fv!item.id),
                    a!richTextDisplayField(
                      labelPosition: "COLLAPSED",
                      value: {
                        a!richTextIcon(icon: "check-circle", color: "#059669", size: "MEDIUM"),
                        " ",
                        a!richTextItem(text: "Seleccionado", color: "#059669", style: "STRONG", size: "SMALL")
                      },
                      align: "CENTER",
                      marginAbove: "STANDARD"
                    ),
                    a!buttonArrayLayout(
                      buttons: a!buttonWidget(
                        label: "Seleccionar",
                        style: "OUTLINE",
                        size: "SMALL",
                        saveInto: a!save(
                          local!selectedAgents,
                          append(local!selectedAgents, fv!item.id)
                        )
                      ),
                      align: "CENTER",
                      marginBelow: "NONE"
                    )
                  )
                },
                style: if(
                  contains(local!selectedAgents, fv!item.id),
                  "#F0FDF4",
                  "#FFFFFF"
                ),
                shape: "ROUNDED",
                padding: "STANDARD",
                showBorder: true,
                showShadow: false
              )
            ),
            cardWidth: "NARROW_PLUS",
            spacing: "STANDARD",
            cardHeight: "AUTO"
          ),
          if(
            length(local!selectedAgents) > 0,
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextIcon(icon: "check", color: "#059669", size: "SMALL"),
                " ",
                a!richTextItem(
                  text: text(length(local!selectedAgents), "0") & " agente(s) seleccionado(s)",
                  color: "#059669",
                  style: "STRONG",
                  size: "SMALL"
                )
              },
              marginAbove: "STANDARD"
            ),
            {}
          )
        },
        disableNextButton: length(local!selectedAgents) = 0
      ),

      /* ===== STEP 4: DEFINE ORDER ===== */
      a!wizardStep(
        label: "Definir Orden",
        instructions: "Establezca el orden de ejecucion de los agentes seleccionados",
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(icon: "info-circle", color: "#3B82F6", size: "SMALL"),
              " ",
              a!richTextItem(
                text: "Arrastre para reordenar o use los botones para mover agentes. El orden determina la secuencia de ejecucion.",
                color: "#6B7280",
                size: "SMALL"
              )
            },
            marginBelow: "STANDARD"
          ),
          a!forEach(
            items: local!orderedAgents,
            expression: a!cardLayout(
              contents: {
                a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!stampField(
                        text: text(fv!item.order, "0"),
                        backgroundColor: "#1C2C44",
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
                        value: a!richTextItem(text: fv!item.name, style: "STRONG", size: "MEDIUM")
                      ),
                      width: "AUTO"
                    ),
                    a!sideBySideItem(
                      item: a!buttonArrayLayout(
                        buttons: {
                          a!buttonWidget(
                            label: "Subir",
                            icon: "arrow-up",
                            style: "GHOST",
                            size: "SMALL",
                            disabled: fv!isFirst,
                            saveInto: {}
                          ),
                          a!buttonWidget(
                            label: "Bajar",
                            icon: "arrow-down",
                            style: "GHOST",
                            size: "SMALL",
                            disabled: fv!isLast,
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
              style: "NONE",
              shape: "ROUNDED",
              padding: "STANDARD",
              showBorder: true,
              marginBelow: "LESS"
            )
          )
        }
      ),

      /* ===== STEP 5: CONFIRM HUMAN REVIEWS ===== */
      a!wizardStep(
        label: "Revisiones Humanas",
        instructions: "Marque los pasos que requieren aprobacion humana antes de continuar",
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextIcon(icon: "user-check", color: "#F59E0B", size: "SMALL"),
              " ",
              a!richTextItem(
                text: "Las revisiones humanas pausaran la ejecucion hasta que un usuario apruebe o rechace el resultado del agente.",
                color: "#6B7280",
                size: "SMALL"
              )
            },
            marginBelow: "STANDARD"
          ),
          a!forEach(
            items: local!orderedAgents,
            expression: a!cardLayout(
              contents: {
                a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!stampField(
                        text: text(fv!item.order, "0"),
                        backgroundColor: "#1C2C44",
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
                        value: a!richTextItem(text: fv!item.name, style: "STRONG", size: "STANDARD")
                      ),
                      width: "AUTO"
                    ),
                    a!sideBySideItem(
                      item: a!checkboxField(
                        label: "Revision humana",
                        labelPosition: "COLLAPSED",
                        choiceLabels: {"Requiere revision humana"},
                        choiceValues: {fv!item.order},
                        value: if(
                          contains(local!humanReviewSteps, fv!item.order),
                          {fv!item.order},
                          tointeger({})
                        ),
                        saveInto: if(
                          contains(local!humanReviewSteps, fv!item.order),
                          a!save(
                            local!humanReviewSteps,
                            remove(local!humanReviewSteps, wherecontains(fv!item.order, local!humanReviewSteps))
                          ),
                          a!save(
                            local!humanReviewSteps,
                            append(local!humanReviewSteps, fv!item.order)
                          )
                        )
                      ),
                      width: "MINIMIZE"
                    )
                  },
                  alignVertical: "MIDDLE",
                  spacing: "STANDARD"
                )
              },
              style: if(
                contains(local!humanReviewSteps, fv!item.order),
                "#FEF3C7",
                "#FFFFFF"
              ),
              shape: "ROUNDED",
              padding: "STANDARD",
              showBorder: true,
              marginBelow: "LESS"
            )
          ),
          if(
            length(local!humanReviewSteps) > 0,
            a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextIcon(icon: "exclamation-triangle", color: "#F59E0B", size: "SMALL"),
                " ",
                a!richTextItem(
                  text: text(length(local!humanReviewSteps), "0") & " punto(s) de revision humana configurados. La ejecucion se pausara en estos pasos.",
                  color: "#F59E0B",
                  size: "SMALL",
                  style: "STRONG"
                )
              },
              marginAbove: "STANDARD"
            ),
            {}
          )
        }
      ),

      /* ===== STEP 6: REVIEW AND LAUNCH ===== */
      a!wizardStep(
        label: "Revisar y Lanzar",
        instructions: "Revise la configuracion antes de lanzar la ejecucion",
        contents: {
          /* Summary card */
          a!cardLayout(
            contents: {
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextIcon(icon: "rocket", color: "#3B82F6", size: "MEDIUM"),
                  " ",
                  a!richTextItem(text: "Resumen de la Ejecucion", size: "MEDIUM", style: "STRONG")
                },
                marginBelow: "MORE"
              ),

              /* Objective */
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Nombre: ", style: "STRONG"),
                  a!richTextItem(text: a!defaultValue(local!jobName, "Sin definir")),
                  char(10),
                  a!richTextItem(text: "Prioridad: ", style: "STRONG"),
                  a!richTextItem(text: a!defaultValue(local!priority, "Sin definir")),
                  char(10),
                  char(10),
                  a!richTextItem(text: "Descripcion:", style: "STRONG"),
                  char(10),
                  a!richTextItem(text: a!defaultValue(local!description, "Sin definir"), color: "#374151")
                },
                marginBelow: "MORE"
              ),

              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: "Proyecto: ", style: "STRONG"),
                  a!richTextItem(text: a!defaultValue(local!project, "Sin definir")),
                  char(10),
                  a!richTextItem(text: "Tipo de Orquestacion: ", style: "STRONG"),
                  a!richTextItem(text: a!defaultValue(local!orchestrationType, "Sin definir"))
                },
                marginBelow: "MORE"
              ),

              /* Pipeline summary */
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: a!richTextItem(text: "Pipeline de Agentes:", style: "STRONG"),
                marginBelow: "STANDARD"
              ),
              a!forEach(
                items: local!orderedAgents,
                expression: a!sideBySideLayout(
                  items: {
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: a!richTextItem(
                          text: text(fv!item.order, "0") & ". " & fv!item.name,
                          style: "STRONG",
                          size: "SMALL"
                        )
                      ),
                      width: "AUTO"
                    ),
                    a!sideBySideItem(
                      item: a!richTextDisplayField(
                        labelPosition: "COLLAPSED",
                        value: if(
                          contains(local!humanReviewSteps, fv!item.order),
                          {
                            a!richTextIcon(icon: "user-check", color: "#F59E0B", size: "SMALL"),
                            " ",
                            a!richTextItem(text: "Revision humana", color: "#F59E0B", size: "SMALL")
                          },
                          a!richTextItem(text: "Automatico", color: "#059669", size: "SMALL")
                        ),
                        align: "RIGHT"
                      ),
                      width: "MINIMIZE"
                    )
                  },
                  alignVertical: "MIDDLE",
                  spacing: "STANDARD",
                  marginBelow: if(fv!isLast, "NONE", "LESS")
                )
              ),

              /* Warning if human reviews */
              if(
                length(local!humanReviewSteps) > 0,
                {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    value: {
                      char(10),
                      a!richTextIcon(icon: "exclamation-triangle", color: "#F59E0B", size: "SMALL"),
                      " ",
                      a!richTextItem(
                        text: "Esta ejecucion se pausara " & text(length(local!humanReviewSteps), "0") & " vez/veces para revision humana.",
                        color: "#F59E0B",
                        style: "STRONG",
                        size: "SMALL"
                      )
                    },
                    marginAbove: "STANDARD"
                  )
                },
                {}
              )
            },
            style: "#F9FAFB",
            shape: "ROUNDED",
            padding: "MORE",
            showBorder: true
          )
        }
      )
    },
    contentsWidth: "MEDIUM",
    primaryButtons: {
      /* TODO-CONVERTER: Set all form fields to corresponding record type fields */
      a!buttonWidget(
        label: "Lanzar Ejecucion",
        icon: "rocket",
        submit: true(),
        style: "SOLID",
        color: "ACCENT",
        loadingIndicator: true(),
        showWhen: fv!isLastStep
      )
    },
    secondaryButtons: {
      /* TODO-CONVERTER: Set local!cancel to true, transform to ri!cancel */
      a!buttonWidget(
        label: "Cancelar",
        style: "LINK",
        saveInto: a!save(local!cancel, true()),
        validate: false()
      )
    }
  )
)